//------------------------------------------------------------------------
//  LEVEL building - Quake 1 format
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

#ifndef __OBLIGE_QUAKE1_H__
#define __OBLIGE_QUAKE1_H__

void Quake1_Init(void);

bool Quake1_Start(const char *target_file);
bool Quake1_Finish(void);

/// bool Quake1_Nodes();
void Quake1_Tidy(void);


// internal API

typedef std::vector<u8_t> qLump_c;

qLump_c *Q1_NewLump(int entry);

void Q1_Append(qLump_c *lump, const void *data, u32_t len);
void Q1_Printf(qLump_c *lump, const char *str, ...);

u16_t Q1_AddPlane(double dx, double dy, double dz, double dist);


// q1_bsp.cc

void Quake1_BuildBSP(void);


#endif /* __OBLIGE_QUAKE1_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
