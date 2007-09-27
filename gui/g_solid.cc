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

#include <algorithm>

#include "g_solid.h"
#include "g_doom.h"
#include "g_lua.h"

#include "main.h"
#include "lib_util.h"
#include "ui_dialog.h"
#include "ui_window.h"


#define IVAL_NONE  -27777
#define FVAL_NONE  -27777.75f


static int cur_poly_time;


class merged_area_c;


class slope_points_c
{
public:
  double tz1, tz2;
  double bz1, bz2;

  double x1, y1, x2, y2;

public:
  slope_points_c() : tz1(FVAL_NONE), tz2(FVAL_NONE),
                     bz1(FVAL_NONE), bz2(FVAL_NONE),
                     x1(0), y1(0), x2(0), y2(0)
  { }

  ~slope_points_c()
  { }
};


class area_info_c
{
public:
  int time; // increases for each new solid area

  std::string t_tex;
  std::string b_tex;
  std::string w_tex;  // default

  ///  peg_mode_e  peg;  // default

  /// double y_offset;  // default

  double z1, z2;

  slope_points_c slope;

  int sec_kind, sec_tag;
  int t_light, b_light;

public:
  area_info_c() : t_tex(), b_tex(), w_tex(),
                  z1(-1), z2(-1), slope(),
                  sec_kind(0), sec_tag(0),
                  t_light(255), b_light(255)
  {
    time = cur_poly_time++;
  }

  ~area_info_c()
  { }
};


class area_side_c
{
public:
  std::string w_tex;
  std::string t_rail;

  /// peg_mode_e peg;
 
  double x_offset;
  double y_offset;

//??  merged_area_c *face;

public:
  area_side_c() : w_tex(), t_rail(), x_offset(0), y_offset(0)
  { }

  ~area_side_c()
  { }
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
  area_vert_c() : x(0), y(0), front(), back(),
                  line_kind(0), line_tag(0), line_flags(0)
  {
    memset(line_args, 0, sizeof(line_args));
  }

  ~area_vert_c()
  { }
};


class area_poly_c
{
public:
  area_info_c *info;

  std::vector<area_vert_c *> verts;

  double min_x, min_y;
  double max_x, max_y;

public:
  area_poly_c(area_info_c *_info) : info(_info), verts()
  { }

  ~area_poly_c()
  {
    // FIXME: free verts
  }

  void ComputeBBox()
  {
    std::vector<area_vert_c *>::iterator VI;

    min_x = +999999.9;
    min_y = +999999.9;
    max_x = -999999.9;
    max_y = -999999.9;

    for (VI = verts.begin(); VI != verts.end(); VI++)
    {
      area_vert_c *V = *VI;

      if (V->x < min_x) min_x = V->x;
      if (V->x > max_x) max_x = V->x;

      if (V->y < min_y) min_y = V->y;
      if (V->y > max_y) max_y = V->y;
    }
  }
};


std::vector<area_info_c *> all_areas;
std::vector<area_poly_c *> all_polys;


//------------------------------------------------------------------------

static void AddPoly_MakeConvex(area_poly_c *P)
{
  // splits this area_poly into convex pieces (if needed) and
  // add each separate piece (sharing the same sector info).

  // TODO: Make convex

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

  // TODO: sec_kind, sec_tag
  // TODO: t_light, b_light
  // TODO: y_offset, peg

  return A;
}


static int Grab_Heights(lua_State *L, int stack_pos, area_info_c *A)
{
  A->z1 = luaL_checknumber(L, stack_pos + 0);
  A->z2 = luaL_checknumber(L, stack_pos + 1);

  if (A->z2 <= A->z1 + 0.1)
  {
    return luaL_error(L, "add_solid: bad z1..z2 range given (%1.2f .. %1.2f)", A->z1, A->z2);
  }

  return 0;
}


static int Grab_SlopeInfo(lua_State *L, int stack_pos, area_info_c *A)
{
  int what = lua_type(L, stack_pos);

  if (what == LUA_TNONE || what == LUA_TNIL)
    return 0;

  if (what != LUA_TTABLE)
  {
    luaL_argerror(L, stack_pos, "expected a table (slope info)");
    return 0; /* NOT REACHED */
  }

  // TODO

  Main_FatalError("CSG2: slope_info not yet supported!\n");
  return 0; /* NOT REACHED */
}


static int Grab_SideDef(lua_State *L, int stack_pos, area_side_c *S)
{
  if (lua_type(L, stack_pos) != LUA_TTABLE)
  {
    luaL_argerror(L, stack_pos, "expected a table (sidedef)");
    return 0; /* NOT REACHED */
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
    return 0; /* NOT REACHED */
  }

  area_vert_c *V = new area_vert_c();

  lua_getfield(L, stack_pos, "x");
  lua_getfield(L, stack_pos, "y");

  V->x = luaL_checknumber(L, -2);
  V->y = luaL_checknumber(L, -1);

  lua_pop(L, 2);

  // TODO: front, back
  // TODO: kind, tag, flags, args

  return V;
}


static area_poly_c * Grab_LineLoop(lua_State *L, int stack_pos, area_info_c *A)
{
  if (lua_type(L, stack_pos) != LUA_TTABLE)
  {
    luaL_argerror(L, stack_pos, "expected a table (line loop)");
    return 0; /* NOT REACHED */
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

  if (P->verts.size() < 3)
    Main_FatalError("line loop contains less than 3 vertices!\n");

  P->ComputeBBox();

  return P;
}


namespace csg2
{

// LUA: add_solid(info, loop, z1, z2, slope_info)
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
  area_info_c *A = Grab_SectorInfo(L, 1);

  all_areas.push_back(A);

  Grab_Heights(L, 3, A);
  Grab_SlopeInfo(L, 5, A);

  area_poly_c *P = Grab_LineLoop(L, 2, A);

  AddPoly_MakeConvex(P);

  return 0;
}

} // namespace csg2


//------------------------------------------------------------------------

class merged_area_c
{
public:
  // all polys for this area (sorted by height)
  std::vector<area_poly_c *> polys;

  int sector_index;

public:
   merged_area_c();
  ~merged_area_c();
};


std::vector<merged_area_c *> all_merges;


struct Compare_PolyMinX_pred
{
  inline bool operator() (const area_poly_c *A, const area_poly_c *B) const
  {
    return A->min_x < B->min_x;
  }
};

static void CSG2_MergeAreas(void)
{
  // this takes all the area_polys, figures out what OVERLAPS
  // (on the 2D map), and performs the CSG operations to create
  // new area_polys for the overlapping parts.
  //
  // also figures out which area_polys are TOUCHING, and ensures
  // there are vertices where needed (at 'T' junctions).


  /* STEP 1: sort area_polys from left to right */

  std::sort(all_polys.begin(), all_polys.end(), Compare_PolyMinX_pred());

  // TODO
}


//------------------------------------------------------------------------

static int total_sectors;
static int total_lines;

static void CreateSectors(void)
{
  total_sectors = 0;

  for (int i = 0; i < (int)all_merges.size(); i++)
  {
    merged_area_c *M = all_merges[i];

    SYS_ASSERT(M);

    if (M->sector_index < 0)
    {
      M->sector_index = total_sectors;
      total_sectors++;

      // FIXME: propagate step:
      //   (1) clear the 'process' list, add in current area
      //   (2) iterate over process list
      //   (3) if neighbour area has no sector AND matches this area,
      //       propagate the sector index into it,
      //       THEN add all the new neighbours into new process list.
      //   (4) when done, old list := new list
      //   (5) if new list not empty, goto 2
    }
  }
}

static void CreateLinedefs(void)
{
  total_lines = 0;

  for (int i = 0; i < (int)all_merges.size(); i++)
  {
    merged_area_c *M = all_merges[i];

    SYS_ASSERT(M->polys.size() > 0);

    int num_vert = (int)M->polys[0]->verts.size();

    for (int j1 = 0; j1 < num_vert; j1++)
    {
      int j2 = (j1 + 1) % num_vert;

      area_vert_c *v1 = M->polys[0]->verts[j1];
      area_vert_c *v2 = M->polys[0]->verts[j2];

      SYS_ASSERT(v1 && v2);

      // FIXME !!!
    }
  }
}

static void CSG2_WriteDoom(void)
{
  // converts the Merged list into the sectors, linedefs (etc)
  // required for a DOOM level.
  
  CSG2_MergeAreas();

  CreateSectors();

  CreateLinedefs();

  // FIXME: things !!!!
}

static void CSG2_TestDoom(void)
{
  // for debugging only: each area_poly_c becomes a single sector
  // on the map.
 
  std::vector<area_poly_c *>::iterator PLI;

#if 1
  CSG2_MergeAreas();

  for (int r = 0; r < (int)all_merges.size(); r++)
  if ( (PLI = all_merges[r]->polys.begin()), true )
#else
  for (PLI = all_polys.begin(); PLI != all_polys.end(); PLI++)
#endif
  {
    area_poly_c *P = *PLI;
    area_info_c *A = P->info;
    
    int sec_idx = wad::num_sectors();

    wad::add_sector(I_ROUND(A->z1), A->b_tex.c_str(),
                    I_ROUND(A->z2), A->t_tex.c_str(),
                    192, 0, 0);

    int side_idx = wad::num_sidedefs();

    wad::add_sidedef(sec_idx, "-", A->w_tex.c_str(), "-", 0, 0);

    int vert_base = wad::num_vertexes();

    for (int j1 = 0; j1 < (int)P->verts.size(); j1++)
    {
      int j2 = (j1 + 1) % (int)P->verts.size();

      area_vert_c *v1 = P->verts[j1];
      area_vert_c *v2 = P->verts[j2];

      wad::add_vertex(I_ROUND(v1->x), I_ROUND(v1->y));

      wad::add_linedef(vert_base+j1, vert_base+j2, side_idx, -1,
                       0, 1 /*impassible*/, 0, NULL /* args */);
    }
  }
}


//------------------------------------------------------------------------

static FILE *map_fp;

static void Q_WriteField(const char *field, const char *val_str, ...)
{
  fprintf(map_fp, "  \"%s\"  \"", field);

  va_list args;

  va_start(args, val_str);
  vfprintf(map_fp, val_str, args);
  va_end(args);

  fprintf(map_fp, "\"\n");
}

static void Q_WriteBrush(area_poly_c *P)
{
  fprintf(map_fp, "  {\n");

  // TODO: slopes

  // TODO: x/y offsets

  // Top
  fprintf(map_fp, "    ( %1.1f %1.1f %1.1f ) ( %1.1f %1.1f %1.1f ) ( %1.1f %1.1f %1.1f ) %s 0 0 0 1 1\n",
      0.0, 0.0, P->info->z2,
      0.0, 1.0, P->info->z2,
      1.0, 0.0, P->info->z2,
      P->info->t_tex.c_str());

  // Bottom
  fprintf(map_fp, "    ( %1.1f %1.1f %1.1f ) ( %1.1f %1.1f %1.1f ) ( %1.1f %1.1f %1.1f ) %s 0 0 0 1 1\n",
      0.0, 0.0, P->info->z1,
      1.0, 0.0, P->info->z1,
      0.0, 1.0, P->info->z1,
      P->info->b_tex.c_str());

  // Sides
  for (int j1 = 0; j1 < (int)P->verts.size(); j1++)
  {
    int j2 = (j1 + 1) % (int)P->verts.size();

    area_vert_c *v1 = P->verts[j1];
    area_vert_c *v2 = P->verts[j2];

    SYS_ASSERT(v1 && v2);

    const char *tex = v1->front.w_tex.c_str();
    if (strlen(tex) == 0)
      tex = P->info->w_tex.c_str();

    SYS_ASSERT(tex);

    fprintf(map_fp, "    ( %1.1f %1.1f %1.1f ) ( %1.1f %1.1f %1.1f ) ( %1.1f %1.1f %1.1f ) %s 0 0 0 1 1\n",
        v1->x, v1->y, P->info->z1,
        v2->x, v2->y, P->info->z1,
        v1->x, v1->y, P->info->z2, tex);
  }

  fprintf(map_fp, "  }\n");
}

static void CSG2_TestQuake(void)
{
  // converts the area_poly list into a QUAKE ".map" file.

  map_fp = fopen("TEST.map", "w");
  SYS_ASSERT(map_fp);

  fprintf(map_fp, "{\n");

  Q_WriteField("classname", "worldspawn");
  Q_WriteField("worldtype", "0");
  Q_WriteField("wad", "textures.wad");

  fprintf(map_fp, "\n");

  for (int i = 0; i < (int)all_polys.size(); i++)
  {
    area_poly_c *P = all_polys[i];
    SYS_ASSERT(P);

    Q_WriteBrush(P);
  }

  fprintf(map_fp, "}\n\n");

  // FIXME: entities !!!!

  fclose(map_fp);
}


//------------------------------------------------------------------------

static const luaL_Reg csg2_funcs[] =
{
  { "add_solid",   csg2::add_solid   },

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
  CSG2_TestQuake();
  CSG2_TestDoom();

  // FIXME: free all_polys

  // FIXME: free all_merges
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
