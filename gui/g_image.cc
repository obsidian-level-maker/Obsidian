//------------------------------------------------------------------------
//  IMAGE manipulations
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

#include "lib_util.h"
#include "main.h"

#include "g_image.h"


// include the raw image data  FIXME: remove
byte raw_image_data[128*128+64*128] =
{
};


/*
static int slime_to_nukage_pairs[] =
{
  0x01,127, 0x4f,126, 0x4e,125, 0xee,124, 0x0f,123,
  0x4d,123, 0xed,122, 0x97,122, 0x4c,121, 0x4b,121,
  0x4a,120,

  -1, -1  // end marker
};

static int slime_to_blood_pairs[] =
{
  0x01,191, 0x4f,190, 0x4e,189, 0xee,188, 0x0f,187,
  0x4d, 38, 0xed,186, 0x97, 36, 0x4c,185, 0x4b, 33,
  0x4a,184,

  -1, -1  // end marker
};
*/


//------------------------------------------------------------------------

static byte pixel_to_doom[256];
static byte pixel_to_heretic[256];
static byte pixel_to_hexen[256];

static int FindColor(const byte *palette, const byte *col)
{
  int r = col[0];
  int g = col[1];
  int b = col[2];

  int best_idx  = -1;
  int best_dist = (1<<30);
  
  for (int j = 0; j < 256; j++)
  {
    int dr = palette[j*3 + 0] - r;
    int dg = palette[j*3 + 1] - g;
    int db = palette[j*3 + 2] - b;

    int dist = dr*dr + dg*dg + db*db;

    if (dist == 0) // exact match!
      return j;

    if (dist < best_dist)
    {
      best_idx  = j;
      best_dist = dist;
    }
  }

  SYS_ASSERT(best_idx >= 0);

  return best_idx;
}

/*
static int FindPair(const int *pairs, int index)
{
  for (int j = 0; pairs[j] >= 0; j += 2)
  {
    if (pairs[j] == index)
      return pairs[j+1];
  }

  return index;
}
*/

static void CreateMappingTables(void)
{
  for (int i = 0; i < 256; i++)
  {
    pixel_to_doom   [i] = i; // already in DOOM palette
    pixel_to_heretic[i] = FindColor(heretic_palette, doom_palette + i*3);
    pixel_to_hexen  [i] = FindColor(  hexen_palette, doom_palette + i*3);
  }
}

void Image_Setup(void)
{
  CreateMappingTables();
}


//------------------------------------------------------------------------

static void FillPost(byte *pat, int x, const byte *src, int src_w, int src_h,
                     int dest_w, int dest_h, const byte *mapper)
{
  // determine and set the offset value

  int offset = 8 + dest_w*4 + (x % src_w) * (dest_h+8);

  byte *ofs_var = pat + 8 + x*4;

  ofs_var[0] = offset & 0xFF;
  ofs_var[1] = (offset >>  8) & 0xFF;
  ofs_var[2] = (offset >> 16) & 0xFF;

  if (x >= src_w)
    return;

  // actually fill in the post

  src += (x % src_w);

  byte *dest = pat + offset;
  int y;

#undef  PIXEL
#define PIXEL(yy)  mapper[src[(src_h-1-(yy)) * src_w]]

  *dest++ = 0;      // Y-OFFSET
  *dest++ = dest_h; // # PIXELS

  *dest++ = PIXEL(0);  // TOP-PADDING

  for (y=0; y < dest_h; y++)
    *dest++ = PIXEL(y);

  *dest++ = PIXEL(y-1);  // BOTTOM-PADDING

  *dest++ = 255; // END-OF-POST
}

const byte *Image_MakePatch(int what, int *length, int dest_w, const char *game)
{
  SYS_ASSERT(0 <= what && what <= 1);

  const byte *src = raw_image_data + (what ? 128*128 : 0);

  int src_w = what ? 64 : 128;
  int src_h = 128;

  int dest_h = 128;

  SYS_ASSERT(dest_h <= src_h);
  SYS_ASSERT(dest_h <= 254);

  *length = 8 + dest_w*4 + src_w * (dest_h+8);

  byte *pat = new byte[*length];

  memset(pat, 0, *length);

  // patch header
  pat[0] = (dest_w & 0xFF);
  pat[1] = (dest_w >> 8) & 0xFF;

  pat[2] = dest_h;

  // palette conversion
  const byte *mapper = pixel_to_doom;

  if (strcmp(game, "heretic") == 0)
    mapper = pixel_to_heretic;

  if (strcmp(game, "hexen") == 0)
    mapper = pixel_to_hexen;

  // patch posts
  for (int x=0; x < dest_w; x++)
  {
    FillPost(pat, x, src,src_w,src_h, dest_w,dest_h, mapper);
  }

  return pat;
}

void Image_FreePatch(const byte *pat)
{
  delete[] pat;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
