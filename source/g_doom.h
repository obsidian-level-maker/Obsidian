//------------------------------------------------------------------------
//  LEVEL building - DOOM format
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
//  Copyright (C) 2006-2017 Andrew Apted
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

#ifndef G_DOOM_H_
#define G_DOOM_H_

#include <filesystem>

#include "m_lua.h"

class qLump_c;

/***** VARIABLES ****************/

namespace Doom
{

enum subformat_e
{
    SUBFMT_Hexen  = 1,
    SUBFMT_Strife = 2,
};

extern int sub_format;

/***** FUNCTIONS ****************/

bool StartWAD(std::filesystem::path filename);
bool EndWAD();

void BeginLevel();
void EndLevel(std::string level_name);

void WriteLump(std::string name, qLump_c *lump);

// the section parameter can be:
//   'P' : patches   //   'F' : flats
//   'S' : sprites   //   'C' : colormaps (Boom)
//   'T' : textures (Zdoom)
void AddSectionLump(char section, std::string name, qLump_c *lump);

void HeaderPrintf(const char *str, ...);

void AddVertex(int x, int y);

void AddSector(int f_h, std::string f_tex, int c_h, std::string c_tex,
               int light, int special, int tag);

void AddSidedef(int sector, std::string l_tex, std::string m_tex,
                std::string u_tex, int x_offset, int y_offset);

void AddLinedef(int vert1, int vert2, int side1, int side2, int type, int flags,
                int tag, const uint8_t *args);

void AddThing(int x, int y, int h, int type, int angle, int options, int tid,
              uint8_t special, const uint8_t *args);

// v094 stuff (Duh)
int v094_begin_level(lua_State *L);
int v094_end_level(lua_State *L);
int v094_add_thing(lua_State *L);
int v094_add_vertex(lua_State *L);
int v094_add_sidedef(lua_State *L);
int v094_add_sector(lua_State *L);
int v094_add_linedef(lua_State *L);

int NumVertexes();
int NumSectors();
int NumSidedefs();
int NumLinedefs();
int NumThings();

void Send_Prog_Nodes(int progress, int num_maps);

/* ----- Level structures ---------------------- */

enum lineflag_e
{
    MLF_BlockAll   = 0x0001,
    MLF_TwoSided   = 0x0004,
    MLF_UpperUnpeg = 0x0008,
    MLF_LowerUnpeg = 0x0010,
    MLF_SoundBlock = 0x0040,
    MLF_DontDraw   = 0x0080,
};

enum thingflag_e
{
    MTF_Easy   = 1,
    MTF_Medium = 2,
    MTF_Hard   = 4,
    MTF_Ambush = 8,

    MTF_NotSP   = 16,
    MTF_NotDM   = 32,
    MTF_NotCOOP = 64,

    MTF_Friend   = 128,  // MBF
    MTF_Reserved = 256,  // BOOM
    MTF_Dormant  = 512,  // Eternity
};

constexpr unsigned int MTF_EDGE_EXFLOOR_MASK  = 0x3C00;
constexpr unsigned int MTF_EDGE_EXFLOOR_SHIFT = 10;

#pragma pack(push, 1)
struct raw_behavior_header_t
{
    char marker[4];  // 'ACS' 0

    uint32_t offset;

    uint32_t func_num;
    uint32_t str_num;
};
#pragma pack(pop)

/* ----- Other structures ---------------------- */

#pragma pack(push, 1)
struct raw_patch_header_t
{
    uint16_t width;
    uint16_t height;

    int16_t x_offset;
    int16_t y_offset;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct raw_gl_vertex_t
{
    int32_t x, y;
};
#pragma pack(pop)

constexpr unsigned int IS_GL_VERT = 0x8000;

}  // namespace Doom

#endif  // G_DOOM_H_

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
