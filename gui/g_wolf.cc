//------------------------------------------------------------------------
//  LEVEL building - Wolf3d format
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2010 Andrew Apted
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
#include "hdr_ui.h"

#include "lib_file.h"
#include "lib_util.h"

#include "main.h"
#include "m_lua.h"


#define TEMP_GAMEFILE  "GAMEMAPS.TMP"
#define TEMP_HEADFILE  "MAPHEAD.TMP"


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

static int * minimap_colors;
static int minimap_x1, minimap_y1;
static int minimap_x2, minimap_y2;

static char *level_name;

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
  for (; *str && max_len > 0; max_len--)
  {
    fputc(*str++, fp);
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

static void WF_WritePlane(u16_t *plane, int *offset, int *length)
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
}


static void WF_WriteBlankPlane(int *offset, int *length)
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


static void WF_WriteMap(void)
{
  const char *message = OBLIGE_TITLE " " OBLIGE_VERSION;

  WF_PutNString(message, 64, map_fp);

  int plane_offsets[3];
  int plane_lengths[3];

  WF_WritePlane(solid_plane, plane_offsets+0, plane_lengths+0);
  WF_WritePlane(thing_plane, plane_offsets+1, plane_lengths+1);
  WF_WriteBlankPlane(        plane_offsets+2, plane_lengths+2);

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

  WF_PutNString(level_name ? level_name : "Custom Map", 16, map_fp);

  WF_PutNString("!ID!", 4, map_fp);
}


static void WF_WriteHead(void)
{
  // offset to map data (info struct)
  WF_PutU32(current_offset, head_fp);
}


//------------------------------------------------------------------------

// LUA: wolf_block(x, y, plane, value)
//
int WF_wolf_block(lua_State *L)
{
  int x = luaL_checkint(L, 1);
  int y = luaL_checkint(L, 2);

  int plane = luaL_checkint(L, 3);
  int value = luaL_checkint(L, 4);

  // adjust and validate coords
  SYS_ASSERT(1 <= x && x <= 64);
  SYS_ASSERT(1 <= y && y <= 64);

  x--;  y = 64-y;

  switch (plane)
  {
    case 1:
      solid_plane[PL_START + y*64 + x] = value;
      break;

    case 2:
      thing_plane[PL_START + y*64 + x] = value;
      break;

    default:
      // other planes are silently ignored
      break;
  }

  return 0;
}


// LUA: wolf_read(x, y, plane)
//
int WF_wolf_read(lua_State *L)
{
  int x = luaL_checkint(L, 1);
  int y = luaL_checkint(L, 2);

  int plane = luaL_checkint(L, 3);

  // adjust and validate coords
  SYS_ASSERT(1 <= x && x <= 64);
  SYS_ASSERT(1 <= y && y <= 64);

  x--;  y = 64-y;

  int value = 0;

  switch (plane)
  {
    case 1:
      value = solid_plane[PL_START + y*64 + x];
      break;

    case 2:
      value = thing_plane[PL_START + y*64 + x];
      break;

    default:
      // other planes are silently ignored
      break;
  }

  lua_pushinteger(L, value);
  return 1;
}


// LUA: wolf_mini_map(x, y, color)
//
int WF_wolf_mini_map(lua_State *L)
{
  int x = luaL_checkint(L, 1);
  int y = luaL_checkint(L, 2);

  const char *color = luaL_checkstring(L, 3);

  // validate coords
  SYS_ASSERT(1 <= x && x <= 64);
  SYS_ASSERT(1 <= y && y <= 64);

  // Note: we don't invert the Y coordinate here
  x--;  y--;

  if (color[0] == '#')
  {
    minimap_colors[y*64 + x] = strtol(color+1, NULL, 16);
  }

  minimap_x2 = MAX(x, minimap_x2);
  minimap_y2 = MAX(y, minimap_y2);

  minimap_x1 = MIN(x, minimap_x1);
  minimap_y1 = MIN(y, minimap_y1);

  return 0;
}


static void WF_DumpMap(void)
{
  static const char *turning_points = ">/^\\</v\\";
//static char *player_angles  = "^>v<";

  bool show_floors = false;

  char line_buf[80];

  for (int y = 0 ; y < 64 ; y++)
  {
    for (int x = 0 ; x < 64 ; x++)
    {
      int tile = solid_plane[PL_START + y*64 + x];
      int obj  = thing_plane[PL_START + y*64 + x];

      int ch;

      if (tile == NO_TILE)
        ch = '#';
      else if (obj >= 19 && obj <= 22)
        ch = 'p'; // player_angles[obj-19];
      else if (tile < 52)
        ch = 'A' + (tile / 2);
      else if (tile < 64)
        ch = (show_floors ? 'A' : '1') + ((tile - 52) / 2);
      else if (90 <= tile && tile <= 101)
        ch = '+';
      else if (show_floors && 108 <= tile && tile <= 143)
        ch = '0' + ((tile - 108) % 10);
      else if (obj == NO_OBJ)
        ch = '.';
      else if ((obj >= 43 && obj <= 56) || obj == 29)
        ch = '$'; // pickup
      else if ((obj >= 23 && obj <= 71) || obj == 124)
        ch = '%'; // scenery
      else if (obj >= 108)
        ch = 'm'; // monster
      else if (90 <= obj && obj <= 97)
        ch = turning_points[obj - 90];
      else
        ch = '?';

      line_buf[x] = ch;
    }

    line_buf[64] = 0;

    DebugPrintf("%s\n", line_buf);
  }
}


static void WF_MakeMiniMap(void)
{
  if (! main_win)
    return;

  int map_W = main_win->build_box->mini_map->GetWidth();
  int map_H = main_win->build_box->mini_map->GetHeight();

  main_win->build_box->mini_map->MapBegin();

  int mini_mid_x = minimap_x1 + (minimap_x2 - minimap_x1) / 2;
  int mini_mid_y = minimap_y1 + (minimap_y2 - minimap_y1) / 2;

  for (int y = 0 ; y < 64 ; y++)
  for (int x = 0 ; x < 64 ; x++)
  {
    int hue = minimap_colors[y*64 + x];

    if (hue < 0)
      continue;

    byte r = ((hue >> 8) & 0xF) * 17;
    byte g = ((hue >> 4) & 0xF) * 17;
    byte b = ((hue     ) & 0xF) * 17;

    int bx = map_W / 2 + (x - mini_mid_x) * 2;
    int by = map_H / 2 + (y - mini_mid_y) * 2;

    main_win->build_box->mini_map->DrawBox(bx, by, bx+1, by+1, r, g, b);
  }

  main_win->build_box->mini_map->MapFinish();
}


static void WF_FreeStuff()
{
  delete[] solid_plane;  solid_plane  = NULL;
  delete[] thing_plane;  thing_plane  = NULL;

  delete[] minimap_colors;  minimap_colors = NULL;
}


//------------------------------------------------------------------------
//  PUBLIC INTERFACE
//------------------------------------------------------------------------

class wolf_game_interface_c : public game_interface_c
{
private:
  std::string file_ext;

public:
  wolf_game_interface_c() : file_ext("WL6")
  { }

  ~wolf_game_interface_c()
  { }

  bool Start();
  bool Finish(bool build_ok);

  void BeginLevel();
  void EndLevel();
  void Property(const char *key, const char *value);

private:
  bool Rename();
  void Tidy();
};


bool wolf_game_interface_c::Start()
{
  WF_FreeStuff();

  write_errors_seen = 0;


  map_fp = fopen(TEMP_GAMEFILE, "wb");

  if (! map_fp)
  {
    LogPrintf("Unable to create %s:\n%s", TEMP_GAMEFILE, strerror(errno));

    Main_ProgStatus("Error (create file)");
    return false;
  }

  head_fp = fopen(TEMP_HEADFILE, "wb");

  if (! head_fp)
  {
    fclose(map_fp);

    LogPrintf("Unable to create %s:\n%s", TEMP_HEADFILE, strerror(errno));

    Main_ProgStatus("Error (create file)");
    return false;
  }

  // the maphead file always begins with the RLE tag
  WF_PutU16(RLEW_TAG, head_fp);

  // setup local variables
  current_map    = 1;
  current_offset = 0;
 
  solid_plane = new u16_t[64*64 + 8]; // extra space for compressor
  thing_plane = new u16_t[64*64 + 8];

  minimap_colors = new int[64*64];


  if (main_win)
    main_win->build_box->Prog_Init(0, "");

  return true;
}


bool wolf_game_interface_c::Finish(bool build_ok)
{
  WF_FreeStuff();

  // set remaining map offsets to zero (no map)
  for ( ; current_map <= 100 ; current_map++)
  {
    WF_PutU32(0, head_fp);
  }

  fclose(map_fp);
  fclose(head_fp);

  map_fp = head_fp = NULL;


  if (! build_ok)
  {
    Tidy();
    return false;
  }

  if (write_errors_seen > 0 || ! Rename())
  {
    Main_ProgStatus("Error (write file)");
    Tidy();
    return false;
  }

  return true; // OK!
}


bool wolf_game_interface_c::Rename()
{
  char gamemaps[40];
  char maphead[40];

  sprintf(gamemaps, "GAMEMAPS.%s", file_ext.c_str());
  sprintf(maphead,  "MAPHEAD.%s",  file_ext.c_str());

  FileDelete(gamemaps);
  FileDelete(maphead);

  return FileRename(TEMP_GAMEFILE, gamemaps) &&
         FileRename(TEMP_HEADFILE, maphead);
}


void wolf_game_interface_c::Tidy()
{
  FileDelete(TEMP_GAMEFILE);
  FileDelete(TEMP_HEADFILE);
}


void wolf_game_interface_c::BeginLevel()
{
  // clear the planes before use
  for (int i = 0 ; i < 64*64 ; i++)
  {
    solid_plane[PL_START + i] = NO_TILE;
    thing_plane[PL_START + i] = NO_OBJ;

    minimap_colors[i] = -1;
  }

  minimap_x1 = minimap_y1 = +99;
  minimap_x2 = minimap_y2 = -99;

  current_map += 1;

  SYS_ASSERT(current_map < 100);
}


void wolf_game_interface_c::EndLevel()
{
  WF_DumpMap();
  WF_MakeMiniMap();

  WF_WriteMap();
  WF_WriteHead();

  if (level_name)
  {
    StringFree(level_name);
    level_name = NULL;
  }
}


void wolf_game_interface_c::Property(const char *key, const char *value)
{
  if (StringCaseCmp(key, "level_name") == 0)
  {
    level_name = StringDup(value);
  }
  else if (StringCaseCmp(key, "file_ext") == 0)
  {
    file_ext = std::string(value);
  }
  else
  {
    LogPrintf("WARNING: unknown WOLF3D property: %s=%s\n", key, value);
  }
}


game_interface_c * Wolf_GameObject()
{
  return new wolf_game_interface_c();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
