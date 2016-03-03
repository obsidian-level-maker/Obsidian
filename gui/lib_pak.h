//------------------------------------------------------------------------
//  ARCHIVE handling - Quake1/2 PAK files
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

#ifndef __OBLIGE_PAK_FILES_H__
#define __OBLIGE_PAK_FILES_H__


/* PAK reading */

bool PAK_OpenRead(const char *filename);
void PAK_CloseRead(void);

int  PAK_NumEntries(void);
int  PAK_FindEntry(const char *name);
void PAK_FindMaps(std::vector<int>& entries);

int  PAK_EntryLen(int entry);
const char * PAK_EntryName(int entry);

bool PAK_ReadData(int entry, int offset, int length, void *buffer);

void PAK_ListEntries(void);


/* PAK writing */

bool PAK_OpenWrite(const char *filename);
void PAK_CloseWrite(void);

void PAK_NewLump(const char *name);
bool PAK_AppendData(const void *data, int length);
void PAK_FinishLump(void);


/* ----- PAK structures ---------------------- */

typedef struct
{
	char magic[4];

	u32_t dir_start;
	u32_t entry_num;

} PACKEDATTR raw_pak_header_t;

#define PAK_MAGIC  "PACK"


typedef struct
{
	char name[56];

	u32_t offset;
	u32_t length;

} PACKEDATTR raw_pak_entry_t;


#endif /* __OBLIGE_PAK_FILES_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
