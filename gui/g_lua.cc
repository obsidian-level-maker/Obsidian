//------------------------------------------------------------------------
//  LUA interface
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006,2007 Andrew Apted
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include "headers.h"
#include "hdr_lua.h"

#include "g_lua.h"
#include "g_doom.h"
#include "g_glbsp.h"
#include "g_wolf.h"
#include "main.h"

#include "hdr_fltk.h"
#include "lib_util.h"
#include "twister.h"
#include "ui_dialog.h"
#include "ui_window.h"


static lua_State *LUA_ST;

static const char *script_path;


namespace con
{

// random number generator (Mersenne Twister)
MT_rand_c RNG(0);

// state needed for progress() call
int lev_IDX = 0;
int lev_TOTAL = 0;


// LUA: raw_log_print(str)
//
int raw_log_print(lua_State *L)
{
  int nargs = lua_gettop(L);

  if (nargs >= 1)
  {
    const char *res = luaL_checkstring(L,1);
    SYS_ASSERT(res);

    LogPrintf("%s", res);
  }

  return 0;
}

// LUA: raw_debug_print(str)
//
int raw_debug_print(lua_State *L)
{
  int nargs = lua_gettop(L);

  if (nargs >= 1)
  {
    const char *res = luaL_checkstring(L,1);
    SYS_ASSERT(res);

    DebugPrintf("%s", res);
  }

  return 0;
}


// LUA: at_level(name, idx, total)
//
int at_level(lua_State *L)
{
  lev_IDX = luaL_checkint(L, 2);
  lev_TOTAL = luaL_checkint(L, 3);

  return 0;
}

// LUA: progress(percent)
//
int progress(lua_State *L)
{
  lua_Number perc = luaL_checknumber(L, 1);

  SYS_ASSERT(lev_TOTAL > 0);

  perc = ((lev_IDX-1) * 100 + perc) / lev_TOTAL;

  main_win->build_box->ProgUpdate(perc);

  return 0;
}


// LUA: ticker()
//
int ticker(lua_State *L)
{
  Main_Ticker();

  return 0;
}

// LUA: abort() -> boolean
//
int abort(lua_State *L)
{
  int value = 0;

  if (main_win->action >= UI_MainWin::ABORT)
    value = 1;

  lua_pushboolean(L, value);
  return 1;
}


// LUA: map_begin(pixel_W, pixel_H)
//
int map_begin(lua_State *L)
{
  int pixel_W = luaL_checkint(L, 1);
  int pixel_H = luaL_checkint(L, 2);

  SYS_ASSERT(1 <= pixel_W && pixel_W < 1000);
  SYS_ASSERT(1 <= pixel_H && pixel_H < 1000);

  main_win->build_box->MapBegin(pixel_W, pixel_H);

  return 0;
}

// LUA: map_end()
//
int map_end(lua_State *L)
{
  main_win->build_box->MapFinish();

  return 0;
}

// LUA: map_pixel(kind)
//
int map_pixel(lua_State *L)
{
  int kind = luaL_checkint(L, 1);

  main_win->build_box->MapPixel(kind);

  return 0;
}

// LUA: rand_seed(seed)
//
int rand_seed(lua_State *L)
{
  int the_seed = luaL_checkint(L, 1) & 0x7FFFFFFF;

  RNG.Seed(the_seed);

  return 0;
}

// LUA: random()
//
int random(lua_State *L)
{
  int raw = RNG.Rand() & 0x7FFFFFFF;

  // target range is [0-1), including 0 but not including 1
  lua_Number value = (lua_Number)raw / 2147483648.0;

  lua_pushnumber(L, value);
  return 1;
}

} // namespace con


static const luaL_Reg console_lib[] =
{
  { "raw_log_print",   con::raw_log_print },
  { "raw_debug_print", con::raw_debug_print },

  { "at_level",   con::at_level },
  { "progress",   con::progress },
  { "ticker",     con::ticker },
  { "abort",      con::abort },
  
  { "map_begin",  con::map_begin },
  { "map_pixel",  con::map_pixel },
  { "map_end",    con::map_end },

  { "rand_seed",  con::rand_seed },
  { "random",     con::random },

  { NULL, NULL } // the end
};

int Script_CreateConLib(lua_State *L)
{
  luaL_register(L, "con", console_lib);

  return 0;
}


//------------------------------------------------------------------------


static int p_init_lua(lua_State *L)
{
  /* stop collector during initialization */
  lua_gc(L, LUA_GCSTOP, 0);
  {
    luaL_openlibs(L);  /* open libraries */

    Script_CreateConLib(L);
  }
  lua_gc(L, LUA_GCRESTART, 0);

  return 0;
}

static void Script_SetLoadPath(lua_State *L)
{
  script_path = StringPrintf("%s/scripts/?.lua", install_path);

  LogPrintf("script_path: [%s]\n\n", script_path);

  lua_getglobal(L, "package");

  if (lua_type(L, -1) == LUA_TNIL)
    Main_FatalError("LUA SetPath failed: no 'package' module!");

  lua_pushstring(L, script_path);

  lua_setfield(L, -2, "path");

  lua_pop(L, 1);
}

void Script_Init(void)
{
  LUA_ST = lua_open();
  if (! LUA_ST)
    Main_FatalError("LUA Init failed: cannot create new state");

  int status = lua_cpcall(LUA_ST, &p_init_lua, NULL);
  if (status != 0)
    Main_FatalError("LUA Init failed: cannot load standard libs (%d)", status);

  Script_SetLoadPath(LUA_ST);

  Doom_InitLua(LUA_ST);
  Wolf_InitLua(LUA_ST);
}

void Script_Close(void)
{
  if (LUA_ST)
  {
    lua_close(LUA_ST);

    LUA_ST = NULL;
  }
}

void Script_Load(void)
{
  int status = luaL_loadstring(LUA_ST, "require 'oblige'");

  if (status == 0)
    status = lua_pcall(LUA_ST, 0, 0, 0);

  if (status != 0)
  {
    const char *msg = lua_tolstring(LUA_ST, -1, NULL);

    Main_FatalError("Unable to load script 'oblige.lua' (%d)\n%s", status, msg);
  }

///---  if (status != 0)
///---  {
///---    const char *msg = lua_tolstring(LUA_ST, -1, NULL);
///---
///---    Main_FatalError("Error with script (%d)\n%s", status, msg);
///---  }
}


static void AddField(lua_State *L, const char *key, const char *value)
{
  SYS_NULL_CHECK(value);

  lua_pushstring(L, key);
  lua_pushstring(L, value);
  lua_rawset(L, -3);
}

static void Script_MakeSettings(lua_State *L)
{
  lua_newtable(L);

  AddField(L, "seed",  main_win->setup_box->get_Seed());

  AddField(L, "game",  main_win->setup_box->get_Game());
  AddField(L, "port",  main_win->setup_box->get_Port());
  AddField(L, "mode",  main_win->setup_box->get_Mode());
  AddField(L, "length",main_win->setup_box->get_Length());

  AddField(L, "health", main_win->adjust_box->get_Health());
  AddField(L, "ammo",   main_win->adjust_box->get_Ammo());
  AddField(L, "mons",   main_win->adjust_box->get_Monsters());
  AddField(L, "traps",  main_win->adjust_box->get_Traps());
  AddField(L, "size",   main_win->adjust_box->get_Size());

  lua_setglobal(L, "settings");
}

int Script_Run(void)
{
  Script_MakeSettings(LUA_ST);

  // LUA: build_cool_shit()
  //
  lua_getglobal(LUA_ST, "build_cool_shit");

  if (lua_type(LUA_ST, -1) == LUA_TNIL)
    Main_FatalError("LUA script problem: missing build function!");

  int status = lua_pcall(LUA_ST, 0, 1, 0);
  if (status != 0)
  {
    const char *msg = lua_tolstring(LUA_ST, -1, NULL);

    DLG_ShowError("Problem occurred while making level:\n%s", msg);

    return RUN_Error;
  }

  const char *res = lua_tolstring(LUA_ST, -1, NULL);

  if (res && strcmp(res, "ok") == 0)
    return RUN_Good;

  if (res && strcmp(res, "abort") == 0)
    return RUN_Abort;

  return RUN_Error;
}

