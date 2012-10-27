//------------------------------------------------------------------------
//  DOOM PREFAB loader
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2012 Andrew Apted
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
//
//  A.P.I
//  =====
//  
//  wadfab_load(name)
//  --> no result, raises error on failure
//  
//  wadfab_free()
//  --> no result
//  
//  wadfab_get_polygon(index)
//  -->  { sector=# 
//         coords={ {x=#,y=#,side=# } ... }
//       }
//  
//  wadfab_get_sector(index)
//  -->  { floor_h=#, floor_tex="...",
//          ceil_h=#,  ceil_tex="...",
//         special=#, tag=#, light=#
//       }
//  
//  wadfab_get_side(index)
//  -->  { upper_tex="", mid_tex="", lower_tex="",
//         x_offset=#, y_offset=#,
//         special=#, tag=#, flags=#
//       }
//  
//  wadfab_get_thing(index)
//  -->  { id=#, x=#, y=#, angle=#, flags=# }
//
//------------------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "lib_file.h"
#include "lib_util.h"
#include "lib_wad.h"

#include "main.h"
#include "m_lua.h"

#include "csg_main.h"

#include "dm_prefab.h"
#include "g_doom.h"


static raw_vertex_t  * friz_verts;
static raw_linedef_t * friz_lines;
static raw_sidedef_t * friz_sides;
static raw_sector_t  * friz_sectors;
static raw_thing_t   * friz_things;

static raw_vertex_t  * friz_gl_verts;
static raw_gl_seg_t  * friz_gl_segs;
static raw_subsec_t  * friz_polygons;

static int friz_num_verts;
static int friz_num_lines;
static int friz_num_sides;
static int friz_num_sectors;
static int friz_num_things;

static int friz_num_gl_verts;
static int friz_num_gl_segs;
static int friz_num_polygons;


static const byte *lev_v2_magic = (const byte *) "gNd2";


static bool LoadLump(const char *lump_name, byte ** array, int * count,
                     size_t struct_size, int magic = 0)
{
  int entry = WAD_FindEntry(lump_name);

  if (entry < 0)
  {
    DebugPrintf("Lump not found '%s'\n", lump_name);
    return false;
  }
  
  int pos    = 0;
  int length = WAD_EntryLen(entry);

  *array = new byte[length + 1];

  if (magic == 2)
  {
    char buffer[4];

    if (! WAD_ReadData(entry, 0, 4, buffer))
    {
      DebugPrintf("Failed reading lump (%d bytes)\n", 4);
      return false;
    }

    if (memcmp(buffer, lev_v2_magic, 4) != 0)
    {
      DebugPrintf("Wrong GL-nodes version\n");
      return false;
    }

    pos    += 4;
    length -= 4;
  }

  if (! WAD_ReadData(entry, pos, length, *array))
  {
    DebugPrintf("Failed reading lump (%d bytes)\n", length);
    return false;
  }

  *count = length / (int)struct_size;

// DEBUG
#if 0
fprintf(stderr, "Loaded %s : %d items (%d bytes)\n",
        lump_name, *count, length);
#endif

  return true;
}


static void FreeLump(byte ** array)
{
  if (*array)
  {
    delete[] (*array);
    *array = NULL;
  }
}


int wadfab_free(lua_State *L)
{
  FreeLump((byte **) &friz_verts);
  FreeLump((byte **) &friz_lines);
  FreeLump((byte **) &friz_sides);
  FreeLump((byte **) &friz_sectors);
  FreeLump((byte **) &friz_things);

  FreeLump((byte **) &friz_gl_verts);
  FreeLump((byte **) &friz_gl_segs);
  FreeLump((byte **) &friz_polygons);

  friz_num_verts = 0;
  friz_num_lines = 0;
  friz_num_sides = 0;
  friz_num_sectors = 0;
  friz_num_things = 0;

  friz_num_gl_verts = 0;
  friz_num_gl_segs = 0;
  friz_num_polygons = 0;

  return 0;
}


int wadfab_load(lua_State *L)
{
  const char *name = luaL_checkstring(L, 1);

  char filename[PATH_MAX];

  // FIXME: determine full name PROPERLY !!
  sprintf(filename, "./prefabs/%s", name);


  if (! WAD_OpenRead(filename))
    return luaL_error(L, "wadfab_load: missing/bad WAD: %s", name);

  if (! LoadLump("THINGS",   (byte **) &friz_things,   &friz_num_things,   sizeof(raw_thing_t)) ||
      ! LoadLump("VERTEXES", (byte **) &friz_verts,    &friz_num_verts,    sizeof(raw_vertex_t)) ||
      ! LoadLump("LINEDEFS", (byte **) &friz_lines,    &friz_num_lines,    sizeof(raw_linedef_t)) ||
      ! LoadLump("SIDEDEFS", (byte **) &friz_sides,    &friz_num_sides,    sizeof(raw_sidedef_t)) ||
      ! LoadLump("SECTORS",  (byte **) &friz_sectors,  &friz_num_sectors,  sizeof(raw_sector_t))
     )
  {
    WAD_CloseRead();
    wadfab_free(L);
    return luaL_error(L, "wadfab_load: missing/bad map in %s", name);
  }

  if (! LoadLump("GL_VERT",  (byte **) &friz_gl_verts, &friz_num_gl_verts, sizeof(raw_vertex_t), 2) ||
      ! LoadLump("GL_SEGS",  (byte **) &friz_gl_segs,  &friz_num_gl_segs,  sizeof(raw_gl_seg_t)) ||
      ! LoadLump("GL_SSECT", (byte **) &friz_polygons, &friz_num_polygons, sizeof(raw_subsec_t))
     )
  {
    WAD_CloseRead();
    wadfab_free(L);
    return luaL_error(L, "wadfab_load: missing/bad GL-nodes in %s", name);
  }

  // we have loaded everything we need -- can close then file now
  WAD_CloseRead();

  return 0;
}


//------------------------------------------------------------------------


static void push_char8(lua_State *L, const char * buf)
{
  size_t len = 0;

  while (len < 8 && buf[len] != 0)
    len++;

  lua_pushlstring(L, buf, len);
}


int wadfab_get_thing(lua_State *L)
{
  int index = luaL_checkint(L, 1);

  index--;  // #1 is the first

  if (index < 0 || index >= friz_num_things)
    return 0;

  const raw_thing_t * thing = &friz_things[index];

  int x     = LE_S16(thing->x);
  int y     = LE_S16(thing->y);
  int angle = LE_S16(thing->angle);
  int id    = LE_U16(thing->type);
  int flags = LE_U16(thing->options);

  lua_newtable(L);

  lua_pushinteger(L, x);
  lua_setfield(L, -2, "x");

  lua_pushinteger(L, y);
  lua_setfield(L, -2, "y");

  lua_pushinteger(L, angle);
  lua_setfield(L, -2, "angle");

  lua_pushinteger(L, angle);
  lua_setfield(L, -2, "angle");

  lua_pushinteger(L, id);
  lua_setfield(L, -2, "id");

  lua_pushinteger(L, flags);
  lua_setfield(L, -2, "flags");

  return 1;
}


int wadfab_get_sector(lua_State *L)
{
  int index = luaL_checkint(L, 1);

  index--;  // #1 is the first

  if (index < 0 || index >= friz_num_sectors)
    return 0;

  const raw_sector_t * sec = &friz_sectors[index];

  int floor_h = LE_S16(sec->floor_h);
  int  ceil_h = LE_S16(sec->ceil_h);

  int special = LE_S16(sec->special);
  int   light = LE_S16(sec->light);
  int     tag = LE_S16(sec->tag);

  lua_newtable(L);

  lua_pushinteger(L, floor_h);
  lua_setfield(L, -2, "floor_h");

  lua_pushinteger(L, ceil_h);
  lua_setfield(L, -2, "ceil_h");

  lua_pushinteger(L, special);
  lua_setfield(L, -2, "special");

  lua_pushinteger(L, light);
  lua_setfield(L, -2, "light");

  lua_pushinteger(L, tag);
  lua_setfield(L, -2, "tag");

  push_char8(L, sec->floor_tex);
  lua_setfield(L, -2, "floor_tex");

  push_char8(L, sec->ceil_tex);
  lua_setfield(L, -2, "ceil_tex");

  return 1;
}


int wadfab_get_side(lua_State *L)
{
  int index = luaL_checkint(L, 1);

  // FIXME: wadfab_get_side
}


int wadfab_get_polygon(lua_State *L)
{
  int index = luaL_checkint(L, 1);

  // FIXME: wadfab_get_polygon
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
