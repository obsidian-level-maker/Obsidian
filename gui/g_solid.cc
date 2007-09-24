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


#define IVAL_NONE  -27777
#define FVAL_NONE  -27777.75


class merged_area_c;


class area_info_c
{
public:
  int time; // increases for each new solid area

  std::string t_tex;
  std::string b_tex;
  std::string w_tex;  // default

  ///  peg_mode_e  peg;  // default

  /// double y_offset;  // default

  int sec_kind, sec_tag;
  int t_light, b_light;

  // --- slope stuff ---

  double slope_tz1, slope_tz2;
  double slope_bz1, slope_bz2;
  double slope_x1, slope_y1, slope_x2, slope_y2;
  
public:
   area_info_c();
  ~area_info_c();
};


class area_side_c
{
public:
  std::string w_tex;
  std::string rail;

  /// peg_mode_e peg;
 
  double x_offset;
  double y_offset;

//??  merged_area_c *face;

public:
   area_side_c();
  ~area_side_c();
};


class area_vert_c
{
public:
  double x, y;

  area_side_c front;
  area_side_c back;

  int line_kind;
  int line_tag;
  int line_flags;

  byte line_args[5];

public:
   area_vert_c();
  ~area_vert_c();
};


class area_poly_c
{
public:
  area_info_c *info;

  std::vector<area_vert_c *> verts;

public:
   area_poly_c();
  ~area_poly_c();
};


std::vector<area_poly_c *> all_polys;


//------------------------------------------------------------------------

class merged_area_c
{
public:
  std::vector<area_poly_c *> polys;

public:
   merged_area_c();
  ~merged_area_c();
};


std::vector<merged_area_c *> all_merges;


static void CSG2_MergeAreas(void)
{
  // this takes all the area_polys, figures out what OVERLAPS
  // (on the 2D map), and performs the CSG operations to create
  // new area_polys for the overlapping parts.
  //
  // also figures out which area_polys are TOUCHING, and ensures
  // there are vertices where needed (at 'T' junctions).

  // TODO
}

static void CSG2_WriteDoom(void)
{
  // converts the Merged list into the sectors, linedefs (etc)
  // required for a DOOM level.
  
  // TODO
}

static void CSG2_WriteQuake(void)
{
  // converts the Merged list into a QUAKE ".map" file.

  // TODO
}


//------------------------------------------------------------------------

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

  // FIXME: free all polys

  return 0;
}


// LUA: add_thing(x, y, h, type, angle, flags, tid, special, args)
//
int add_thing(lua_State *L)
{
  // TODO

  return 0;
}


// LUA: add_solid(loop, info, z1, z2, slope_info)
//
// info is a table:
//   t_tex, b_tex  : top and bottom textures
//   w_tex         : default wall (side) texture
//   peg, y_offset : default peg and y_offset for sides
//   t_kind, t_tag
//   t_light, b_light
// 
// slope_info is a table (can be nil)
//    x1, y1, x2, y2  : coordinates on 2D map for slope points
//    tz1, tz2        : height coords for top slope
//    bz1, bz2        : height coords for bottom slope
//
// loop is an array of Vertices:
//    x, y,
//    front, back,
//    ln_kind, ln_tag, ln_flags, ln_args
//
// front and back are Sidedefs:
//    w_tex, peg, rail, x_offset, y_offset
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
