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

void Occlusion_Clear(void);
void Occlusion_Set(angle_t low, angle_t high);

bool Occlusion_Test(angle_t low, angle_t high);

#endif /* __VIS_OCCLUDE_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
