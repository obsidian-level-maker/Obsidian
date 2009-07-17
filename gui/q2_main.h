//------------------------------------------------------------------------
//  LEVEL building - Quake II format
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2009 Andrew Apted
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

#ifndef __OBLIGE_QUAKE2_H__
#define __OBLIGE_QUAKE2_H__


game_interface_c * Quake2_GameObject(void);


//------------------------------------------------------------------------
// INTERNAL API
//------------------------------------------------------------------------

class qLump_c;
class csg_brush_c;

u16_t Q2_AddTexInfo(const char *texture, int flags, int value,
                    double *s4, double *t4);
u16_t Q2_AddBrush(const csg_brush_c *A);

// q2_nodes.cc

void Q2_CreateModel(void);


#endif /* __OBLIGE_QUAKE2_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
