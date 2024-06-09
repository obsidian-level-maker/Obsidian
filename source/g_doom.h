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

#include "m_lua.h"

class qLump_c
{
  public:
    std::string name;

  private:
    std::vector<uint8_t> buffer;

    // when true Printf() converts '\n' to CR/LF pair
    bool crlf;

  public:
    qLump_c();
    ~qLump_c();

    void Append(const void *data, uint32_t len);
    void Append(qLump_c *other);

    void Prepend(const void *data, uint32_t len);

    void AddByte(uint8_t value);

    void Printf(const char *str, ...);
    void KeyPair(const char *key, const char *val, ...);
    void SetCRLF(bool enable);

    int            GetSize() const;
    const uint8_t *GetBuffer() const;

  private:
    void RawPrintf(const char *str);
};

qLump_c *BSP_CreateInfoLump();

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

bool StartWAD(std::string filename);
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

void AddSector(int f_h, std::string f_tex, int c_h, std::string c_tex, int light, int special, int tag);

void AddSidedef(int sector, std::string l_tex, std::string m_tex, std::string u_tex, int x_offset, int y_offset);

void AddLinedef(int vert1, int vert2, int side1, int side2, int type, int flags, int tag, const uint8_t *args);

void AddThing(int x, int y, int h, int type, int angle, int options, int tid, uint8_t special, const uint8_t *args);

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

#pragma pack(push, 1)
struct raw_vertex_t
{
    int16_t x, y;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct raw_linedef_t
{
    uint16_t start;    // from this vertex...
    uint16_t end;      // ... to this vertex
    uint16_t flags;    // linedef flags (impassible, etc)
    uint16_t type;     // linedef type (0 for none, 97 for teleporter, etc)
    uint16_t tag;      // this linedef activates the sector with same tag
    uint16_t sidedef1; // right sidedef
    uint16_t sidedef2; // left sidedef (only if this line adjoins 2 sectors)
};
#pragma pack(pop)

enum lineflag_e
{
    MLF_BlockAll   = 0x0001,
    MLF_TwoSided   = 0x0004,
    MLF_UpperUnpeg = 0x0008,
    MLF_LowerUnpeg = 0x0010,
    MLF_SoundBlock = 0x0040,
    MLF_DontDraw   = 0x0080,
};

#pragma pack(push, 1)
struct raw_hexen_linedef_t
{
    uint16_t start;    // from this vertex...
    uint16_t end;      // ... to this vertex
    uint16_t flags;    // linedef flags (impassible, etc)
    uint8_t  special;  // special type
    uint8_t  args[5];  // special arguments
    uint16_t sidedef1; // right sidedef
    uint16_t sidedef2; // left sidedef
};
#pragma pack(pop)

#pragma pack(push, 1)
struct raw_sidedef_t
{
    int16_t x_offset;  // X offset for texture
    int16_t y_offset;  // Y offset for texture

    char upper_tex[8]; // texture name for the part above
    char lower_tex[8]; // texture name for the part below
    char mid_tex[8];   // texture name for the regular part

    uint16_t sector;   // adjacent sector
};
#pragma pack(pop)

#pragma pack(push, 1)
struct raw_sector_t
{
    int16_t floor_h;   // floor height
    int16_t ceil_h;    // ceiling height

    char floor_tex[8]; // floor texture
    char ceil_tex[8];  // ceiling texture

    uint16_t light;    // light level (0-255)
    uint16_t special;  // special behaviour (0 = normal, 9 = secret, ...)
    int16_t  tag;      // sector activated by a linedef with same tag
};
#pragma pack(pop)

#pragma pack(push, 1)
struct raw_thing_t
{
    int16_t  x, y;    // position of thing
    int16_t  angle;   // angle thing faces (degrees)
    uint16_t type;    // type of thing
    uint16_t options; // when appears, deaf, etc..
};
#pragma pack(pop)

enum thingflag_e
{
    MTF_Easy   = 1,
    MTF_Medium = 2,
    MTF_Hard   = 4,
    MTF_Ambush = 8,

    MTF_NotSP   = 16,
    MTF_NotDM   = 32,
    MTF_NotCOOP = 64,

    MTF_Friend   = 128, // MBF
    MTF_Reserved = 256, // BOOM
    MTF_Dormant  = 512, // Eternity
};

constexpr unsigned int MTF_EDGE_EXFLOOR_MASK  = 0x3C00;
constexpr unsigned int MTF_EDGE_EXFLOOR_SHIFT = 10;

#pragma pack(push, 1)
struct raw_hexen_thing_t
{
    int16_t  tid;     // thing tag id (for scripts/specials)
    int16_t  x, y;    // position
    int16_t  height;  // start height above floor
    int16_t  angle;   // angle thing faces
    uint16_t type;    // type of thing
    uint16_t options; // when appears, deaf, dormant, etc..

    uint8_t special;  // special type
    uint8_t args[5];  // special arguments
};
#pragma pack(pop)

#pragma pack(push, 1)
struct raw_behavior_header_t
{
    char marker[4]; // 'ACS' 0

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

#pragma pack(push, 1)
struct raw_gl_seg_t
{
    uint16_t start;   // from this vertex...
    uint16_t end;     // ... to this vertex
    uint16_t linedef; // linedef that this seg goes along, or -1
    uint16_t side;    // 0 if on right of linedef, 1 if on left
    uint16_t partner; // partner seg number, or -1
};
#pragma pack(pop)

constexpr unsigned int IS_GL_VERT = 0x8000;

#pragma pack(push, 1)
struct raw_subsec_t
{
    uint16_t num;   // number of Segs in this Sub-Sector
    uint16_t first; // first Seg
};
#pragma pack(pop)

} // namespace Doom

#endif // G_DOOM_H_

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
