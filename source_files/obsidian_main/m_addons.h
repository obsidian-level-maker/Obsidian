//------------------------------------------------------------------------
//  Addons Loading and Selection GUI
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2016 Andrew Apted
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

#ifndef __OBLIGE_ADDONS_H__
#define __OBLIGE_ADDONS_H__

#include <cstdio>
#include <string>
#include <fstream>
#include <filesystem>
#include <map>
#include <vector>

#include "sys_type.h"

void VFS_InitAddons(const char *argv0);
void VFS_ParseCommandLine();
void VFS_ScanForAddons();

void VFS_OptParse(std::string name);
void VFS_OptWrite(std::ofstream &fp);

// util functions
bool VFS_CopyFile(const char *src_name, const char *dest_name);
byte *VFS_LoadFile(const char *filename, int *length);
void VFS_FreeFile(const byte *mem);

typedef struct {
    std::filesystem::path name;  // base filename, includes ".pk3" extension

    bool enabled;

} addon_info_t;

extern std::vector<addon_info_t> all_addons;

extern std::map<std::filesystem::path, int> initial_enabled_addons;

#endif /* __OBLIGE_ADDONS_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
