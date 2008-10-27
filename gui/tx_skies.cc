//------------------------------------------------------------------------
//  SKY GENERATION
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2008 Andrew Apted
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

#include "lib_util.h"
#include "main.h"

#include "twister.h"
#include "tx_forge.h"
#include "tx_skies.h"


static MT_rand_c sky_twist(0);


byte * SKY_GenGradient(int W, int H, std::vector<byte> & colors)
{
  int numcol = (int)colors.size();

  SYS_ASSERT(numcol > 0);

  byte *pixels = new byte[W * H];

  for (int y = 0; y < H; y++)
  {
    // we assume that (in general) top is light, bottom is dark
    int idx = (H-1-y) * numcol / H;

    byte color = colors[idx];

    byte *dest  = & pixels[y * W];
    byte *d_end = dest + W;

    while (dest < d_end)
    {
      *dest++ = color;
    }
  }

  return pixels;
}


byte * SKY_GenClouds(int seed, int W, int H, std::vector<byte> & colors,
                     float squish, double fracdim, double powscale)
{
  // SYS_ASSERT(is_power_of_two(W))
  // SYS_ASSERT(is_power_of_two(H))

  SYS_ASSERT(W >= H);

  int numcol = (int)colors.size();

  SYS_ASSERT(numcol > 0);
  SYS_ASSERT(squish > 0);

  float * synth = new float[W * W];

  TX_SpectralSynth(seed, synth, W, fracdim, powscale);

  byte *pixels = new byte[W * H];

  for (int y = 0; y < H; y++)
  {
    int sy = (int)(y * squish) & (H-1);

    const float *src = & synth[sy * W];

    byte *dest  = & pixels[y * W];
    byte *d_end = dest + W;

    while (dest < d_end)
    {
      int idx = (int)(*src++ * numcol);

      idx = CLAMP(0, idx, numcol-1);

      *dest++ = colors[idx];
    }
  }

  delete[] synth;

  return pixels;
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
