//------------------------------------------------------------------------
//  LEVEL building - QUAKE 1 LIGHTING
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
#include "main.h"

#include "csg_main.h"

#include "q_bsp.h"
#include "q2_main.h"
#include "q2_structs.h"


class qLightmap_c
{
public:
  int w, h;

  float *samples;

public:
  qLightmap_c(int width, int height) : w(width), h(height)
  {
    samples = new float[w * h];
  }

  ~qLightmap_c()
  {
    delete[] samples;
  }

  void Clear()
  {
    for (int i = 0; i < w*h; i++)
      samples[i] = 0.0f;
  }
};


static qLump_c *q1_lightmap;


void Quake1_BeginLightmap(void)
{
  q1_lightmap = BSP_NewLump(LUMP_LIGHTING);

  const char *info = "Lit by " OBLIGE_TITLE " " OBLIGE_VERSION;

  q1_lightmap->Append(info, strlen(info));
}


s32_t Quake1_LightAddBlock(int w, int h, u8_t level)
{
  s32_t offset = q1_lightmap->GetSize();

byte zero = 0;
byte mid;
  for (int i = 0; i < w*h; i++)
  {
    mid = level * (i/w) / h;

    q1_lightmap->Append(&level, 1);
    q1_lightmap->Append(&mid,   1);
    q1_lightmap->Append(&zero,  1);
  }

  return offset;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
