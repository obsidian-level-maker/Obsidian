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
#include "hdr_ui.h"   // for mini map

#include <algorithm>

#include "csg_main.h"
#include "g_lua.h"
#include "lib_util.h"
#include "main.h"
#include "ui_dialog.h"


//!!!!! TEMP HACK
extern int Q1_begin_level(lua_State *L);
extern int Q1_end_level(lua_State *L);


std::vector<area_info_c *> all_areas;
std::vector<area_poly_c *> all_polys;

std::vector<entity_info_c *> all_entities;

std::vector<merge_vertex_c *>  mug_vertices;
std::vector<merge_segment_c *> mug_segments;
std::vector<merge_region_c *>  mug_regions;


static int cur_poly_time;


slope_plane_c::slope_plane_c() :
      sx(-1),sy(-1),sz(-1),
      ex(-1),ey(-1),ez(-1)
{ }

slope_plane_c::~slope_plane_c()
{ }

double slope_plane_c::GetAngle() const
{
  double xy_dist = ComputeDist(sx, sy, ex, ey);

  return CalcAngle(0, sz, xy_dist, ez);
}


area_info_c::area_info_c() :
      b_face(NULL), t_face(NULL), side(NULL),
      z1(-1), z2(-1), b_slope(NULL), t_slope(NULL),
///-- t_light(255), b_light(255),
      sec_kind(0), sec_tag(0), mark(0)
{
  time = cur_poly_time++;
}

area_info_c::~area_info_c()
{ }

area_info_c::area_info_c(const area_info_c *other) :
      b_face(other->b_face), t_face(other->t_face), side(other->side),
      z1(other->z1), z2(other->z2),
      b_slope(NULL), t_slope(NULL),
      sec_kind(other->sec_kind), sec_tag(other->sec_tag),
      mark(other->mark)
{
  time = other->time;  

  // FIXME: duplicate slopes
}


area_face_c::area_face_c() :
      tex(), x_offset(0), y_offset(0)
{ }

area_face_c::~area_face_c()
{ }


area_vert_c::area_vert_c() :
      x(0), y(0), face(NULL),
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


void CSG2_GetBounds(double& min_x, double& min_y, double& min_z,
                    double& max_x, double& max_y, double& max_z)
{
  min_x = min_y = min_z = +9e9;
  max_x = max_y = max_z = -9e9;

  for (unsigned int i = 0; i < mug_segments.size(); i++)
  {
    merge_segment_c *S = mug_segments[i];

    // ignore lines "in the solid"
    if (! S->HasGap())
      continue;

    double x1 = MIN(S->start->x, S->end->x);
    double y1 = MIN(S->start->y, S->end->y);

    double x2 = MAX(S->start->x, S->end->x);
    double y2 = MAX(S->start->y, S->end->y);

    min_x = MIN(min_x, x1);
    min_y = MIN(min_y, y1);

    max_x = MAX(max_x, x2);
    max_y = MAX(max_y, y2);

    if (S->front && S->front->HasGap())
    {
      min_z = MIN(min_z, S->front->MinGapZ());
      max_z = MAX(max_z, S->front->MaxGapZ());
    }

    if (S->back && S->back->HasGap())
    {
      min_z = MIN(min_z, S->back->MinGapZ());
      max_z = MAX(max_z, S->back->MaxGapZ());
    }
  }

  if (min_x > max_x)
    Main_FatalError("CSG2_GetBounds: map is completely solid!\n");

  // add some leeyway
  min_x -= 24; min_y -= 24; min_z -= 64;
  max_x += 24; max_y += 24; max_z += 64;
}

void CSG2_MakeMiniMap(void)
{
  int scale = 20;

  double min_x, min_y, min_z;
  double max_x, max_y, max_z;

  CSG2_GetBounds(min_x, min_y, min_z,  max_x, max_y, max_z);

  main_win->build_box->mini_map->MapBegin();

  for (unsigned int i = 0; i < mug_segments.size(); i++)
  {
    merge_segment_c *S = mug_segments[i];

    if (! S->HasGap())
      continue;

    int x1 = (int)ceil(S->start->x - min_x) / scale + 1;
    int y1 = (int)ceil(S->start->y - min_y) / scale + 1;
    int x2 = (int)ceil(S->end  ->x - min_x) / scale + 1;
    int y2 = (int)ceil(S->end  ->y - min_y) / scale + 1;

    bool two_sided = (S->front && S->front->gaps.size() > 0) &&
                     (S->back  && S->back ->gaps.size() > 0);

    u8_t r, g, b;

    // show drop-offs as green
    if (two_sided && fabs(S->front->gaps[0]->GetZ1() - S->back->gaps[0]->GetZ1()) > 24.5)
    {
      r = 128; g = 224; b = 72;
    }
    else
    {
      r = g = b = two_sided ? 176 : 255;
    }

    main_win->build_box->mini_map->DrawLine(x1,y1, x2,y2, r,g,b);
  }

  // entities
  for (unsigned k = 0; k < all_entities.size(); k++)
  {
    entity_info_c *E = all_entities[k];

    int x = (int)ceil(E->x - min_x) / scale + 1;
    int y = (int)ceil(E->y - min_y) / scale + 1;

    main_win->build_box->mini_map->DrawLine(x-1,y, x+1,y, 255,255,96);
    main_win->build_box->mini_map->DrawLine(x,y-1, x,y+1, 255,255,96);
  }

  main_win->build_box->mini_map->MapFinish();
}



//------------------------------------------------------------------------

static slope_plane_c * Grab_Slope(lua_State *L, int stack_pos)
{
  if (stack_pos < 0)
    stack_pos += lua_gettop(L) + 1;

  if (lua_type(L, stack_pos) != LUA_TTABLE)
  {
    luaL_argerror(L, stack_pos, "expected a table: slope info");
    return NULL; /* NOT REACHED */
  }

  slope_plane_c *P = new slope_plane_c();

  lua_getfield(L, stack_pos, "sx");
  lua_getfield(L, stack_pos, "sy");
  lua_getfield(L, stack_pos, "sz");

  P->sx = luaL_checknumber(L, -3);
  P->sy = luaL_checknumber(L, -2);
  P->sz = luaL_checknumber(L, -1);

  lua_pop(L, 3);

  lua_getfield(L, stack_pos, "ex");
  lua_getfield(L, stack_pos, "ey");
  lua_getfield(L, stack_pos, "ez");

  P->sx = luaL_checknumber(L, -3);
  P->sy = luaL_checknumber(L, -2);
  P->sz = luaL_checknumber(L, -1);

  lua_pop(L, 3);

#if 0
  if (A->z2 <= A->z1 + EPSILON)
  {
    return luaL_error(L, "add_brush: bad z1..z2 range given (%1.2f .. %1.2f)", A->z1, A->z2);
  }
#endif

  return P;
}


static area_face_c * Grab_Face(lua_State *L, int stack_pos)
{
  if (stack_pos < 0)
    stack_pos += lua_gettop(L) + 1;

  if (lua_type(L, stack_pos) != LUA_TTABLE)
  {
    luaL_argerror(L, stack_pos, "expected a table: face info");
    return NULL; /* NOT REACHED */
  }

  area_face_c *F = new area_face_c();

  lua_getfield(L, stack_pos, "texture");
//  lua_getfield(L, stack_pos, "x_offset");
//  lua_getfield(L, stack_pos, "y_offset");

  F->tex = std::string(luaL_checkstring(L, -1));

//  F->x_offset = luaL_checknumber(L, -2);
//  F->y_offset = luaL_checknumber(L, -1);

  lua_pop(L, 1);

  return F;
}


static area_info_c * Grab_AreaInfo(lua_State *L, int stack_pos)
{
  if (stack_pos < 0)
    stack_pos += lua_gettop(L) + 1;

  if (lua_type(L, stack_pos) != LUA_TTABLE)
  {
    luaL_argerror(L, stack_pos, "expected a table: area info");
    return NULL; /* NOT REACHED */
  }

  area_info_c *A = new area_info_c();

  lua_getfield(L, stack_pos, "t_face");
  lua_getfield(L, stack_pos, "b_face");
  lua_getfield(L, stack_pos, "w_face");

  A->t_face = Grab_Face(L, -3);
  A->b_face = Grab_Face(L, -2);
  A->side   = Grab_Face(L, -1);

  lua_pop(L, 3);

  // TODO: sec_kind, sec_tag   !!!!!
  // TODO: t_light, b_light
  // TODO: y_offset, peg
  // TODO: mark

  return A;
}


static area_vert_c * Grab_Vertex(lua_State *L, int stack_pos)
{
  if (stack_pos < 0)
    stack_pos += lua_gettop(L) + 1;

  if (lua_type(L, stack_pos) != LUA_TTABLE)
  {
    luaL_argerror(L, stack_pos, "expected a table: vertex");
    return NULL; /* NOT REACHED */
  }

  area_vert_c *V = new area_vert_c();

  lua_getfield(L, stack_pos, "x");
  lua_getfield(L, stack_pos, "y");

  V->x = luaL_checknumber(L, -2);
  V->y = luaL_checknumber(L, -1);

  lua_pop(L, 2);

  // TODO: w_face

  // TODO: kind, tag, flags, args

  return V;
}


static area_poly_c * Grab_LineLoop(lua_State *L, int stack_pos, area_info_c *A)
{
  if (lua_type(L, stack_pos) != LUA_TTABLE)
  {
    luaL_argerror(L, stack_pos, "expected a table: line loop");
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
  area_info_c *A = Grab_AreaInfo(L, 1);
  area_poly_c *P = Grab_LineLoop(L, 2, A);

  if (lua_isnumber(L, 3))
    A->z1 = lua_tonumber(L, 3);
  else
    A->b_slope = Grab_Slope(L, 3);

  if (lua_isnumber(L, 4))
    A->z2 = lua_tonumber(L, 4);
  else
    A->t_slope = Grab_Slope(L, 4);

  all_areas.push_back(A);

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

static const luaL_Reg csg_lib[] =
{
  { "begin_level", Q1_begin_level },  //!!!!! FIXME TEST CRUD
  { "end_level",   Q1_end_level   },

  { "add_brush",   csg2::add_brush  },
  { "add_entity",  csg2::add_entity },

  { NULL, NULL } // the end
};


void CSG2_Init(void)
{
  Script_RegisterLib("csg2", csg_lib);
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


void CSG2_FreeMerges(void)
{
  unsigned int k;

  for (k = 0; k < mug_vertices.size(); k++)
    delete mug_vertices[k];

  for (k = 0; k < mug_segments.size(); k++)
    delete mug_segments[k];

  for (k = 0; k < mug_regions.size(); k++)
    delete mug_regions[k];

  mug_vertices.clear();
  mug_segments.clear();
  mug_regions .clear();
}

void CSG2_FreeAll(void)
{
  CSG2_FreeMerges();

  unsigned int k;

  for (k = 0; k < all_areas.size(); k++)
    delete all_areas[k];

  for (k = 0; k < all_polys.size(); k++)
    delete all_polys[k];

  for (k = 0; k < all_entities.size(); k++)
    delete all_entities[k];

  all_areas.clear();
  all_polys.clear();
  all_entities.clear();
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
