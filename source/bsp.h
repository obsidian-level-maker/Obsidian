//------------------------------------------------------------------------
//
//  AJ-BSP  Copyright (C) 2000-2023  Andrew Apted, et al
//          Copyright (C) 1994-1998  Colin Reed
//          Copyright (C) 1997-1998  Lee Killough
//
//  Originally based on the program 'BSP', version 2.3.
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 3
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#pragma once

#include <stdint.h>

#include <filesystem>
#include <string>

//
// Node Build Information Structure
//

namespace ajbsp
{

constexpr uint8_t kSplitCostDefault = 11;

struct BuildInfo
{
    int  split_cost;
    bool compress_nodes;
    bool build_gl_nodes;
    bool force_v5_nodes;
    bool force_xnod_format;
    bool do_blockmap;
    bool do_reject;
    // from here on, various bits of internal state
    int total_warnings;
    int total_minor_issues;
};

enum BuildResult
{
    // everything went peachy keen
    kBuildOK = 0,

    // some aspect of the level structure exceeds limits
    // (exact overflow will be printed during the build process)
    kBuildOverflow,

    // not used at the moment, I think we just throw ErrorPrintf if needed -
    // Dasho
    kBuildError
};

// set the build information.  must be done before anything else.
void SetInfo(const BuildInfo &info);

// attempt to open a wad.  on failure, the ErrorPrintf method in the
// BuildInfo interface is called.
void OpenWad(std::filesystem::path filename);

// close a previously opened wad.
void CloseWad();

// give the number of levels detected in the wad.
int LevelsInWad();

// build the nodes of a particular level.  if cancelled, returns the
// BUILD_Cancelled result and the wad is unchanged.  otherwise the wad
// is updated to store the new lumps and returns either kBuildOK or
// kBuildError
BuildResult BuildLevel(int level_index);

} // namespace ajbsp

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
