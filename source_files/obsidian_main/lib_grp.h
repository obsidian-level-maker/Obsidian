//------------------------------------------------------------------------
//  ARCHIVE Handling - GRP files
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

#ifndef LIB_GRP_H_
#define LIB_GRP_H_

/* GRP reading */

#include <array>
#include <filesystem>
#include <string>
#include "sys_type.h"

bool GRP_OpenRead(const char *filename);
void GRP_CloseRead(void);

int GRP_NumEntries(void);
int GRP_FindEntry(const char *name);
int GRP_EntryLen(int entry);
const char *GRP_EntryName(int entry);

bool GRP_ReadData(int entry, int offset, int length, void *buffer);

/* GRP writing */

bool GRP_OpenWrite(const std::filesystem::path &filename);
void GRP_CloseWrite(void);

void GRP_NewLump(std::string name);
bool GRP_AppendData(const void *data, int length);
void GRP_FinishLump(void);

/* ----- GRP structure ---------------------- */

constexpr unsigned int GRP_MAGIC_LEN = 12;
constexpr unsigned int GRP_NAME_LEN = 12;

#pragma pack(push, 1)
struct raw_grp_header_t {
    char magic[GRP_MAGIC_LEN];
    u32_t num_lumps;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct raw_grp_lump_t {
    std::array<char, GRP_NAME_LEN> name;
    u32_t length;
};
#pragma pack(pop)

#endif

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
