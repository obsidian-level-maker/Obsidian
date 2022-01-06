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
  lapi.h
  lauxlib.c
  lauxlib.h
  lbaselib.c
  lcode.c
  lcode.h
  lcorolib.c
  lctype.c
  lctype.h
  ldblib.c
  ldebug.c
  ldebug.h
  ldo.c
  ldo.h
  ldump.c
  lfunc.c
  lfunc.h
  lgc.c
  lgc.h
  linit.c
  liolib.c
  ljumptab.h
  llex.c
  llex.h
  llimits.h
  lmathlib.c
  lmem.c
  lmem.h
  loadlib.c
  lobject.c
  lobject.h
  lopcodes.c
  lopcodes.h
  lopnames.h
  loslib.c
  lparser.c
  lparser.h
  lprefix.h
  lstate.c
  lstate.h
  lstring.c
  lstring.h
  lstrlib.c
  ltable.c
  ltable.h
  ltablib.c
  ltm.c
  ltm.h
  lua.hpp
  luaconf.h
  lualib.h
  lundump.c
  lundump.h
  lutf8lib.c
  lvm.c
  lvm.h
  lzio.c
  lzio.h
)
