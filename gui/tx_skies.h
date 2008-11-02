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

#ifndef __OBLIGE_TX_SKIES_H__
#define __OBLIGE_TX_SKIES_H__

byte * SKY_GenGradient(int W, int H, std::vector<byte> & colors);

byte * SKY_GenClouds(int seed, int W, int H, std::vector<byte> & colors,
                     float squish=1.0, double fracdim=2.4, double powscale=1.2);

byte * SKY_GenStars(int seed, int W, int H, std::vector<byte> & colors,
                    double powscale=3.0, double cutoff=0.25);

void SKY_AddHills(int seed, byte *pixels, int W, int H,
                  std::vector<byte> & colors,
                  float min_h=0, float max_h=0.8,
                  double fracdim=2.0, double powscale=0.8);

void SKY_AddBuilding(int seed, byte *pixels, int W, int H,
                     std::vector<byte> & colors,
                     int pos_x, int width, int base_h, int top_h=0,
                     int win_prob=50, int win_w=2, int win_h=2,
                     int antenna=0);

#endif /* __OBLIGE_TX_SKIES_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
