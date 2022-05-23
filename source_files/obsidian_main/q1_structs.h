/*
Copyright (C) 1996-1997 Id Software, Inc.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

*/

//
// Modified by Andrew Apted for OBLIGE Level Maker,
//

#ifndef Q1_STRUCTS_H_
#define Q1_STRUCTS_H_

// upper design bounds

#include "sys_type.h"

constexpr int MAX_MAP_HULLS = 4;

constexpr int MAX_MAP_MODELS = 256;
constexpr int MAX_MAP_BRUSHED = 4096;
constexpr int MAX_MAP_ENTITIES = 1024;
constexpr int MAX_MAP_ENTSTRING = 65535;

constexpr int MAX_MAP_PLANES = 65536;
/* negative shorts are contents */
constexpr int MAX_MAP_NODES = 65530;
/* negative shorts are contents */
constexpr int MAX_MAP_CLIPNODES = 65530;
constexpr int MAX_MAP_LEAFS = 32768;

constexpr int MAX_MAP_VERTS = 65535;
constexpr int MAX_MAP_FACES = 65535;
constexpr int MAX_MAP_MARKSURFACES = 65535;
constexpr int MAX_MAP_TEXINFO = 65536;
constexpr int MAX_MAP_TEXTURES = 512;

constexpr int MAX_MAP_EDGES = 256000;
constexpr int MAX_MAP_SURFEDGES = 512000;
constexpr int MAX_MAP_MIPTEX = 0x200000;
constexpr int MAX_MAP_LIGHTING = 0x100000;
constexpr int MAX_MAP_VISIBILITY = 0x100000;

constexpr int MAX_MAP_PORTALS = 65535;

// key / value pair sizes

constexpr int MAX_KEY = 32;
constexpr int MAX_VALUE = 1024;

//=============================================================================

constexpr int BSPVERSION = 29;

enum {
    LUMP_ENTITIES,
    LUMP_PLANES,
    LUMP_TEXTURES,
    LUMP_VERTEXES,
    LUMP_VISIBILITY,
    LUMP_NODES,
    LUMP_TEXINFO,
    LUMP_FACES,
    LUMP_LIGHTING,
    LUMP_CLIPNODES,
    LUMP_LEAFS,
    LUMP_MARKSURFACES,
    LUMP_EDGES,
    LUMP_SURFEDGES,
    LUMP_MODELS,
    HEADER_LUMPS,
};

// AJA: moved lump_t and dheader_t to q_common.h

#pragma pack(push, 1)
struct dmodel_t {
    float mins[3], maxs[3];
    float origin[3];

    s32_t headnode[MAX_MAP_HULLS];
    s32_t numleafs;  // not including the solid leaf 0
    s32_t firstface, numfaces;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct dmiptexlump_t {
    s32_t num_miptex;
    s32_t data_ofs[2];  // [nummiptex]
};
#pragma pack(pop)

constexpr int MIP_LEVELS = 4;
#pragma pack(push, 1)
struct miptex_t {
    char name[16];
    u32_t width, height;
    u32_t offsets[MIP_LEVELS];  // four mip maps stored
};
#pragma pack(pop)

// AJA: moved dplane_t to q_common.h

enum {

    CONTENTS_CURRENT_DOWN = -14,
    CONTENTS_CURRENT_UP,
    CONTENTS_CURRENT_270,
    CONTENTS_CURRENT_180,
    CONTENTS_CURRENT_90,
    CONTENTS_CURRENT_0,
    /* changed to contents_solid */
    CONTENTS_CLIP,
    /* removed at csg time       */
    CONTENTS_ORIGIN,
    CONTENTS_SKY,
    CONTENTS_LAVA,
    CONTENTS_SLIME,
    CONTENTS_WATER,
    CONTENTS_SOLID,
    CONTENTS_EMPTY,
};

#pragma pack(push, 1)
struct dnode_t {
    s32_t planenum;
    s16_t children[2];  // negative numbers are -(leafs+1), not nodes

    s16_t mins[3];  // for sphere culling
    s16_t maxs[3];

    u16_t firstface;
    u16_t numfaces;  // counting both sides
};
#pragma pack(pop)

/*
 * Note that children are interpreted as unsigned values now, so that we can
 * handle > 32k clipnodes. Values > 0xFFF0 can be assumed to be CONTENTS
 * values and can be read as the signed value to be compatible with the above
 * (i.e. simply subtract 65536).
 */
struct dclipnode_t {
    s32_t planenum;
    u16_t children[2];
};

constexpr unsigned int CLIP_SPECIAL = 0xFFF0;

#pragma pack(push, 1)
struct texinfo_t {
    float s[4];  // x/y/z/offset
    float t[4];

    s32_t miptex;
    s32_t flags;
};
#pragma pack(pop)

// sky or slime: no lightmap, no 256 subdivision
// -AJA- only disables a check on extents, otherwise not used by quake engine
constexpr int TEX_SPECIAL = 1;

// AJA: dvertex_t and dedge_t moved into q_common.h

// AJA: dface_t also moved into q_common.h

// automatic ambient sounds
constexpr int NUM_AMBIENTS = 4;

// leaf 0 is the generic CONTENTS_SOLID leaf, used for all solid areas
// all other leafs need visibility info
#pragma pack(push, 1)
struct dleaf_t {
    s32_t contents;
    s32_t visofs;  // -1 = no visibility info

    s16_t mins[3];  // for frustum culling
    s16_t maxs[3];

    u16_t first_marksurf;
    u16_t num_marksurf;

    u8_t ambient_level[NUM_AMBIENTS];
};
#pragma pack(pop)

#endif

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
