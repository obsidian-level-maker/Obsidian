/*
Copyright (C) 1997-2001 Id Software, Inc.

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
// qfiles.h: quake file formats
// This file must be identical in the quake and utils directories
//

//
// Modified by Andrew Apted for OBLIGE Level Maker,
//
#ifndef Q2_STRUCTS_H_
#define Q2_STRUCTS_H_

/*
==============================================================================
  .BSP file format
==============================================================================
*/

#include "sys_type.h"

constexpr unsigned int IDBSPHEADER =
    'I' + ('B' << 8) + ('S' << 16) + ('P' << 24);

constexpr int BSPVERSION = 38;

// upper design bounds
// leaffaces, leafbrushes, planes, and verts are still bounded by
// 16 bit short limits
constexpr int MAX_MAP_MODELS = 1024;
constexpr int MAX_MAP_BRUSHES = 8192;
constexpr int MAX_MAP_ENTITIES = 2048;
constexpr int MAX_MAP_TEXINFO = 8192;

constexpr int MAX_MAP_PLANES = 65535;
constexpr int MAX_MAP_NODES = 65535;
constexpr int MAX_MAP_BRUSHSIDES = 65535;
constexpr int MAX_MAP_LEAFS = 65535;
constexpr int MAX_MAP_VERTS = 65535;
constexpr int MAX_MAP_FACES = 65535;
constexpr int MAX_MAP_LEAFFACES = 65535;
constexpr int MAX_MAP_LEAFBRUSHES = 65535;
constexpr int MAX_MAP_PORTALS = 65535;

constexpr int MAX_MAP_AREAS = 256;
constexpr int MAX_MAP_AREAPORTALS = 1024;
constexpr int MAX_MAP_EDGES = 128000;
constexpr int MAX_MAP_SURFEDGES = 256000;
constexpr int MAX_MAP_LIGHTING = 0x200000;
constexpr int MAX_MAP_VISIBILITY = 0x100000;
constexpr int MAX_MAP_ENTSTRING = 0x40000;

// key / value pair sizes

constexpr int MAX_KEY = 32;
constexpr int MAX_VALUE = 1024;

//=============================================================================

enum {
    LUMP_ENTITIES,
    LUMP_PLANES,
    LUMP_VERTEXES,
    LUMP_VISIBILITY,
    LUMP_NODES,
    LUMP_TEXINFO,
    LUMP_FACES,
    LUMP_LIGHTING,

    LUMP_LEAFS,
    LUMP_LEAFFACES,
    LUMP_LEAFBRUSHES,
    LUMP_EDGES,
    LUMP_SURFEDGES,
    LUMP_MODELS,
    LUMP_BRUSHES,
    LUMP_BRUSHSIDES,
    LUMP_POP,
    LUMP_AREAS,
    LUMP_AREAPORTALS,

    HEADER_LUMPS,
};

// AJA: moved dheader_t to q_common.h

#pragma pack(push, 1)
struct dmodel2_t {
    float mins[3], maxs[3];
    float origin[3];  // for sounds or lights

    s32_t headnode;
    s32_t firstface, numfaces;  // submodels just draw faces
                                // without walking the bsp tree
};
#pragma pack(pop)

// planes (x&~1) and (x&~1)+1 are always opposites
// AJA: the pair is also ordered, first plane should have a normal
//      whose greatest axis is positive.

// AJA: moved dplane_t to q_common.h

// contents flags are seperate bits
// a given brush can contribute multiple content bits
// multiple brushes can be in a single leaf

// these definitions also need to be in q_shared.h!

// lower bits are stronger, and will eat weaker brushes completely
constexpr unsigned int CONTENTS_SOLID = 1;   // an eye is never valid in a solid
constexpr unsigned int CONTENTS_WINDOW = 2;  // translucent, but not watery
constexpr unsigned int CONTENTS_AUX = 4;
constexpr unsigned int CONTENTS_LAVA = 8;
constexpr unsigned int CONTENTS_SLIME = 16;
constexpr unsigned int CONTENTS_WATER = 32;
constexpr unsigned int CONTENTS_MIST = 64;

// remaining contents are non-visible, and don't eat brushes
constexpr unsigned int LAST_VISIBLE_CONTENTS = 64;

constexpr unsigned int CONTENTS_AREAPORTAL = 0x8000;
constexpr unsigned int CONTENTS_PLAYERCLIP = 0x10000;
constexpr unsigned int CONTENTS_MONSTERCLIP = 0x20000;

// currents can be added to any other contents, and may be mixed
constexpr unsigned int CONTENTS_CURRENT_EAST = 0x40000;
constexpr unsigned int CONTENTS_CURRENT_NORTH = 0x80000;
constexpr unsigned int CONTENTS_CURRENT_WEST = 0x100000;
constexpr unsigned int CONTENTS_CURRENT_SOUTH = 0x200000;
constexpr unsigned int CONTENTS_CURRENT_UP = 0x400000;
constexpr unsigned int CONTENTS_CURRENT_DOWN = 0x800000;

// removed before bsping an entity
constexpr unsigned int CONTENTS_ORIGIN = 0x1000000;
// should never be on a brush, only in game
constexpr unsigned int CONTENTS_MONSTER = 0x2000000;
constexpr unsigned int CONTENTS_DEADMONSTER = 0x4000000;
// brushes to be added after vis leafs
constexpr unsigned int CONTENTS_DETAIL = 0x8000000;
// auto set if any surface has trans
constexpr unsigned int CONTENTS_TRANSLUCENT = 0x10000000;
constexpr unsigned int CONTENTS_LADDER = 0x20000000;

#pragma pack(push, 1)
struct dnode2_t {
    s32_t planenum;
    s32_t children[2];  // negative numbers are -(leafs+1), not nodes

    s16_t mins[3];  // for frustom culling
    s16_t maxs[3];

    u16_t firstface;
    u16_t numfaces;  // counting both sides
};
#pragma pack(pop)

// value will hold the light strength
constexpr unsigned int SURF_LIGHT = 0x1;
// effects game physics
constexpr unsigned int SURF_SLICK = 0x2;
// don't draw, but add to skybox
constexpr unsigned int SURF_SKY = 0x4;
// turbulent water warp
constexpr unsigned int SURF_WARP = 0x8;
constexpr unsigned int SURF_TRANS33 = 0x10;
constexpr unsigned int SURF_TRANS66 = 0x20;
// scroll towards angle
constexpr unsigned int SURF_FLOWING = 0x40;
// don't bother referencing the texture
constexpr unsigned int SURF_NODRAW = 0x80;

#pragma pack(push, 1)
struct texinfo2_t {
    float s[4];  // x/y/z/offset
    float t[4];

    u32_t flags;  // miptex flags + overrides
    s32_t value;  // light emission, etc

    char texture[32];  // texture name (textures/*.wal)
    s32_t anim_next;   // for animations, -1 = end of chain
};
#pragma pack(pop)

// AJA: dvertex_t and dedge_t moved to q_common.h

// AJA: dface2_t also moved to q_common.h

#pragma pack(push, 1)
struct dleaf2_t {
    u32_t contents;  // OR of all brushes

    s16_t cluster;
    s16_t area;

    s16_t mins[3];  // for frustum culling
    s16_t maxs[3];

    u16_t first_leafface;
    u16_t num_leaffaces;

    u16_t first_leafbrush;
    u16_t num_leafbrushes;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct dbrushside_t {
    u16_t planenum;  // facing out of the leaf
    s16_t texinfo;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct dbrush_t {
    s32_t firstside;
    s32_t numsides;

    u32_t contents;
};
#pragma pack(pop)

// special yaw angles which orient entities up or down
constexpr int ANGLE_UP = -1;
constexpr int ANGLE_DOWN = -2;

// the visibility lump consists of a header with a count, then
// byte offsets for the PVS and PHS of each cluster, then the raw
// compressed bit vectors
constexpr int DVIS_PVS = 0;
constexpr int DVIS_PHS = 1;

#pragma pack(push, 1)
struct dvis_t {
    s32_t numclusters;
    s32_t offsets[1][2];  // [NUMCLUSTERS][2]
};
#pragma pack(pop)

// each area has a list of portals that lead into other areas
// when portals are closed, other areas may not be visible or
// hearable even if the vis info says that it could be.
#pragma pack(push, 1)
struct dareaportal_t {
    s32_t portal_id;
    s32_t otherarea;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct darea_t {
    s32_t num_portals;
    s32_t first_portal;
};
#pragma pack(pop)

#endif

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
