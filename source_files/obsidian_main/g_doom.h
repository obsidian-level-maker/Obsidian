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
//  as published by the Free Software Foundation; either version 2
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
#include <array>
#include "sys_type.h"
#include "m_lua.h"

class qLump_c;

/***** VARIABLES ****************/

namespace Doom {

enum subformat_e {
    SUBFMT_Hexen = 1,
    SUBFMT_Strife = 2,
};

extern int sub_format;

/***** FUNCTIONS ****************/

bool StartWAD(std::filesystem::path filename);
bool EndWAD();

void BeginLevel();
void EndLevel(std::string_view level_name);

void WriteLump(std::string_view name, qLump_c *lump);

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
                int tag, const byte *args);

void AddThing(int x, int y, int h, int type, int angle, int options, int tid,
              byte special, const byte *args);

// v094 stuff (Duh)
int v094_begin_level(lua_State *L);
int v094_end_level(lua_State *L);
int v094_add_thing(lua_State*L);
int v094_add_vertex(lua_State*L);
int v094_add_sidedef(lua_State*L);
int v094_add_sector(lua_State*L);
int v094_add_linedef(lua_State*L);

int NumVertexes();
int NumSectors();
int NumSidedefs();
int NumLinedefs();
int NumThings();

void Send_Prog_Nodes(int progress, int num_maps);
void Send_Prog_Step(const char *step_name);

/* ----- Level structures ---------------------- */

#pragma pack(push, 1)
struct raw_vertex_t {
    s16_t x, y;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct raw_linedef_t {
    u16_t start;     // from this vertex...
    u16_t end;       // ... to this vertex
    u16_t flags;     // linedef flags (impassible, etc)
    u16_t type;      // linedef type (0 for none, 97 for teleporter, etc)
    u16_t tag;       // this linedef activates the sector with same tag
    u16_t sidedef1;  // right sidedef
    u16_t sidedef2;  // left sidedef (only if this line adjoins 2 sectors)
};
#pragma pack(pop)

enum lineflag_e {
    MLF_BlockAll = 0x0001,
    MLF_TwoSided = 0x0004,
    MLF_UpperUnpeg = 0x0008,
    MLF_LowerUnpeg = 0x0010,
    MLF_SoundBlock = 0x0040,
    MLF_DontDraw = 0x0080,
};

#pragma pack(push, 1)
struct raw_hexen_linedef_t {
    u16_t start;               // from this vertex...
    u16_t end;                 // ... to this vertex
    u16_t flags;               // linedef flags (impassible, etc)
    u8_t special;              // special type
    std::array<u8_t, 5> args;  // special arguments
    u16_t sidedef1;            // right sidedef
    u16_t sidedef2;            // left sidedef
};
#pragma pack(pop)

#pragma pack(push, 1)
struct raw_sidedef_t {
    s16_t x_offset;  // X offset for texture
    s16_t y_offset;  // Y offset for texture

    std::array<char, 8> upper_tex;  // texture name for the part above
    std::array<char, 8> lower_tex;  // texture name for the part below
    std::array<char, 8> mid_tex;    // texture name for the regular part

    u16_t sector;  // adjacent sector
};
#pragma pack(pop)

#pragma pack(push, 1)
struct raw_sector_t {
    s16_t floor_h;  // floor height
    s16_t ceil_h;   // ceiling height

    std::array<char, 8> floor_tex;  // floor texture
    std::array<char, 8> ceil_tex;   // ceiling texture

    u16_t light;    // light level (0-255)
    u16_t special;  // special behaviour (0 = normal, 9 = secret, ...)
    s16_t tag;      // sector activated by a linedef with same tag
};
#pragma pack(pop)

#pragma pack(push, 1)
struct raw_thing_t {
    s16_t x, y;     // position of thing
    s16_t angle;    // angle thing faces (degrees)
    u16_t type;     // type of thing
    u16_t options;  // when appears, deaf, etc..
};
#pragma pack(pop)

enum thingflag_e {
    MTF_Easy = 1,
    MTF_Medium = 2,
    MTF_Hard = 4,
    MTF_Ambush = 8,

    MTF_NotSP = 16,
    MTF_NotDM = 32,
    MTF_NotCOOP = 64,

    MTF_Friend = 128,    // MBF
    MTF_Reserved = 256,  // BOOM
    MTF_Dormant = 512,   // Eternity
};

constexpr unsigned int MTF_EDGE_EXFLOOR_MASK = 0x3C00;
constexpr unsigned int MTF_EDGE_EXFLOOR_SHIFT = 10;

#pragma pack(push, 1)
struct raw_hexen_thing_t {
    s16_t tid;      // thing tag id (for scripts/specials)
    s16_t x, y;     // position
    s16_t height;   // start height above floor
    s16_t angle;    // angle thing faces
    u16_t type;     // type of thing
    u16_t options;  // when appears, deaf, dormant, etc..

    u8_t special;              // special type
    std::array<u8_t, 5> args;  // special arguments
};
#pragma pack(pop)

#pragma pack(push, 1)
struct raw_behavior_header_t {
    std::array<char, 4> marker;  // 'ACS' 0

    u32_t offset;

    u32_t func_num;
    u32_t str_num;
};
#pragma pack(pop)

/* ----- Other structures ---------------------- */

#pragma pack(push, 1)
struct raw_patch_header_t {
    u16_t width;
    u16_t height;

    s16_t x_offset;
    s16_t y_offset;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct raw_gl_vertex_t {
    s32_t x, y;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct raw_gl_seg_t {
    u16_t start;    // from this vertex...
    u16_t end;      // ... to this vertex
    u16_t linedef;  // linedef that this seg goes along, or -1
    u16_t side;     // 0 if on right of linedef, 1 if on left
    u16_t partner;  // partner seg number, or -1
};
#pragma pack(pop)

constexpr unsigned int IS_GL_VERT = 0x8000;

#pragma pack(push, 1)
struct raw_subsec_t {
    u16_t num;    // number of Segs in this Sub-Sector
    u16_t first;  // first Seg
};
#pragma pack(pop)

}  // namespace Doom

#endif  // G_DOOM_H_

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
