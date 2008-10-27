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

#endif /* __OBLIGE_TX_SKIES_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
