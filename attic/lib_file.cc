//------------------------------------------------------------------------
//  File Utilities
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

#include "lib_file.h"

#include <algorithm>

#include "lib_util.h"

std::string FileLoad(const std::filesystem::path &filename) {
    std::ifstream in{filename};
    in.seekg(0, std::ios::end);
    std::string text;
    text.resize(in.tellg());
    in.seekg(0);
    in.read(text.data(), text.size());
    text.push_back('\0');
    return text;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
