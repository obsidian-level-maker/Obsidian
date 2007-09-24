//------------------------------------------------------------------------
//  2.5D Constructive Solid Geometry
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
#include "hdr_fltk.h"
#include "hdr_lua.h"

#include "g_solid.h"
#include "g_lua.h"

#include "main.h"
#include "lib_util.h"
#include "ui_dialog.h"
#include "ui_window.h"


namespace csg2
{

// LUA: begin_level(name)
//
int begin_level(lua_State *L)
{
  const char *name = luaL_checkstring(L,1);

  // TODO

  return 0;
}

// LUA: end_level()
//
int end_level(lua_State *L)
{
  // TODO

  return 0;
}


// LUA: add_thing(x, y, h, type, angle, flags, tid, special, args)
//
int add_thing(lua_State *L)
{
  // TODO

  return 0;
}

// LUA: add_solid()
//
int add_solid(lua_State *L)
{
  // TODO

  return 0;
}

} // namespace csg2


//------------------------------------------------------------------------

static const luaL_Reg csg2_funcs[] =
{
  { "begin_level", csg2::begin_level },
  { "end_level",   csg2::end_level   },

  { "add_thing",   csg2::add_thing   },
  { "add_solid",   csg2::add_solid   },

  { NULL, NULL } // the end
};


void CSG2_Init(void)
{
  Script_RegisterLib("csg2", csg2_funcs);
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
