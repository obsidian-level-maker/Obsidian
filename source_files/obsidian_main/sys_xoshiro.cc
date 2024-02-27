//------------------------------------------------------------------------
//  Xoshiro Random Number Generation
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2020-2024 The OBSIDIAN Team
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 3
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include "fastPRNG.h"

fastPRNG::fastXS64 xoshiro;

void XoshiroReseed(uint64_t new_seed) { xoshiro.seed(new_seed); }

uint64_t XoshiroInt()
{
    int64_t rand_num = (int64_t)(xoshiro.xoshiro256p());
    if (rand_num >= 0) { return rand_num; }
    return -rand_num;
}

double XoshiroDouble() { return xoshiro.xoshiro256p_UNI<double>(); }

// This probably isn't super efficient, but it is rarely used and shouldn't make
// a huge overall hit to performance - Dasho
int XoshiroBetween(int low, int high)
{
    return (int)(xoshiro.xoshiro256p_Range<float>(low, high));
}
