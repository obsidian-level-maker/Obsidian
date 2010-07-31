//------------------------------------------------------------------------
//  DUKE NUKEM : ART STUFF (etc)
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2008-2010 Andrew Apted
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

#include "nk_structs.h"
#include "q_common.h"  // qLump_c

#include "img_all.h"
#include "tx_forge.h"
#include "tx_skies.h"


#define LOGO_ART_FILE  "TILES020.ART"
#define LOGO_START  6600

#define MAX_LOGOS  8


class nukem_picture_c
{
public:
  int width;
  int height;
  int anim;

  byte *pixels;

public:
  nukem_picture_c(int _W, int _H) : width(_W), height(_H), anim(0)
  {
    pixels = new byte[width * height];
  }

  ~nukem_picture_c()
  {
    delete[] pixels;
  }

  byte& at(int x, int y) const
  {
    return pixels[y * width + x];
  }

  void Clear()
  {
    memset(pixels, 0, width * height);
  }

  void Write()
  {
    GRP_AppendData(pixels, width * height);
  }
};


static nukem_picture_c *nk_logos[MAX_LOGOS];


void NK_InitArt()
{
  for (int i = 0; i < MAX_LOGOS; i++)
    if (nk_logos[i])
    {
      delete nk_logos[i];
      nk_logos[i] = NULL;
    }
}


int NK_grp_logo_gfx(lua_State *L)
{
  // LUA: grp_logo_gfx(index, image, W, H, colmap)

  int index = luaL_checkint(L, 1);
  if (index < 1 || index > MAX_LOGOS)
    return luaL_argerror(L, 1, "index value out of range");

  index--;

  const char *image = luaL_checkstring(L, 2);

  int new_W  = luaL_checkint(L, 3);
  int new_H  = luaL_checkint(L, 4);
  int map_id = luaL_checkint(L, 5);

  if (new_W < 1) return luaL_argerror(L, 3, "bad width");
  if (new_H < 1) return luaL_argerror(L, 4, "bad height");

  if (map_id < 1 || map_id > MAX_COLOR_MAPS)
    return luaL_argerror(L, 5, "colmap value out of range");


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
    return luaL_argerror(L, 2, "unknown image name");


  // colorize logo
  color_mapping_t *map = &color_mappings[map_id-1];

  if (map->size < 2)
    return luaL_error(L, "grp_logo_gfx: colormap too small");


  nukem_picture_c *pic = new nukem_picture_c(new_W, new_H);

  if (nk_logos[index])
    delete nk_logos[index];

  nk_logos[index] = pic;


  byte *pixels = pic->pixels;
  byte *p_end = pixels + (logo->width * logo->height);

  const byte *src = logo->data;

  for (byte *dest = pixels; dest < p_end; dest++, src++)
  {
    int idx = ((*src) * map->size) >> 8;

    *dest = map->colors[idx];
  }

  return 0;
}


void NK_WriteLogos()
{
  GRP_NewLump(LOGO_ART_FILE);

  int i;

  for (i = 0; i < MAX_LOGOS; i++)
  {
    if (! nk_logos[i])
    {
      nk_logos[0] = new nukem_picture_c(8, 8);
      nk_logos[0]->Clear();
    }
  }

  raw_art_header_t header;

  header.version = LE_U32(1);

  header.num_pics  = LE_U32(8);
  header.first_pic = LE_U32(LOGO_START);
  header.last_pic  = LE_U32(LOGO_START+MAX_LOGOS-1);

  GRP_AppendData(&header, sizeof(header));

  for (i = 0; i < MAX_LOGOS; i++)
  {
    u16_t width = LE_U16(nk_logos[i]->width);
    GRP_AppendData(&width, sizeof(width));
  }

  for (i = 0; i < MAX_LOGOS; i++)
  {
    u16_t height = LE_U16(nk_logos[i]->height);
    GRP_AppendData(&height, sizeof(height));
  }

  for (i = 0; i < MAX_LOGOS; i++)
  {
    u32_t anim = LE_U32(nk_logos[i]->anim);
    GRP_AppendData(&anim, sizeof(anim));
  }

  for (i = 0; i < MAX_LOGOS; i++)
    nk_logos[i]->Write();

  GRP_FinishLump();

  // free them now
  NK_InitArt();
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
