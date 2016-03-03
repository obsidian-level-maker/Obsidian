//----------------------------------------------------------------------------
//
//  Angular Occlusion Buffer
// 
//  Copyright (c) 2007,2013  Andrew Apted
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
//----------------------------------------------------------------------------

#ifndef __VIS_OCCLUDE_H__
#define __VIS_OCCLUDE_H__

// all angles are in degrees, and must be in the range [-720,+720]

void Occlusion_Clear(void);
void Occlusion_Dump(void);

void Occlusion_Set(float low, float high);

bool Occlusion_Blocked(float low, float high);

#endif /* __VIS_OCCLUDE_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
