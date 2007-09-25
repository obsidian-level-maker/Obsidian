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
#include "g_doom.h"
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

  double z1, z2;

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
  std::string t_rail;

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

namespace csg2
{

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

  area_poly_c *P = new area_poly_c();

  // ...

  all_polys.push_back(P);
  
  return 0;
}

} // namespace csg2


//------------------------------------------------------------------------

class merged_area_c
{
public:
  std::vector<area_poly_c *> polys;

  int sector_index;

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
  fprintf(map_fp, "    ( %1.2f %1.2f %1.2f ) ( %1.2f %1.2f %1.2f ) ( %1.2f %1.2f %1.2f ) %s 0 0 0 1 1\n",
      0.0, 0.0, P->info->z2,
      0.0, 1.0, P->info->z2,
      1.0, 0.0, P->info->z2,
      P->info->t_tex.c_str());

  // Bottom
  fprintf(map_fp, "    ( %1.2f %1.2f %1.2f ) ( %1.2f %1.2f %1.2f ) ( %1.2f %1.2f %1.2f ) %s 0 0 0 1 1\n",
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

    fprintf(map_fp, "    ( %1.2f %1.2f %1.2f ) ( %1.2f %1.2f %1.2f ) ( %1.2f %1.2f %1.2f ) %s 0 0 0 1 1\n",
        v1->x, v1->y, P->info->z1,
        v1->x, v1->y, P->info->z2,
        v2->x, v2->y, P->info->z1, tex);
  }

  fprintf(map_fp, "  }\n");
}

static void CSG2_WriteQuakeMap(void)
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
  // nothing needed (yet)
}

void CSG2_EndLevel(void)
{
  // FIXME: free all_polys

  // FIXME: free all_merges
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
