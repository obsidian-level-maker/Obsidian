//------------------------------------------------------------------------
//
//  AJ-BSP  Copyright (C) 2000-2018  Andrew Apted, et al
//          Copyright (C) 1994-1998  Colin Reed
//          Copyright (C) 1997-1998  Lee Killough
//
//  Originally based on the program 'BSP', version 2.3.
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

#pragma once

#include <string>

#define AJBSP_VERSION "1.05"

//
// Node Build Information Structure
//

#define SPLIT_COST_MIN     1
#define SPLIT_COST_DEFAULT 11
#define SPLIT_COST_MAX     32

class buildinfo_t
{
  public:
    // use a faster method to pick nodes
    bool fast;

    // create GL Nodes?
    bool gl_nodes;

    // when these two are false, they create an empty lump
    bool do_blockmap;
    bool do_reject;

    bool force_v5;
    bool force_xnod;
    bool force_compress;

    // the GUI can set this to tell the node builder to stop
    bool cancelled;

    int split_cost;

  public:
    buildinfo_t()
        : fast(false),

          gl_nodes(true),

          do_blockmap(true), do_reject(true),

          force_v5(false), force_xnod(false), force_compress(false),

          cancelled(false),

          split_cost(SPLIT_COST_DEFAULT)
    {
    }

    ~buildinfo_t()
    {
    }
};

typedef enum
{
    // everything went peachy keen
    BUILD_OK = 0,

    // building was cancelled
    BUILD_Cancelled,

    // when saving the map, one or more lumps overflowed
    BUILD_LumpOverflow
} build_result_e;

int AJBSP_BuildNodes(const std::string &filename, buildinfo_t *build_info);

namespace ajbsp
{

// set the build information.  must be done before anything else.
void SetInfo(buildinfo_t *info);

// attempt to open a wad.  on failure, the FatalError method in the
// buildinfo_t interface is called.
void OpenWad(const std::string &filename);

// close a previously opened wad.
void CloseWad();

// create/finish an XWA file
void CreateXWA(const char *filename);
void FinishXWA();

// give the number of levels detected in the wad.
int LevelsInWad();

// retrieve the name of a particular level.
const char *GetLevelName(int lev_idx);

// build the nodes of a particular level.  if cancelled, returns the
// BUILD_Cancelled result and the wad is unchanged.  otherwise the wad
// is updated to store the new lumps and returns either BUILD_OK or
// BUILD_LumpOverflow if some limits were exceeded.
build_result_e BuildLevel(int lev_idx);

} // namespace ajbsp

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
