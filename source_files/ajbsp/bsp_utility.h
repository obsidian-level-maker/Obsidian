//------------------------------------------------------------------------
//  UTILITIES
//------------------------------------------------------------------------
//
//  Copyright (C) 2001-2023 Andrew Apted
//  Copyright (C) 1997-2003 André Majorel et al
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

#pragma once

#include <stdint.h>

namespace ajbsp
{

// memory allocation, guaranteed to not return nullptr.
void *UtilCalloc(int size);
void *UtilRealloc(void *old, int size);
void  UtilFree(void *data);

// math stuff
double ComputeAngle(double dx, double dy);

// checksum functions
void Adler32Begin(uint32_t *crc);
void Adler32AddBlock(uint32_t *crc, const uint8_t *data, int length);

}  // namespace ajbsp

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
