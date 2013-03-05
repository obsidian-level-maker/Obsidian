//------------------------------------------------------------------------
//  SKY GENERATION
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

#ifndef __OBLIGE_TX_SKIES_H__
#define __OBLIGE_TX_SKIES_H__

void SKY_AddStars(int seed, byte *pixels, int W, int H,
                  color_mapping_t *map, double powscale, double thresh);

void SKY_AddClouds(int seed, byte *pixels, int W, int H,
                   color_mapping_t *map, double powscale, double thresh,
                   double fracdim, double squish);

void SKY_AddHills(int seed, byte *pixels, int W, int H,
                  color_mapping_t *map, double min_h, double max_h,
                  double powscale, double fracdim);

void SKY_AddBuilding(int seed, byte *pixels, int W, int H,
                     std::vector<byte> & colors,
                     int pos_x, int width, int base_h, int top_h=0,
                     int win_prob=50, int win_w=2, int win_h=2,
                     int antenna=0);

#endif /* __OBLIGE_TX_SKIES_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
