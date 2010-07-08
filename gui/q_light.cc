//------------------------------------------------------------------------
//  QUAKE 1/2 LIGHTING
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

#include "csg_main.h"

#include "q_bsp.h"
#include "q_light.h"
#include "q1_main.h"
#include "q1_structs.h"


qLightmap_c::qLightmap_c(int w, int h, float value) : width(w), height(h), offset(-1)
{
  if (width > 1 || height > 1)
    samples = new float[width * height];
  else
    samples = &flat;

  if (value >= 0)
    Fill(value);
}

qLightmap_c::~qLightmap_c()
{
  if (width > 1 || height > 1)
    delete[] samples;
}

void qLightmap_c::Fill(float value)
{
  for (int i = 0 ; i < width*height ; i++)
    samples[i] = value;
}


void qLightmap_c::Clamp()
{
  for (int i = 0 ; i < width*height ; i++)
  {
    if (samples[i] < 0)   samples[i] = 0;
    if (samples[i] > 255) samples[i] = 255;
  }
}


void qLightmap_c::GetRange(float *low, float *high, float *avg)
{
  *low  = +9e9;
  *high = -9e9;
  *avg  = 0;

  for (int i = 0 ; i < width*height ; i++)
  {
    if (samples[i] < *low)  *low  = samples[i];
    if (samples[i] > *high) *high = samples[i];

    *avg += samples[i];
  }

  *avg /= (float)(width * height);
}


void qLightmap_c::Add(double x, double y, float value)
{
  if (0 <= x && x < width && 0 <= y && y < height)
  {
    int i = (int)x + (int)y * width;

    samples[i] += value;
  }
}


void qLightmap_c::Flatten(float avg)
{
  if (isFlat())
    return;

  if (avg < 0)
  {
    float low, high;

    GetRange(&low, &high, &avg);
  }

  flat = avg;

  width = height = 1;

  delete[] samples; samples = NULL;
}


void qLightmap_c::Write(qLump_c *lump, bool colored)
{
  if (isFlat())
  {
    offset = colored ? 1 : 0;
    return;
  }

  offset = lump->GetSize();

  int total = width * height;

  Clamp();

  for (int i = 0 ; i < total ; i++)
  {
    byte datum = (byte) samples[i];

    lump->Append(&datum, 1);

    if (colored)
    {
      lump->Append(&datum, 1);
      lump->Append(&datum, 1);
    }
  }
}


int qLightmap_c::CalcOffset() const
{
  if (! isFlat())
    return offset;

  // compute offset of a flat lightmap
  int result = (int) samples[0];

  if (result > 128)
  {
    result = 64 + result / 2;
  }

  return result * (offset ? 3 : 1);
}


//------------------------------------------------------------------------

static std::vector<qLightmap_c *> all_lightmaps;

static qLump_c *light_lump;
static bool light_colored;


void BSP_InitLightmaps()
{
  all_lightmaps.clear();
}


void BSP_ClearLightmaps()
{
  for (unsigned int i = 0 ; i < all_lightmaps.size() ; i++)
    delete all_lightmaps[i];

  all_lightmaps.clear();
}


static void WriteFlatBlock(int level, int size)
{
  if (light_colored)
    size *= 3;

  byte datum = (byte)level;

  for ( ; level > 0 ; level--)
    light_lump->Append(&datum, 1);
}


void BSP_BuildLightmap(qLump_c * lump, bool colored, int max_size)
{
  light_lump = lump;
  light_colored = colored;

  // at the start are a bunch of completely flat lightmaps.
  // for the overbright range (129-255) there are half as many.

  int i;

  for (i = 0 ; i < 128 ; i++)
  {
    WriteFlatBlock(i, FLAT_LIGHTMAP_SIZE);
    max_size -= FLAT_LIGHTMAP_SIZE;
  }

  for (i = 128 ; i < 256 ; i += 2)
  {
    WriteFlatBlock(i, FLAT_LIGHTMAP_SIZE);
    max_size -= FLAT_LIGHTMAP_SIZE;
  }


  // FIXME !!!! : check if lump would overflow, if yes then flatten some maps


  for (unsigned int k = 0 ; k < all_lightmaps.size() ; k++)
  {
    qLightmap_c *L = all_lightmaps[k];

    L->Write(light_lump, light_colored);
  }


  BSP_ClearLightmaps();
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
