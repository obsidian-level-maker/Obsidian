//------------------------------------------------------------------------
//  ARCHIVE Handling - WAD files
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
//  Copyright (C) 2006-2017 Andrew Apted
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

#ifndef LIB_WAD_H_
#define LIB_WAD_H_

/* WAD reading */

#include <string_view>

bool WAD_OpenRead(std::string filename);
void WAD_CloseRead();

int WAD_NumEntries();
int WAD_FindEntry(const char *name);
int WAD_EntryLen(int entry);
const char *WAD_EntryName(int entry);

bool WAD_ReadData(int entry, int offset, int length, void *buffer);

/* WAD writing */

bool WAD_OpenWrite(std::string filename);
void WAD_CloseWrite();

void WAD_NewLump(std::string name);
bool WAD_AppendData(const void *data, int length);
void WAD_FinishLump();

/* ----- WAD structure (Doom) ---------------------- */

#pragma pack(push, 1)
struct raw_wad_header_t {
    char magic[4];

    uint32_t num_lumps;
    uint32_t dir_start;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct raw_wad_lump_t {
    uint32_t start;
    uint32_t length;

    char name[8];
};
#pragma pack(pop)

#endif

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
