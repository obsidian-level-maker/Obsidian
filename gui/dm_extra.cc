//------------------------------------------------------------------------
//  EXTRA stuff for DOOM
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2008-2009 Andrew Apted
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
#include "lib_wad.h"

#include "main.h"
#include "g_lua.h"

#include "csg_main.h"

#include "dm_extra.h"
#include "dm_level.h"
#include "dm_wad.h"
#include "q_bsp.h"  // qLump_c

#include "img_all.h"
#include "tx_forge.h"
#include "tx_skies.h"


static byte *sky_pixels;
static int sky_W;
static int sky_H;
static int sky_final_W;


#define CUR_PIXEL(py)  (pixels[((py) % H) * W])

static void AddPost(qLump_c *lump, int y, int len,
                    const byte *pixels, int W, int H)
{
  if (len <= 0)
    return;

  byte buffer[512];
  byte *dest = buffer;

  *dest++ = y;     // Y-OFFSET
  *dest++ = len;   // # PIXELS

  *dest++ = CUR_PIXEL(y);  // TOP-PADDING

  for (; len > 0; len--, y++)
    *dest++ = CUR_PIXEL(y);

  *dest++ = CUR_PIXEL(y-1);  // BOTTOM-PADDING

  lump->Append(buffer, dest - buffer);
}

static void EndOfPost(qLump_c *lump)
{
  byte datum = 255;

  lump->Append(&datum, 1);
}

qLump_c * DM_CreatePatch(int new_W, int new_H, int ofs_X, int ofs_Y,
                         const byte *pixels, int W, int H,
                         int trans_p = -1)
{
  qLump_c *lump = new qLump_c();

  int x, y;

  u32_t *offsets  = new u32_t[new_W];
  u32_t beginning = sizeof(raw_patch_header_t) + new_W * 4;

  for (x = 0; x < W; x++, pixels++)
  {
    offsets[x] = beginning + (u32_t)lump->GetSize();

    for (y = 0; y < new_H; )
    {
      if (trans_p >= 0 && CUR_PIXEL(y) == trans_p)
      {
        y++; continue;
      }

      int len = 1;

      while ((y+len) < new_H && len < 240 &&
             ! (trans_p >= 0 && CUR_PIXEL(y+len) == trans_p))
      {
        len++;
      }

      if (y <= 252)
        AddPost(lump, y, len, pixels, W, H);

      y = y + len;
    }

    EndOfPost(lump);
  }

  for (x = W; x < new_W; x++)
    offsets[x] = offsets[x % W];

  lump->Prepend(offsets, new_W * sizeof(u32_t));

  delete[] offsets;


  raw_patch_header_t header;

  header.width    = LE_U16(new_W);
  header.height   = LE_U16(new_H);
  header.x_offset = LE_U16(ofs_X);
  header.y_offset = LE_U16(ofs_Y);

  lump->Prepend(&header, sizeof(header));

  return lump;
}

#undef CUR_PIXEL

qLump_c * DM_CreateFlat(int new_W, int new_H, const byte *pixels, int W, int H)
{
  qLump_c *lump = new qLump_c();
 
  // create a skewed but working flat when original is 128x32
  if (W != new_W && W == new_W*2 && H*2 == new_H)
  {
    for (int y = 0; y < new_H; y++)
    for (int x = 0; x < new_W; x++)
    {
      int oy = (y + x / 2) % new_H;
      int ox = x + ((oy >= H) ? W/2 : 0);

      lump->Append(& pixels[(oy%H) * W + (ox%W)], 1);
    }
    return lump;
  }

  for (int y = 0; y < new_H; y++)
  for (int x = 0; x < new_W; x += W)
  {
    int span = MIN(W, new_W - x);

    SYS_ASSERT(span > 0);

    lump->Append(& pixels[(y%H) * W + (x%W)], span);
  }

  return lump;
}

static byte * Flat_Realign(const byte *pixels, int W, int H, int dx=32, int dy=32)
{
  byte *new_pix = new byte[W * H];

  for (int y = 0; y < H; y++)
  for (int x = 0; x < W; x++)
  {
    int nx = (x + dx + W) % W;
    int ny = (y + dy + H) % H;

    new_pix[ny*W + nx] = pixels[y*W + x];
  }

  return new_pix;
}


int DM_wad_logo_gfx(lua_State *L)
{
  // LUA: wad_logo_gfx(lump, kind, image, W, H, colmap)

  const char *patch = luaL_checkstring(L, 1);
  const char *kind  = luaL_checkstring(L, 2);
  const char *image = luaL_checkstring(L, 3);

  bool is_flat = false;
  bool realign = false;

  if (strchr(kind, 'p'))
    is_flat = false;
  else if (strchr(kind, 'f'))
    is_flat = true;
  else
    return luaL_argerror(L, 2, "unknown kind");

  if (strchr(kind, 'm'))
    realign = true;

  int new_W  = luaL_checkint(L, 4);
  int new_H  = luaL_checkint(L, 5);
  int map_id = luaL_checkint(L, 6);

  if (new_W < 1) return luaL_argerror(L, 4, "bad width");
  if (new_H < 1) return luaL_argerror(L, 5, "bad height");

  if (map_id < 1 || map_id > MAX_COLOR_MAPS)
    return luaL_argerror(L, 6, "colmap value out of range");


  // find the requested image (TODO: look in a table)
  const logo_image_t *logo = NULL;

  if (StringCaseCmp(image, logo_BOLT.name) == 0)
    logo = &logo_BOLT;
  else if (StringCaseCmp(image, logo_PILL.name) == 0)
    logo = &logo_PILL;
  else if (StringCaseCmp(image, logo_CARVE.name) == 0)
    logo = &logo_CARVE;
  else if (StringCaseCmp(image, logo_RELIEF.name) == 0)
    logo = &logo_RELIEF;
  else
    return luaL_argerror(L, 3, "unknown image name");


  // colorize logo
  color_mapping_t *map = &color_mappings[map_id-1];

  if (map->size < 2)
    return luaL_error(L, "wad_logo_gfx: colormap too small");

  byte *pixels = new byte[logo->width * logo->height];
  byte *p_end = pixels + (logo->width * logo->height);

  const byte *src = logo->data;

  for (byte *dest = pixels; dest < p_end; dest++, src++)
  {
    int idx = ((*src) * map->size) >> 8;

    *dest = map->colors[idx];
  }
  

  if (realign)
  {
    byte *new_pix = Flat_Realign(pixels, logo->width, logo->height);

    delete[] pixels;
    pixels = new_pix;
  }

  // splosh it into the wad
  if (is_flat)
  {
    qLump_c *lump = DM_CreateFlat(new_W, new_H,
                       pixels, logo->width, logo->height);
    DM_AddFlat(patch, lump);
  }
  else
  {
    qLump_c *lump = DM_CreatePatch(new_W, new_H, 0, 0,
                       pixels, logo->width, logo->height);
    DM_AddPatch(patch, lump);
  }

  delete[] pixels;

  return 0;
}


//------------------------------------------------------------------------

int DM_fsky_create(lua_State *L)
{
  // LUA: fsky_create(width, height, bg_col)

  int W  = luaL_checkint(L, 1);
  int H  = luaL_checkint(L, 2);
  int bg = luaL_checkint(L, 3);

  sky_final_W = W;

  if (W != 256)
    return luaL_argerror(L, 1, "bad width");

  if (H < 128 || H > 256)
    return luaL_argerror(L, 2, "bad height");

  if (sky_pixels && ! (sky_W == W && sky_H == H))
    delete[] sky_pixels;

  if (! sky_pixels)
  {
    sky_W = W;
    sky_H = H;

    sky_pixels = new byte[sky_W * sky_H];
  }

  memset(sky_pixels, bg, sky_W * sky_H);

  return 0;
}

int DM_fsky_write(lua_State *L)
{
  // LUA: fsky_write(patch)

  const char *patch = luaL_checkstring(L, 1);
 
  SYS_ASSERT(sky_pixels);

  qLump_c *lump = DM_CreatePatch(sky_final_W, sky_H, 0, 0,
                                 sky_pixels, sky_W, sky_H);

  DM_AddPatch(patch, lump);

  return 0;
}

int DM_fsky_solid_box(lua_State *L)
{
  // LUA: fsky_solid_box(x, y, w, h, col)

  int x1 = luaL_checkint(L, 1);
  int y1 = luaL_checkint(L, 2);
  int x2 = x1 + luaL_checkint(L, 3);
  int y2 = y1 + luaL_checkint(L, 4);

  int col = luaL_checkint(L, 5);

  SYS_ASSERT(sky_pixels);

  // clip box to pixel rectangle
  x1 = MAX(x1, 0);
  y1 = MAX(y1, 0);

  x2 = MIN(x2, sky_W);
  y2 = MIN(y2, sky_H);
  
  for (int y = y1; y < y2; y++)
  {
    if (x2 > x1)
      memset(& sky_pixels[y*sky_W + x1], col, (x2-x1));
  }

  return 0;
}

int DM_fsky_add_stars(lua_State *L)
{
  // LUA: fsky_add_stars { seed=X, colmap=X, power=X, thresh=X }

  if (lua_type(L, 1) != LUA_TTABLE)
    return luaL_argerror(L, 1, "missing table: star info");

  int seed = 1;
  int map_id = 1;

  double powscale = 3.0;
  double thresh = 0.25;

  lua_getfield(L, 1, "seed");
  lua_getfield(L, 1, "colmap");
  lua_getfield(L, 1, "power");
  lua_getfield(L, 1, "thresh");

  if (! lua_isnil(L, -4)) seed     = luaL_checkint(L, -4);
  if (! lua_isnil(L, -3)) map_id   = luaL_checkint(L, -3);
  if (! lua_isnil(L, -2)) powscale = luaL_checknumber(L, -2);
  if (! lua_isnil(L, -1)) thresh   = luaL_checknumber(L, -1);

  lua_pop(L, 4);

  // validation... 
  SYS_ASSERT(sky_pixels);

  if (map_id < 1 || map_id > MAX_COLOR_MAPS)
    return luaL_error(L, "fsky_add_stars: colmap value out of range");

  if (powscale < 0.01)
    return luaL_error(L, "fsky_add_stars: bad power value");

  if (thresh > 0.98)
    return luaL_error(L, "fsky_add_stars: bad thresh value");

  SKY_AddStars(seed,  sky_pixels, sky_W, sky_H,
               &color_mappings[map_id-1], powscale, thresh);

  return 0;
}

int DM_fsky_add_clouds(lua_State *L)
{
  // LUA: fsky_add_clouds { seed=X, colmap=X, power=X, thresh=X,
  //                        fracdim=X, squish=X }

  if (lua_type(L, 1) != LUA_TTABLE)
    return luaL_argerror(L, 1, "missing table: cloud info");

  int seed = 1;
  int map_id = 1;

  double powscale = 1.2;
  double thresh   = 0.0;
  double fracdim  = 2.4;
  double squish   = 1.0;

  lua_getfield(L, 1, "seed");
  lua_getfield(L, 1, "colmap");

  if (! lua_isnil(L, -2)) seed     = luaL_checkint(L, -2);
  if (! lua_isnil(L, -1)) map_id   = luaL_checkint(L, -1);

  lua_pop(L, 2);

  lua_getfield(L, 1, "power");
  lua_getfield(L, 1, "thresh");
  lua_getfield(L, 1, "fracdim");
  lua_getfield(L, 1, "squish");

  if (! lua_isnil(L, -4)) powscale = luaL_checknumber(L, -4);
  if (! lua_isnil(L, -3)) thresh   = luaL_checknumber(L, -3);
  if (! lua_isnil(L, -2)) fracdim  = luaL_checknumber(L, -2);
  if (! lua_isnil(L, -1)) squish   = luaL_checknumber(L, -1);

  lua_pop(L, 4);

  // validation... 
  SYS_ASSERT(sky_pixels);

  if (map_id < 1 || map_id > MAX_COLOR_MAPS)
    return luaL_error(L, "fsky_add_clouds: colmap value out of range");

  if (powscale < 0.01)
    return luaL_error(L, "fsky_add_clouds: bad power value");

  if (thresh > 0.98)
    return luaL_error(L, "fsky_add_clouds: bad thresh value");

  if (fracdim > 2.99 || fracdim < 0.2)
    return luaL_error(L, "fsky_add_clouds: bad fracdim value");

  if (squish > 4.1 || squish < 0.24)
    return luaL_error(L, "fsky_add_clouds: bad squish value");

  SKY_AddClouds(seed,  sky_pixels, sky_W, sky_H,
               &color_mappings[map_id-1], powscale, thresh,
               fracdim, squish);

  return 0;
}

int DM_fsky_add_hills(lua_State *L)
{
  // LUA: fsky_add_hills { seed=X, colmap=X, power=X, fracdim=X,
  //                       min_h=X, max_h=X }

  if (lua_type(L, 1) != LUA_TTABLE)
    return luaL_argerror(L, 1, "missing table: cloud info");

  int seed = 1;
  int map_id = 1;

  double min_h = -0.20;
  double max_h =  0.75;

  double powscale = 0.8;
  double fracdim  = 1.8;

  lua_getfield(L, 1, "seed");
  lua_getfield(L, 1, "colmap");

  if (! lua_isnil(L, -2)) seed     = luaL_checkint(L, -2);
  if (! lua_isnil(L, -1)) map_id   = luaL_checkint(L, -1);

  lua_pop(L, 2);

  lua_getfield(L, 1, "min_h");
  lua_getfield(L, 1, "max_h");
  lua_getfield(L, 1, "power");
  lua_getfield(L, 1, "fracdim");

  if (! lua_isnil(L, -4)) min_h    = luaL_checknumber(L, -4);
  if (! lua_isnil(L, -3)) max_h    = luaL_checknumber(L, -3);
  if (! lua_isnil(L, -2)) powscale = luaL_checknumber(L, -2);
  if (! lua_isnil(L, -1)) fracdim  = luaL_checknumber(L, -1);

  lua_pop(L, 4);

  // validation... 
  SYS_ASSERT(sky_pixels);

  if (map_id < 1 || map_id > MAX_COLOR_MAPS)
    return luaL_error(L, "fsky_add_hills: colmap value out of range");

  if (min_h >= max_h || max_h <= 0.0)
    return luaL_error(L, "fsky_add_hills: bad height range");

  if (powscale < 0.01)
    return luaL_error(L, "fsky_add_hills: bad power value");

  if (fracdim > 2.99 || fracdim < 0.2)
    return luaL_error(L, "fsky_add_hills: bad fracdim value");

  SKY_AddHills(seed,  sky_pixels, sky_W, sky_H,
              &color_mappings[map_id-1], min_h, max_h,
              powscale, fracdim);

  return 0;
}


//------------------------------------------------------------------------

static int FontIndexForChar(char ch)
{
  ch = toupper(ch);

  if (ch == ' ')
    return 0;

  if ('A' <= ch && ch <= 'Z')
    return 12 + (ch - 'A');

  if ('0' <= ch && ch <= '9')
    return 1 + (ch - '0');

  switch (ch)
  {
    case ':':
    case ';':
    case '=': return 11;

    case '-':
    case '_': return 38;

    case '.':
    case ',': return 39;

    case '!': return 40;
    case '?': return 41;

    case '\'':
    case '`':
    case '"': return 42;

    case '&': return 43;

    case '\\':
    case '/': return 44;

    // does not exist
    default: return -1;
  }
}

static void BlastFontChar(int index, int x, int y,
                          byte *pixels, int W, int H,
                          const logo_image_t *font, int fw, int fh,
                          const color_mapping_t *map, int thresh)
{
  SYS_ASSERT(0 <= index && index < 44);

  int fx = fw * (index % 11);
  int fy = fh * (index / 11);

  SYS_ASSERT(0 <= fx && fx+fw <= font->width);
  SYS_ASSERT(0 <= fy && fy+fh <= font->height);

  SYS_ASSERT(0 <= x && x+fw <= W);
  SYS_ASSERT(0 <= y && y+fh <= H);


  for (int dy = 0; dy < fh; dy++)
  for (int dx = 0; dx < fw; dx++)
  {
    byte pix = font->data[(fy+dy)*font->width + (fx+dx)];

    if (pix < thresh)
      continue;

    // map pixel
    pix = map->colors[map->size * (pix-thresh) / (256-thresh)];

    pixels[(y+dy)*W + (x+dx)] = pix;
  }
}

static void CreateNamePatch(const char *patch, const char *text,
                            const logo_image_t *font,
                            const color_mapping_t *map)
{
  // TODO: adjustable threshhold
  int thresh = 16;

  int font_w = font->width / 11;
  int font_h = font->height / 4;

  int buffer[64];
  int length = 0;

  // Convert string to font indexes (0 = space, 1+ = index)

  for (; *text && length < 60; text++)
  {
    int idx = FontIndexForChar(*text);

    if (idx >= 0)
      buffer[length++] = idx;
  }

  if (length == 0)
  {
    buffer[length++] = 41;
    buffer[length++] = 41;
  }


  int W = font_w * length;
  int H = font_h;

  byte *pixels = new byte[W * H];

  memset(pixels, 255, W * H);

  for (int p = 0; p < length; p++)
  {
    if (buffer[p] <= 0)
      continue;

    BlastFontChar(buffer[p] - 1, p * font_w, 0,
                  pixels, W, H,
                  font, font_w, font_h,
                  map, thresh);
  }

  qLump_c *lump = DM_CreatePatch(W, H, 0, 0, pixels, W, H, 255);

  DM_WriteLump(patch, lump);

  delete lump;
  delete[] pixels;
}

int DM_wad_name_gfx(lua_State *L)
{
  // LUA: wad_name_gfx(patch, text, colmap)

  const char *patch = luaL_checkstring(L, 1);
  const char *text  = luaL_checkstring(L, 2);

  int map_id = luaL_checkint(L, 3);

  if (map_id < 1 || map_id > MAX_COLOR_MAPS)
    return luaL_argerror(L, 1, "colmap value out of range");

  CreateNamePatch(patch, text, &font_CWILV, &color_mappings[map_id-1]);

  return 0;
}

int DM_wad_add_text_lump(lua_State *L)
{
  // LUA: wad_name_gfx(lump, strings)
  //
  // The 'strings' parameter is a table.

  const char *name = luaL_checkstring(L, 1);

  if (lua_type(L, 2) != LUA_TTABLE)
  {
    return luaL_argerror(L, 2, "expected a table: strings");
  }
 
  qLump_c *lump = new qLump_c();

  // grab all the strings from the table
  for (int i = 0; true; i++)
  {
    lua_pushinteger(L, 1+i);
    lua_gettable(L, 2);

    if (lua_isnil(L, -1))
    {
      lua_pop(L, 1);
      break;
    }

    if (lua_type(L, -1) != LUA_TSTRING)
      return luaL_error(L, "wad_add_text_lump: item #%d is not a string", 1+i);

    // use this method since it allows embedded zeros in the string
    // (just in case some crazy person wants to write a binary lump).
    size_t len;
    const char *str = lua_tolstring(L, -1, &len);

    lump->Append(str, (int)len);

    lua_pop(L, 1);
  }

  DM_WriteLump(name, lump);

  delete lump;

  return 0;
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
