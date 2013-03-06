//------------------------------------------------------------------------
//  ARCHIVE Handling - GRP files
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

#ifndef __OBLIGE_LIB_GRP_H__
#define __OBLIGE_LIB_GRP_H__


/* GRP reading */

bool GRP_OpenRead(const char *filename);
void GRP_CloseRead(void);

int  GRP_NumEntries(void);
int  GRP_FindEntry(const char *name);
int  GRP_EntryLen(int entry);
const char * GRP_EntryName(int entry);

bool GRP_ReadData(int entry, int offset, int length, void *buffer);

void GRP_ListEntries(void);


/* GRP writing */

bool GRP_OpenWrite(const char *filename);
void GRP_CloseWrite(void);

void GRP_NewLump(const char *name);
bool GRP_AppendData(const void *data, int length);
void GRP_FinishLump(void);



/* ----- GRP structure ---------------------- */

typedef struct
{
	char magic[12];
	u32_t num_lumps;

} PACKEDATTR raw_grp_header_t;


typedef struct
{
	char name[12];
	u32_t length;

} PACKEDATTR raw_grp_lump_t;


#endif /* __OBLIGE_LIB_GRP_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
