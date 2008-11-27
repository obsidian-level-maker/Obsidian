//------------------------------------------------------------------------
//  EXTRA stuff for DOOM
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


static void SkyTest2()
{
  std::vector<byte> star_cols;

  static byte star_mapping[15] =
  {
    8, 7, 6, 5,
    111, 109, 107, 104, 101,
    98, 95, 91, 87, 83,
    4
  };

  for (int k=0; k < 15; k++)
    star_cols.push_back(star_mapping[k]);

///  byte *pixels = SKY_GenStars(3, 256,128, star_cols, 2.0);


  std::vector<byte> cloud_cols;

#if 0
  static byte cloud_mapping[14] =
  {
    106,104,102,100,
    98,96,94,92,90,
    88,86,84,82,80
  };
#endif

  static byte hell_mapping[14] =
  {
    188,185,184,183,182,181,180,
    179,178,177,176,175,174,173
  };

#if 0
  static byte blue_mapping[14] =
  {
    245,245,244,244,243,242,241,
    240,206,205,204,204,203,203
  };
#endif

  for (int n=0; n < 14; n++)
    cloud_cols.push_back(hell_mapping[n]);

  byte *pixels = SKY_GenClouds(5, 256,128, cloud_cols, 3.0, 2.6, 1.0);
//  byte *pixels = SKY_GenGradient(256,128, cloud_cols);


  static byte hill_mapping[10] =
  {
    0, 2, 1,
    79, 77, 75, 73, 70, 67, 64,
  };

  static byte hill_of_hell[10] =
  {
    0, 6,
    47, 45, 43, 41, 39, 37, 35, 33
  };

  std::vector<byte> hill_cols;

  for (int i=0; i < 10; i++)
    hill_cols.push_back(hill_of_hell[i]);

  SKY_AddHills(5, pixels, 256,128, hill_cols, 0.2,0.9, 2.1,2.1);


  std::vector<byte> build_cols;

  build_cols.push_back(0);
  build_cols.push_back(3);

//  SKY_AddBuilding(1, pixels, 256, 128, build_cols,   4,32, 61,40,  90,2,2);
//  SKY_AddBuilding(2, pixels, 256, 128, build_cols,  90,40, 31,30,  50,2,2);
//  SKY_AddBuilding(3, pixels, 256, 128, build_cols, 200,48, 71,40,  70,2,2);

  build_cols[1] = 162;
//  SKY_AddBuilding(4, pixels, 256, 128, build_cols,  40,20, 122,0,  30,1,1);
//  SKY_AddBuilding(5, pixels, 256, 128, build_cols, 150,32, 91, 0,  60,1,1);


  qLump_c *lump = DM_CreatePatch(256, 128, 0, 0, pixels, 256, 128);

  DM_WriteLump("RSKY1", lump);

  delete lump;

  delete[] pixels;
}

static void LogoTest1()
{
  byte *pixels = new byte[128*128];

#if 0
  static byte bronze_mapping[13] =
  {
    0, 2,
    191, 189, 187,
    235, 233,
    223, 221, 219, 216, 213, 210
  };
#endif

  static byte green_mapping[12] =
  {
    0, 7,
    127, 126, 125, 124, 123, 122, 120, 118, 116, 113
  };


  for (int y = 0; y < 128; y++)
  for (int x = 0; x < 128; x++)
  {
    byte ity = logo_RELIEF.data[(y&63)*64+(x&63)];

    pixels[y*128+x] = green_mapping[(ity*12)/256];
  }

  qLump_c *lump = DM_CreatePatch(128, 128, 0,0, pixels, 128, 128);

  DM_WriteLump("WALL52_1", lump);

  delete lump;
  delete[] pixels;
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

int DM_make_name_gfx(lua_State *L)
{
  // LUA: make_name_gfx(patch, text, colmap)

  const char *patch = luaL_checkstring(L, 1);
  const char *text  = luaL_checkstring(L, 2);

  int map_id = luaL_checkint(L, 3);

  if (map_id < 1 || map_id > MAX_COLOR_MAPS)
    return luaL_argerror(L, 1, "colmap value out of range");

  CreateNamePatch(patch, text, &font_CWILV, &color_mappings[map_id-1]);

  return 0;
}


//------------------------------------------------------------------------

static qLump_c *bex_strs;
static qLump_c *bex_music;

void BEX_Start()
{
  if (bex_strs)  delete bex_strs;
  if (bex_music) delete bex_music;

  bex_strs  = new qLump_c();
  bex_music = new qLump_c();
}

void BEX_Finish()
{
  if (bex_strs->GetSize() > 0 || bex_music->GetSize() > 0)
  {
    qLump_c dehacked;

    dehacked.Printf("#\n");
    dehacked.Printf("# BEX LUMP created by OBLIGE %s\n", OBLIGE_VERSION);
    dehacked.Printf("#\n\n");

    dehacked.Append(bex_strs);
    dehacked.Append(bex_music);

    DM_WriteLump("DEHACKED", &dehacked);
  }

  delete bex_strs;  bex_strs  = NULL;
  delete bex_music; bex_music = NULL;
}


void BEX_AddString(const char *key, const char *value)
{
  if (bex_strs->GetSize() == 0)
  {
    bex_strs->Printf("[STRINGS]\n");
  }

  bex_strs->Printf("%s = %s\n", key, value);
}

int DM_bex_add_string(lua_State *L)
{
  // LUA: bex_add_string(key, value)

  const char *key   = luaL_checkstring(L, 1);
  const char *value = luaL_checkstring(L, 2);

  BEX_AddString(key, value);

  return 0;
}


void BEX_AddMusic(const char *track, const char *spec)
{
  if (bex_music->GetSize() == 0)
  {
    bex_music->Printf("[MUSIC]\n");
  }

  bex_music->Printf("%s = %s\n", track, spec);
}

int DM_bex_add_music(lua_State *L)
{
  // LUA: bex_add_music(track, spec)

  const char *track = luaL_checkstring(L, 1);
  const char *spec  = luaL_checkstring(L, 2);

  BEX_AddMusic(track, spec);

  return 0;
}


//------------------------------------------------------------------------

static qLump_c *ddf_lang;
static qLump_c *ddf_play;


void DDF_Start()
{
  if (ddf_lang) delete ddf_lang;
  if (ddf_play) delete ddf_play;

  ddf_lang = new qLump_c();
  ddf_play = new qLump_c();
}

void DDF_Finish()
{
  if (ddf_lang->GetSize() > 0)
    DM_WriteLump("DDFLANG", ddf_lang);

  if (ddf_play->GetSize() > 0)
    DM_WriteLump("DDFPLAY", ddf_play);

  delete ddf_lang; ddf_lang = NULL;
  delete ddf_play; ddf_play = NULL;
}


void DDF_AddString(const char *key, const char *value)
{
  if (ddf_lang->GetSize() == 0)
  {
    ddf_lang->Printf("//\n");
    ddf_lang->Printf("// Language.ldf created by OBLIGE %s\n", OBLIGE_VERSION);
    ddf_lang->Printf("//\n\n");
    ddf_lang->Printf("<LANGUAGES>\n\n");
    ddf_lang->Printf("[ENGLISH]\n");
  }

  ddf_lang->Printf("%s = \"%s\";\n", key, value);
}

int DM_ddf_add_string(lua_State *L)
{
  // LUA: ddf_add_string(key, value)

  const char *key   = luaL_checkstring(L, 1);
  const char *value = luaL_checkstring(L, 2);

  DDF_AddString(key, value);

  return 0;
}


void DDF_AddMusic(const char *track, const char *spec)
{
  if (ddf_play->GetSize() == 0)
  {
    ddf_play->Printf("//\n");
    ddf_play->Printf("// Playlist.ddf created by OBLIGE %s\n", OBLIGE_VERSION);
    ddf_play->Printf("//\n\n");
    ddf_play->Printf("<PLAYLISTS>\n\n");
  }

  ddf_play->Printf("[%s] MUSICINFO = %s;\n", track, spec);
}

int DM_ddf_add_music(lua_State *L)
{
  // LUA: ddf_add_music(track, spec)

  const char *track = luaL_checkstring(L, 1);
  const char *spec  = luaL_checkstring(L, 2);

  DDF_AddMusic(track, spec);

  return 0;
}


//------------------------------------------------------------------------

static qLump_c *dd_defns;

void DED_Start()
{
  if (dd_defns)
    delete dd_defns;

  dd_defns = new qLump_c();
}

void DED_Finish()
{
  if (dd_defns->GetSize() > 0)
  {
    DM_WriteLump("DD_DEFNS", dd_defns);
  }

  delete dd_defns; dd_defns = NULL;
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
