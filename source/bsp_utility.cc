//------------------------------------------------------------------------
//  UTILITIES
//------------------------------------------------------------------------
//
//  Copyright (C) 2001-2018 Andrew Apted
//  Copyright (C) 1997-2003 Andr� Majorel et al
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

#include "bsp_utility.h"

#include "bsp_local.h"
#include "sys_macro.h"

namespace ajbsp
{

//------------------------------------------------------------------------
// MEMORY ALLOCATION
//------------------------------------------------------------------------

//
// Allocate memory with error checking.  Zeros the memory.
//
void *UtilCalloc(int size)
{
    void *ret = calloc(1, size);

    if (!ret)
        cur_info->FatalError("Out of memory (cannot allocate %d bytes)\n", size);

    return ret;
}

//
// Reallocate memory with error checking.
//
void *UtilRealloc(void *old, int size)
{
    void *ret = realloc(old, size);

    if (!ret)
        cur_info->FatalError("Out of memory (cannot reallocate %d bytes)\n", size);

    return ret;
}

//
// Free the memory with error checking.
//
void UtilFree(void *data)
{
    if (data == NULL)
        BugError("Trying to free a NULL pointer\n");

    free(data);
}

//------------------------------------------------------------------------
// MATH STUFF
//------------------------------------------------------------------------

//
// rounds the value _up_ to the nearest power of two.
//
int RoundPOW2(int x)
{
    if (x <= 2)
        return x;

    x--;

    for (int tmp = x >> 1; tmp; tmp >>= 1)
        x |= tmp;

    return x + 1;
}

//
// Compute angle of line from (0,0) to (dx,dy).
// Result is degrees, where 0 is east and 90 is north.
//
double ComputeAngle(double dx, double dy)
{
    double angle;

    if (dx == 0)
        return (dy > 0) ? 90.0 : 270.0;

    angle = atan2((double)dy, (double)dx) * 180.0 / M_PI;

    if (angle < 0)
        angle += 360.0;

    return angle;
}

} // namespace ajbsp

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
