//------------------------------------------------------------------------
//  UTILITIES
//------------------------------------------------------------------------
//
//  Copyright (C) 2001-2013 Andrew Apted
//  Copyright (C) 1997-2003 André Majorel et al
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

#pragma once

namespace ajbsp
{

// memory allocation, guaranteed to not return NULL.
void *UtilCalloc(int size);
void *UtilRealloc(void *old, int size);
void  UtilFree(void *data);

// math stuff
int    RoundPOW2(int x);
double ComputeAngle(double dx, double dy);

} // namespace ajbsp

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
