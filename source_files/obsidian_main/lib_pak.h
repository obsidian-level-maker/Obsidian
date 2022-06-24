//------------------------------------------------------------------------
//  ARCHIVE handling - Quake1/2 PAK files
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

#ifndef PAK_FILES_H_
#define PAK_FILES_H_

#include <array>
#include <filesystem>
#include <vector>

#include "sys_type.h"

/* PAK reading */

bool PAK_OpenRead(const char *filename);
void PAK_CloseRead(void);

int PAK_NumEntries(void);
int PAK_FindEntry(const char *name);
void PAK_FindMaps(std::vector<int> &entries);

int PAK_EntryLen(int entry);
const char *PAK_EntryName(int entry);

bool PAK_ReadData(int entry, int offset, int length, void *buffer);

void PAK_ListEntries(void);

/* PAK writing */

bool PAK_OpenWrite(const std::filesystem::path &filename);
void PAK_CloseWrite(void);

void PAK_NewLump(const char *name);
bool PAK_AppendData(const void *data, int length);
void PAK_FinishLump(void);

/* ----- PAK structures ---------------------- */

#pragma pack(push, 1)
struct raw_pak_header_t {
    std::array<char, 4> magic;

    u32_t dir_start;
    u32_t entry_num;
};
#pragma pack(pop)

constexpr const char *PAK_MAGIC = "PACK";

#pragma pack(push, 1)
struct raw_pak_entry_t {
    std::array<char, 56> name;

    u32_t offset;
    u32_t length;
};
#pragma pack(pop)

#endif

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
