//------------------------------------------------------------------------
//  2.5D CSG : NUKEM output
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2010 Andrew Apted
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

#ifndef __OBLIGE_NUKEM_LEVEL_H__
#define __OBLIGE_NUKEM_LEVEL_H__

void NK_AddSector(int first_wall, int num_wall, int visibility,
                  int f_h, int f_pic,
                  int c_h, int c_pic, int c_flags,
                  int lo_tag=0, int hi_tag=0);

void NK_AddWall(int x, int y, int right, int back, int back_sec, 
                int flags, int pic, int mask_pic,
                int xscale, int yscale, int xpan, int ypan,
                int lo_tag=0, int hi_tag=0);

void NK_AddSprite(int x, int y, int z, int pic, int angle, int sec,
                  int lo_tag=0, int hi_tag=0);

int NK_NumSectors(void);
int NK_NumWalls(void);
int NK_NumSprites(void);

#endif /* __OBLIGE_NUKEM_LEVEL_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
