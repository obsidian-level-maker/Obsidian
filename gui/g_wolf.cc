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

static int write_errors_seen;

static int current_map; // 1 to 60
static int current_offset;

static u16_t *solid_plane;
static u16_t *thing_plane;

#define PL_START  2


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

int rle_compress_plane(u16_t *plane, int src_len)
{
        u16_t *dest = plane + PL_START;
  const u16_t *src  = plane + PL_START;
  const u16_t *endp = plane + PL_START + (src_len/2);

  while (src < endp)
  {
    // don't want no Carmackization...
    SYS_ASSERT((*src & 0xFF00) != 0xA700);
    SYS_ASSERT((*src & 0xFF00) != 0xA800);

    // it shouldn't match the RLEW tag either...
    SYS_ASSERT(*src != RLEW_TAG);

    // determine longest run
    int run = 1;

    while (src+run < endp && run < 100 && src[run-1] == src[run])
      run++;

    if (run > 3)
    {
      // Note: use src[2] since src may == dest, hence src[0] and src[1]
      //       would get overwritten by the tag and count.

      *dest++ = RLEW_TAG;    // tag
      *dest++ = run;         // count
      *dest++ = src[2];      // value

      src += run;
    }
    else
    {
      for (; run > 0; run--)
        *dest++ = *src++;
    }
  }

  int dest_len = 2 * (dest - plane);

  plane[0] = dest_len + 2; // compressed size (bytes)
  plane[1] = src_len;      // expanded size (bytes)

  return dest_len + 4; // total size
}


//------------------------------------------------------------------------

static void DumpMap(void)
{
  int x, y;

  for (y = 0; y < 64; y++)
  {
    for (x = 0; x < 64; x++)
    {
      int tile = solid_plane[PL_START+y*64+x];
      int obj  = thing_plane[PL_START+y*64+x];

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

static void WritePlane(u16_t *plane, int *offset, int *length)
{
  *offset = (int)ftell(map_fp);

  *length = rle_compress_plane(plane, 64*64*2);

  if (1 != fwrite(plane, *length, 1, map_fp))
  {
    if (write_errors_seen < 10)
    {
      write_errors_seen += 1;
      LogPrintf("Failure writing to map file! (%d bytes)\n", *length);
    }
  }

// FIXME: validate length
//  int wrote_length = (int)ftell(map_fp) - *offset;
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
  const char *message = OBLIGE_TITLE " " OBLIGE_VERSION;

  WF_PutNString(message, 64, map_fp);

  int plane_offsets[3];
  int plane_lengths[3];

  WritePlane(solid_plane, plane_offsets+0, plane_lengths+0);
  WritePlane(thing_plane, plane_offsets+1, plane_lengths+1);
  WriteBlankPlane(        plane_offsets+2, plane_lengths+2);

  current_offset = (int)ftell(map_fp);
  // TODO: validate (error check)

  WF_PutU32(plane_offsets[0], map_fp);
  WF_PutU32(plane_offsets[1], map_fp);
  WF_PutU32(plane_offsets[2], map_fp);

  WF_PutU16(plane_lengths[0], map_fp);
  WF_PutU16(plane_lengths[1], map_fp);
  WF_PutU16(plane_lengths[2], map_fp);

  // width and height
  WF_PutU16(64, map_fp);
  WF_PutU16(64, map_fp);

  WF_PutNString("Custom Map", 16, map_fp);  // name (TODO: make one up)

  WF_PutNString("!ID!", 4, map_fp);
}

static void WriteHead(void)
{
  // offset to map data (info struct)
  WF_PutU32(current_offset, head_fp);
}


//------------------------------------------------------------------------

namespace wolf
{

// LUA: begin_level()
//
int begin_level(lua_State *L)
{
  // clear the planes before use

  for (int i = 0; i < 64*64; i++)
  {
    solid_plane[PL_START+i] = NO_TILE;
    thing_plane[PL_START+i] = NO_OBJ;
  }

  return 0;
}

// LUA: end_level()
//
int end_level(lua_State *L)
{
  DumpMap();

  WriteMap();
  WriteHead();

  current_map += 1;

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

  solid_plane[PL_START+y*64+x] = tile;
  thing_plane[PL_START+y*64+x] = obj;

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

  // FIXME: use these (rename XX.TMP -> XX.ext)
  sprintf(gamemaps_base, "GAMEMAPS.%s", ext);
  sprintf(maphead_base,  "MAPHEAD.%s",  ext);

  // FIXME: use proper path!
 
  map_fp = fopen("GAMEMAPS.TMP", "wb");

  if (! map_fp)
  {
    DLG_ShowError("Unable to create %s:\n%s", gamemaps_base, strerror(errno));
    return false;
  }

  head_fp = fopen("MAPHEAD.TMP", "wb");

  if (! head_fp)
  {
    DLG_ShowError("Unable to create %s:\n%s", maphead_base, strerror(errno));
    return false;
  }

  // the maphead file always begins with the RLE tag
  WF_PutU16(RLEW_TAG, head_fp);

  // setup local variables
  current_map    = 1;
  current_offset = 0;
 
  solid_plane = new u16_t[64*64 + 8]; // extra space for compressor
  thing_plane = new u16_t[64*64 + 8];

  write_errors_seen = 0;

  return true;
}

bool Wolf_Finish(void)
{
  // set remaining offsets to zero (=> no map)
  for (; current_map <= 100; current_map++)
  {
    WF_PutU32(0, head_fp);
  }

  fclose(map_fp);
  fclose(head_fp);

  map_fp = head_fp = NULL;

  delete solid_plane;  solid_plane = NULL;
  delete thing_plane;  thing_plane = NULL;

  return (write_errors_seen == 0);
}

