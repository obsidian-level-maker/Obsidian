//------------------------------------------------------------------------
//  File Utilities
//------------------------------------------------------------------------
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
//  Copyright (c) 2008-2017  Andrew J Apted
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
#include "u_type.h"
#include <filesystem>
#include <string>
#ifndef __LIB_FILE_H__
#define __LIB_FILE_H__

#ifdef WIN32
#define DIR_SEP_CH '\\'
#define DIR_SEP_STR "\\"
#else
#define DIR_SEP_CH '/'
#define DIR_SEP_STR "/"
#endif

// filename functions
bool HasExtension(std::filesystem::path filename);
bool CheckExtension(std::filesystem::path, std::string ext);
std::filesystem::path ReplaceExtension(std::filesystem::path filename, std::string ext);
std::filesystem::path FindBaseName(std::filesystem::path filename);

// file utilities
bool FileExists(std::filesystem::path filename);
bool FileCopy(std::filesystem::path src_name, std::filesystem::path dest_name);
bool FileRename(std::filesystem::path old_name, std::filesystem::path new_name);
bool FileDelete(std::filesystem::path filename);
bool FileChangeDir(std::filesystem::path dir_name);
bool FileMakeDir(std::filesystem::path dir_name);

u8_t *FileLoad(std::filesystem::path filename, int *length);
void FileFree(u8_t *mem);

// directory functions
bool PathIsDirectory(std::filesystem::path path);

#endif /* __LIB_FILE_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
