//------------------------------------------------------------------------
//  LEVEL building - DOOM format
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

#ifndef __OBLIGE_DOOM_OUT_H__
#define __OBLIGE_DOOM_OUT_H__

class qLump_c;


/***** VARIABLES ****************/

typedef enum
{
	SUBFMT_Hexen  = 1,
	SUBFMT_Strife = 2,
}
doom_subformat_e;

extern int dm_sub_format;


/***** FUNCTIONS ****************/

bool DM_StartWAD(const char *filename);
bool DM_EndWAD();

void DM_BeginLevel();
void DM_EndLevel(const char *level_name);

void DM_WriteLump(const char *name, qLump_c *lump);

// the section parameter can be:
//   'P' : patches   //   'F' : flats
//   'S' : sprites   //   'C' : colormaps (Boom)
//   'T' : textures (Zdoom)
void DM_AddSectionLump(char section, const char *name, qLump_c *lump);


void DM_HeaderPrintf(const char *str, ...);


void DM_AddVertex(int x, int y);

void DM_AddSector(int f_h, const char * f_tex, 
                  int c_h, const char * c_tex,
                  int light, int special, int tag);

void DM_AddSidedef(int sector, const char *l_tex,
                   const char *m_tex, const char *u_tex,
                   int x_offset, int y_offset);

void DM_AddLinedef(int vert1, int vert2, int side1, int side2,
                   int type,  int flags, int tag,
                   const byte *args);

void DM_AddThing(int x, int y, int h, int type, int angle, int options,
                 int tid, byte special, const byte *args);

int DM_NumVertexes();
int DM_NumSectors();
int DM_NumSidedefs();
int DM_NumLinedefs();
int DM_NumThings();

#endif /* __OBLIGE_DOOM_OUT_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
