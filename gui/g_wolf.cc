//------------------------------------------------------------------------
//  LEVEL building - Wolf3d format
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

#include "g_wolf.h"

#include "main.h"
#include "ui_dialog.h"
#include "ui_window.h"


#define RLEW_TAG  0xABCD

#define NO_TILE  48
#define NO_OBJ   0


/* private data */

static FILE *map_fp;
static FILE *head_fp;

static int map_offset;

static u16_t *solid_plane;
static u16_t *thing_plane;


//------------------------------------------------------------------------
//  WOLF OUTPUT
//------------------------------------------------------------------------

static void WF_PutU16(u16_t val, FILE *fp)
{
  fputc(val & 0xFF, fp);
  fputc((val >> 8) & 0xFF, fp);
}

static void WF_PutU32(u32_t val, FILE *fp)
{
  fputc(val & 0xFF, fp);
  fputc((val >> 8) & 0xFF, fp);
  fputc((val >> 16) & 0xFF, fp);
  fputc((val >> 24) & 0xFF, fp);
}

static void WF_PutNString(const char *str, int max_len, FILE *fp)
{
  SYS_ASSERT((int)strlen(str) <= max_len);

  while (*str)
  {
    fputc(*str++, fp);
    max_len--;
  }

  for (; max_len > 0; max_len--)
  {
    fputc(0, fp);
  }
}

namespace rle_comp
{
/* private */
  unsigned short value;
  unsigned short repeat;

  void Begin()
  {
    repeat = 0;
  }

  void Flush()
  {
    while (repeat > 3)
    {
      int actual = MIN(128, repeat);

      WF_PutU16(RLEW_TAG, map_fp);  // tag
      WF_PutU16(actual, map_fp);    // count
      WF_PutU16(value, map_fp);     // value

      repeat -= actual;
    }

    for (; repeat > 0; repeat--)
    {
      WF_PutU16(value, map_fp);
    }
  }

  void Add(unsigned short datum)
  {
    // don't want no Carmackization...
    SYS_ASSERT((datum & 0xFF00) != 0xA700);
    SYS_ASSERT((datum & 0xFF00) != 0xA800);

    // it shouldn't match the RLEW tag either...
    SYS_ASSERT(datum != RLEW_TAG);

#if 1
    WF_PutU16(datum, map_fp);
#else
    if (repeat > 0)
    {
      if (datum == value)
      {
        repeat++;
        return;
      }

      Flush();
    }

    value = datum;
    repeat = 1;
#endif
  }

} // namespace rle_comp


//------------------------------------------------------------------------

static void DumpMap(void)
{
  int x, y;

  for (y = 0; y < 64; y++)
  {
    for (x = 0; x < 64; x++)
    {
      int tile = solid_plane[y*64+x];
      int obj  = thing_plane[y*64+x];

      int ch;

      if (tile == NO_TILE)
        ch = '#';
      else if (tile < 52)
        ch = 'A' + (tile / 2);
      else if (tile < 64)
        ch = '1' + ((tile - 52) / 2);
      else if (obj == NO_OBJ)
        ch = '.';
      else if (obj >= 19 && obj <= 22)
        ch = 'p'; // player
      else if ((obj >= 43 && obj <= 56) || obj == 71)
        ch = '+'; // pickup
      else if (obj >= 23 && obj <= 71)
        ch = '%'; // scenery
      else if (obj >= 108)
        ch = 'm'; // monster
      else
        ch = '?';

      LogPrintf("%c", ch);
    }

    LogPrintf("\n");
  }
}

static void WriteSolidPlane(int *offset, int *length)
{
  *offset = (int)ftell(map_fp);

  WF_PutU16(64*64*2 + 2, map_fp);  // compressed size (FIXME: could go wrong!)
  WF_PutU16(64*64*2, map_fp);      // expanded size

  rle_comp::Begin();

  for (int i = 0; i < 64*64; i++)
  {
    rle_comp::Add(solid_plane[i]);
  }

  rle_comp::Flush();

  *length = (int)ftell(map_fp);
  *length -= *offset;
}

static void WriteThingPlane(int *offset, int *length)
{
  *offset = (int)ftell(map_fp);

  WF_PutU16(64*64*2 + 2, map_fp);  // compressed size (FIXME: could be wrong)
  WF_PutU16(64*64*2, map_fp);      // expanded size

  rle_comp::Begin();

  for (int i = 0; i < 64*64; i++)
  {
    rle_comp::Add(thing_plane[i]);
  }

  rle_comp::Flush();

  *length = (int)ftell(map_fp);
  *length -= *offset;
}

static void WriteBlankPlane(int *offset, int *length)
{
  *offset = (int)ftell(map_fp);

  WF_PutU16(3*2 + 2, map_fp);  // compressed size + 2
  WF_PutU16(64*64*2, map_fp);  // expanded size

  WF_PutU16(RLEW_TAG, map_fp); // tag
  WF_PutU16(64 * 64, map_fp);  // count
  WF_PutU16(0, map_fp);        // value

  *length = (int)ftell(map_fp);
  *length -= *offset;
}

static void WriteMap(void)
{
  //? SYS_ASSERT(the_world->w() <= 62);
  //? SYS_ASSERT(the_world->h() <= 62);

  const char *message = OBLIGE_TITLE " " OBLIGE_VERSION;

  WF_PutNString(message, 64, map_fp);

  int plane_offsets[3];
  int plane_lengths[3];

  WriteSolidPlane(plane_offsets+0, plane_lengths+0);
  WriteThingPlane(plane_offsets+1, plane_lengths+1);
  WriteBlankPlane(plane_offsets+2, plane_lengths+2);

  map_offset = (int)ftell(map_fp);
  // FIXME: validate (error check)

  WF_PutU32(plane_offsets[0], map_fp);
  WF_PutU32(plane_offsets[1], map_fp);
  WF_PutU32(plane_offsets[2], map_fp);

  WF_PutU16(plane_lengths[0], map_fp);
  WF_PutU16(plane_lengths[1], map_fp);
  WF_PutU16(plane_lengths[2], map_fp);

  // width and height
  WF_PutU16(64, map_fp);
  WF_PutU16(64, map_fp);

  WF_PutNString("Custom Map", 16, map_fp);  // name

  WF_PutNString("!ID!", 4, map_fp);  // sanity check ??
}

static void WriteHead(void)
{
  WF_PutU16(RLEW_TAG, head_fp);

  // offset to first map (info struct)
  WF_PutU32(map_offset, head_fp);

  // set remaining offsets to zero (=> no map)
  for (int lev = 1; lev < 60; lev++)
  {
    WF_PutU32(0, head_fp);
  }
}


//------------------------------------------------------------------------

namespace wolf
{

// LUA: begin_level()
//
int begin_level(lua_State *L)
{
  // allocate planes and clear them

  solid_plane = new u16_t[64*64];
  thing_plane = new u16_t[64*64];

  for (int i = 0; i < 64*64; i++)
  {
    solid_plane[i] = NO_TILE;
    thing_plane[i] = NO_OBJ;
  }

  return 0;
}

// LUA: end_level()
//
int end_level(lua_State *L)
{
  // Write stuff here ???

/* FIXME
  delete solid_plane;  solid_plane = NULL;
  delete thing_plane;  thing_plane = NULL;
*/
  return 0;
}


// LUA: add_block(x, y, tile, obj)
//
int add_block(lua_State *L)
{
  int x = luaL_checkint(L,1);
  int y = luaL_checkint(L,2);

  int tile = luaL_checkint(L,3);
  int obj  = luaL_checkint(L,4);

  // adjust and validate coords
  x = x-1;
  y = 64-y;

  SYS_ASSERT(0 <= x && x <= 63);
  SYS_ASSERT(0 <= y && y <= 63);

  solid_plane[y*64+x] = tile;
  thing_plane[y*64+x] = obj;

  return 0;
}

} // namespace wolf


//------------------------------------------------------------------------
//  PUBLIC INTERFACE
//------------------------------------------------------------------------

static const luaL_Reg wolf_funcs[] =
{
  { "begin_level", wolf::begin_level },
  { "add_block",   wolf::add_block   },
  { "end_level",   wolf::end_level   },

  { NULL, NULL } // the end
};

void Wolf_InitLua(lua_State *L)
{
  luaL_register(L, "wolf", wolf_funcs);
}

bool Wolf_Begin(void) // FIXME: pass output directory
{
  const char *ext = "WL6"; // FIXME: pass as parameter

  if (strcmp(main_win->setup_box->get_Game(), "spear")  == 0)
    ext = "SOD";

  char gamemaps_base[40];
  char maphead_base[40];

  sprintf(gamemaps_base, "GAMEMAPS.%s", ext);
  sprintf(maphead_base,  "MAPHEAD.%s",  ext);

  // FIXME: use proper path!
 
  map_fp = fopen(gamemaps_base, "wb");

  if (! map_fp)
  {
    DLG_ShowError("Unable to create %s:\n%s", gamemaps_base, strerror(errno));
    return false;
  }

  head_fp = fopen(maphead_base, "wb");

  if (! head_fp)
  {
    DLG_ShowError("Unable to create %s:\n%s", maphead_base, strerror(errno));
    return false;
  }

  return true;
}

bool Wolf_Finish(void)
{
  // FIXME

  DumpMap();

  WriteMap();
  WriteHead();

  fclose(map_fp);
  fclose(head_fp);

  map_fp = head_fp = NULL;

  return true;
}

