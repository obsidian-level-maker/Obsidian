//------------------------------------------------------------------------
//  2.5D Constructive Solid Geometry
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

#include <algorithm>

#include "csg_main.h"
#include "g_lua.h"
#include "lib_util.h"
#include "main.h"
#include "ui_dialog.h"


std::vector<area_info_c *> all_areas;
std::vector<area_poly_c *> all_polys;

std::vector<entity_info_c *> all_entities;

std::vector<merge_vertex_c *>  mug_vertices;
std::vector<merge_segment_c *> mug_segments;
std::vector<merge_region_c *>  mug_regions;


static int cur_poly_time;


slope_points_c::slope_points_c() :
      tz1(FVAL_NONE), tz2(FVAL_NONE),
      bz1(FVAL_NONE), bz2(FVAL_NONE),
      x1(0), y1(0), x2(0), y2(0)
{ }

slope_points_c::~slope_points_c()
{ }


area_info_c::area_info_c() :
      t_tex(), b_tex(), w_tex(),
      z1(-1), z2(-1), slope(),
      t_light(255), b_light(255),
      sec_kind(0), sec_tag(0), mark(0)
{
  time = cur_poly_time++;
}

area_info_c::~area_info_c()
{ }


area_side_c::area_side_c() :
      w_tex(), t_rail(), x_offset(0), y_offset(0)
{ }

area_side_c::~area_side_c()
{ }


area_vert_c::area_vert_c() :
      x(0), y(0), side(),
      line_kind(0), line_tag(0), line_flags(0),
      partner(NULL)
{
  memset(line_args, 0, sizeof(line_args));
}

area_vert_c::~area_vert_c()
{ }


area_poly_c::area_poly_c(area_info_c *_info) :
     info(_info), verts()
{ }

area_poly_c::~area_poly_c()
{
  // FIXME: free verts
}

void area_poly_c::Validate()
{
  if (verts.size() < 3)
    Main_FatalError("Line loop contains less than 3 vertices!\n");

  // make sure vertices are clockwise

  double average_ang = 0;

  for (unsigned int k = 0; k < verts.size(); k++)
  {
    area_vert_c *v1 = verts[k];
    area_vert_c *v2 = verts[(k+1) % (int)verts.size()];
    area_vert_c *v3 = verts[(k+2) % (int)verts.size()];

    double ang1 = CalcAngle(v2->x, v2->y, v1->x, v1->y);
    double ang2 = CalcAngle(v2->x, v2->y, v3->x, v3->y);

    double diff = ang2 - ang1;

    if (diff < 0) diff += 360.0;

// fprintf(stderr, "... [%d] ang1=%1.5f  ang2=%1.5f diff=%1.5f\n", (int)k, ang1, ang2, diff);

    average_ang += diff;
  }

  average_ang /= (double)verts.size();

// fprintf(stderr, "Average angle = %1.4f\n\n", average_ang);

  if (average_ang > 180.0)
    Main_FatalError("Line loop is not clockwise!\n");
}

void area_poly_c::ComputeBBox()
{
  min_x = +999999.9;
  min_y = +999999.9;
  max_x = -999999.9;
  max_y = -999999.9;

  for (unsigned int i = 0; i < verts.size(); i++)
  {
    area_vert_c *V = verts[i];

    if (V->x < min_x) min_x = V->x;
    if (V->x > max_x) max_x = V->x;

    if (V->y < min_y) min_y = V->y;
    if (V->y > max_y) max_y = V->y;
  }
}

entity_info_c::entity_info_c(const char *_name, double xpos, double ypos, double zpos) :
    name(_name), x(xpos), y(ypos), z(zpos)
{ }

entity_info_c::~entity_info_c()
{ }


//------------------------------------------------------------------------

static void AddPoly_MakeConvex(area_poly_c *P)
{
  // splits this area_poly into convex pieces (if needed) and
  // add each separate piece (sharing the same sector info).

  // TODO: Make convex  -  needed ???

  all_polys.push_back(P);
}


//------------------------------------------------------------------------

static area_info_c * Grab_SectorInfo(lua_State *L, int stack_pos)
{
  if (stack_pos < 0)
    stack_pos += lua_gettop(L) + 1;

  if (lua_type(L, stack_pos) != LUA_TTABLE)
  {
    luaL_argerror(L, stack_pos, "expected a table (sector info)");
    return 0; /* NOT REACHED */
  }

  area_info_c *A = new area_info_c();

  lua_getfield(L, stack_pos, "t_tex");
  lua_getfield(L, stack_pos, "b_tex");
  lua_getfield(L, stack_pos, "w_tex");

  A->t_tex = std::string(luaL_checkstring(L, -3));
  A->b_tex = std::string(luaL_checkstring(L, -2));
  A->w_tex = std::string(luaL_checkstring(L, -1));

  lua_pop(L, 3);

  // TODO: sec_kind, sec_tag   !!!!!
  // TODO: t_light, b_light
  // TODO: y_offset, peg
  // TODO: mark

  return A;
}


static int Grab_Heights(lua_State *L, int stack_pos, area_info_c *A)
{
  if (stack_pos < 0)
    stack_pos += lua_gettop(L) + 1;

  if (lua_type(L, stack_pos) != LUA_TTABLE)
  {
    return luaL_argerror(L, stack_pos, "expected a table (height info)");
  }

  lua_getfield(L, stack_pos, "z1");
  lua_getfield(L, stack_pos, "z2");

  A->z1 = luaL_checknumber(L, -2);
  A->z2 = luaL_checknumber(L, -1);

  lua_pop(L, 2);

  if (A->z2 <= A->z1 + EPSILON)
  {
    return luaL_error(L, "add_brush: bad z1..z2 range given (%1.2f .. %1.2f)", A->z1, A->z2);
  }

  // TODO: px1, py1, px2, py2,  tz1, tz2, bz1, bz2

  return 0;
}


static int Grab_Face(lua_State *L, int stack_pos, area_face_c *S)
{
  if (lua_type(L, stack_pos) != LUA_TTABLE)
  {
    return luaL_argerror(L, stack_pos, "expected a table (sidedef)");
  }

  // TODO

  Main_FatalError("CSG2: sidedef info not yet supported!\n");
  return 0; /* NOT REACHED */
}


static area_vert_c * Grab_Vertex(lua_State *L, int stack_pos)
{
  if (stack_pos < 0)
    stack_pos += lua_gettop(L) + 1;

  if (lua_type(L, stack_pos) != LUA_TTABLE)
  {
    luaL_argerror(L, stack_pos, "expected a table (vertex)");
    return NULL; /* NOT REACHED */
  }

  area_vert_c *V = new area_vert_c();

  lua_getfield(L, stack_pos, "x");
  lua_getfield(L, stack_pos, "y");

  V->x = luaL_checknumber(L, -2);
  V->y = luaL_checknumber(L, -1);

  lua_pop(L, 2);

  // TODO: side

  // TODO: kind, tag, flags, args

  return V;
}


static area_poly_c * Grab_LineLoop(lua_State *L, int stack_pos, area_info_c *A)
{
  if (lua_type(L, stack_pos) != LUA_TTABLE)
  {
    luaL_argerror(L, stack_pos, "expected a table (line loop)");
    return NULL; /* NOT REACHED */
  }

  area_poly_c *P = new area_poly_c(A);

  int index = 1;

  for (;;)
  {
    lua_pushinteger(L, index);
    lua_gettable(L, stack_pos);

    if (lua_isnil(L, -1))
    {
      lua_pop(L, 1);
      break;
    }

    area_vert_c *V = Grab_Vertex(L, -1);

    P->verts.push_back(V);

    lua_pop(L, 1);

    index++;
  }

  P->Validate();
  P->ComputeBBox();

  return P;
}


namespace csg2
{

// LUA: add_brush(info, loop, z1, z2)
//
// info is a table:
//    t_face, b_face : top and bottom faces
//    w_face         : default side face
//    liquid         : usually nil, otherwise a face table
//    clip           : usually nil, otherwise true
//    mark           : separating number
//    sec_kind, sec_tag (DOOM only)
// 
// z1 & z2 are either a height (number) or a slope table:
//    sx, sy, sz         : start point on slope
//    ex, ey, ez         : end point on slope
//
// loop is an array of Vertices:
//    x, y,
//    w_face (can be nil)
//    line_kind, line_tag,
//    line_flags, line_args
//    rail (DOOM only)
//
// face is a table:
//    texture
//    x_offset, y_offset
//    peg (DOOM only)
//
int add_brush(lua_State *L)
{
  area_info_c *A = Grab_SectorInfo(L, 1);

  all_areas.push_back(A);

  Grab_Heights(L, 3, A);

  area_poly_c *P = Grab_LineLoop(L, 2, A);

  AddPoly_MakeConvex(P);

  return 0;
}


// LUA: add_entity(name, x, y, z, info)
//
// info is a table:
//   options (DOOM, HEXEN)
//   args (HEXEN only)
//   light : amount of light emitted
//   ...
//
int add_entity(lua_State *L)
{
  const char *name = luaL_checkstring(L,1);

  double x = luaL_checknumber(L,2);
  double y = luaL_checknumber(L,3);
  double z = luaL_checknumber(L,4);

  entity_info_c *E = new entity_info_c(name, x, y, z);

  // TODO: extra info

  all_entities.push_back(E);

  return 0;
}

} // namespace csg2


//------------------------------------------------------------------------

static const luaL_Reg csg2_funcs[] =
{
  { "add_brush",   csg2::add_brush  },
  { "add_entity",  csg2::add_entity },

  { NULL, NULL } // the end
};


void CSG2_Init(void)
{
  Script_RegisterLib("csg2", csg2_funcs);
}

void CSG2_BeginLevel(void)
{
  cur_poly_time = 0;
}

void CSG2_EndLevel(void)
{
  // FIXME: free all_polys

  // FIXME: free all_merges
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
