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


// FIXME: header-file it??
extern void DM_WriteLump(const char *name, qLump_c *lump);


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

  static byte cloud_mapping[14] =
  {
    106,104,102,100,
    98,96,94,92,90,
    88,86,84,82,80
  };

  static byte hell_mapping[14] =
  {
    188,185,184,183,182,181,180,
    179,178,177,176,175,174,173
  };

  static byte blue_mapping[14] =
  {
    245,245,244,244,243,242,241,
    240,206,205,204,204,203,203
  };


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

  static byte bronze_mapping[13] =
  {
    0, 2,
    191, 189, 187,
    235, 233,
    223, 221, 219, 216, 213, 210
  };

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

static void FontTest3()
{
  byte *pixels = new byte[99*64];

  static byte gold_mapping[12] =
  {
    247, 47, 44,
    167, 166, 165, 164, 163, 162, 161, 160,
    // 226,
    225
  };

  for (int y = 0; y < 64; y++)
  for (int x = 0; x < 99; x++)
  {
    byte ity = font_CWILV.data[(y&63)*99+(x%99)];

    pixels[y*99+x] = (ity == 0) ? 247 : gold_mapping[(ity*12)/256];
  }

  qLump_c *lump = DM_CreatePatch(99*3, 160, 0,0, pixels, 99, 64, 247);

  DM_WriteLump("CWILV02", lump);

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
                          const logo_image_t *font, int fw, int fh)
{
  SYS_ASSERT(0 <= index && index < 44);

  int fx = fw * (index % 11);
  int fy = fh * (index / 11);

  SYS_ASSERT(0 <= fx && fx+fw <= font->width);
  SYS_ASSERT(0 <= fy && fy+fh <= font->height);

  SYS_ASSERT(0 <= x && x+fw <= W);
  SYS_ASSERT(0 <= y && y+fh <= H);


  // TODO: adjustable mappings and threshhold
  int thresh = 16;

  static byte gold_mapping[12] =
  {
    0, 47, 44,
    167, 166, 165, 164, 163, 162, 161, 160,
    // 226,
    225
  };

  static byte silver_mapping[14] =
  {
    0, 246, 243, 240,
    205, 202, 200, 198,
    196, 195, 194, 193, 192, 4,
  };

  static byte bronze_mapping[12] =
  {
    0, 2,  191, 188,  235, 232,
    221, 218, 215, 213, 211, 209
  };

  static byte iron_mapping[13] =
  {
    0, 7, 5,
    111, 109, 107, 104, 101, 98,
     94,  90,  86,  81
  };


  for (int dy = 0; dy < fh; dy++)
  for (int dx = 0; dx < fw; dx++)
  {
    byte pix = font->data[(fy+dy)*font->width + (fx+dx)];

    if (pix >= thresh)
    {
      // map pixel
      pix = iron_mapping[sizeof(iron_mapping) * (pix-thresh) / (256-thresh)];

      pixels[(y+dy)*W + (x+dx)] = pix;
    }
  }
}

static void CreateNamePatch(const char *patch_name, const char *name,
                            const logo_image_t *font)
{
  int font_w = font->width / 11;
  int font_h = font->height / 4;

  int buffer[64];
  int length = 0;

  // Convert string to font indexes (0 = space, 1+ = index)

  for (; *name && length < 60; name++)
  {
    int idx = FontIndexForChar(*name);

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
    if (buffer[p] > 0)
      BlastFontChar(buffer[p] - 1, p * font_w, 0,
                    pixels, W, H,
                    font, font_w, font_h);
  }

  qLump_c *lump = DM_CreatePatch(W, H, 0, 0, pixels, W, H, 255);

  DM_WriteLump(patch_name, lump);

  delete lump;
  delete[] pixels;
}


//------------------------------------------------------------------------

static qLump_c *bex_lump;

void BEX_Start()
{
  if (bex_lump)
    delete bex_lump;

  bex_lump = new qLump_c();
}

void BEX_AddString(const char *str)
{
  if (bex_lump->GetSize() == 0)
  {
    bex_lump->Printf("# BEX LUMP created by OBLIGE %s\n\n", OBLIGE_VERSION);
    bex_lump->Printf("[STRINGS]\n");
  }

  bex_lump->Printf("%s\n", str);
}

void BEX_Finish()
{
  if (bex_lump->GetSize() > 0)
  {
    DM_WriteLump("DEHACKED", bex_lump);
  }
  delete bex_lump;
}


//------------------------------------------------------------------------

static qLump_c *ddf_lang;

void DDF_Start()
{
  if (ddf_lang)
    delete ddf_lang;

  ddf_lang = new qLump_c();
}

void DDF_AddString(const char *str)
{
  if (ddf_lang->GetSize() == 0)
  {
    ddf_lang->Printf("//\n");
    ddf_lang->Printf("// Language.ldf created by OBLIGE %s\n", OBLIGE_VERSION);
    ddf_lang->Printf("//\n\n");
    ddf_lang->Printf("<LANGUAGES>\n\n");
    ddf_lang->Printf("[ENGLISH]\n");
  }

  ddf_lang->Printf("%s;\n", str);
}

void DDF_Finish()
{
  if (ddf_lang->GetSize() > 0)
  {
    DM_WriteLump("DDFLANG", ddf_lang);
  }
  delete ddf_lang;

  CreateNamePatch("CWILV02", "You Don't Belong Here/", &font_CWILV);
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
