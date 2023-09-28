/*
===========================================================================
Copyright (C) 1999-2005 Id Software, Inc.

This file is part of Quake III Arena source code.

Quake III Arena source code is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of the License,
or (at your option) any later version.

Quake III Arena source code is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Quake III Arena source code; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
===========================================================================
*/

//
// qfiles.h: quake file formats
// This file must be identical in the quake and utils directories
//

//
// Modified by Andrew Apted for OBLIGE Level Maker,
//
#ifndef Q3_STRUCTS_H_
#define Q3_STRUCTS_H_

/*
==============================================================================
  .BSP file format
==============================================================================
*/

#include <array>

// little-endian "IBSP"
#include "sys_type.h"

constexpr unsigned int IDBSPHEADER =
    'I' + ('B' << 8) + ('S' << 16) + ('P' << 24);

constexpr int BSP_VERSION = 46;

// upper design bounds
// leaffaces, leafbrushes, planes, and verts are still bounded by
// 16 bit short limits
constexpr unsigned int MAX_MAP_MODELS = 0x400;
constexpr unsigned int MAX_MAP_BRUSHES = 0x8000;
constexpr unsigned int MAX_MAP_ENTITIES = 0x800;
constexpr unsigned int MAX_MAP_ENTSTRING = 0x40000;
constexpr unsigned int MAX_MAP_SHADERS = 0x400;

// MAX_MAP_AREA_BYTES in q_shared must match!
constexpr unsigned int MAX_MAP_AREAS = 0x100;
constexpr unsigned int MAX_MAP_FOGS = 0x100;
constexpr unsigned int MAX_MAP_PLANES = 0x20000;
constexpr unsigned int MAX_MAP_NODES = 0x20000;
constexpr unsigned int MAX_MAP_BRUSHSIDES = 0x20000;
constexpr unsigned int MAX_MAP_LEAFS = 0x20000;
constexpr unsigned int MAX_MAP_LEAFFACES = 0x20000;
constexpr unsigned int MAX_MAP_LEAFBRUSHES = 0x40000;
constexpr unsigned int MAX_MAP_PORTALS = 0x20000;
constexpr unsigned int MAX_MAP_LIGHTING = 0x800000;
constexpr unsigned int MAX_MAP_LIGHTGRID = 0x800000;
constexpr unsigned int MAX_MAP_VISIBILITY = 0x200000;

constexpr unsigned int MAX_MAP_DRAW_SURFS = 0x20000;
constexpr unsigned int MAX_MAP_DRAW_VERTS = 0x80000;
constexpr unsigned int MAX_MAP_DRAW_INDEXES = 0x80000;

constexpr unsigned int LIGHTMAP_WIDTH = 128;
constexpr unsigned int LIGHTMAP_HEIGHT = 128;

// key / value pair sizes

constexpr unsigned int MAX_KEY = 32;
constexpr unsigned int MAX_VALUE = 1024;

//=============================================================================

enum {
    LUMP_ENTITIES,
    LUMP_SHADERS,
    LUMP_PLANES,
    LUMP_NODES,
    LUMP_LEAFS,
    LUMP_LEAFSURFACES,
    LUMP_LEAFBRUSHES,
    LUMP_MODELS,
    LUMP_BRUSHES,
    LUMP_BRUSHSIDES,
    LUMP_DRAWVERTS,
    LUMP_DRAWINDEXES,
    LUMP_FOGS,
    LUMP_SURFACES,
    LUMP_LIGHTMAPS,
    LUMP_LIGHTGRID,
    LUMP_VISIBILITY,
};

/* AJA: dheader3_t moved to q_common.h */

#pragma pack(push, 1)
struct dmodel3_t {
    float mins[3], maxs[3];

    s32_t firstSurface, numSurfaces;
    s32_t firstBrush, numBrushes;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct dshader3_t {
    std::array<char, 64> shader;

    u32_t surfaceFlags;
    u32_t contentFlags;
};
#pragma pack(pop)

/* AJA: dplane3_t moved to q_common.h */

#pragma pack(push, 1)
struct dnode3_t {
    s32_t planeNum;
    s32_t children[2];  // negative numbers are -(leafs+1), not nodes

    s32_t mins[3];  // for frustom culling
    s32_t maxs[3];
};
#pragma pack(pop)

#pragma pack(push, 1)
struct dleaf3_t {
    s32_t cluster;  // -1 = opaque cluster (do I still store these?)
    s32_t area;

    s32_t mins[3];  // for frustum culling
    s32_t maxs[3];

    s32_t firstLeafSurface;
    s32_t numLeafSurfaces;

    s32_t firstLeafBrush;
    s32_t numLeafBrushes;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct dbrushside3_t {
    s32_t planeNum;  // positive plane side faces out of the leaf
    s32_t shaderNum;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct dbrush3_t {
    s32_t firstSide;
    s32_t numSides;

    s32_t shaderNum;  // the shader that determines the contents flags
};
#pragma pack(pop)

#pragma pack(push, 1)
struct dfog3_t {
    char shader[64];

    s32_t brushNum;
    s32_t visibleSide;  // the brush side that ray tests need to clip against
                        // (-1 == none)
};
#pragma pack(pop)

/* AJA : moved dlightgrid3_t to q_light.h */

#pragma pack(push, 1)
struct ddrawvert3_t {
    float xyz[3];
    float st[2];
    float lightmap[2];
    float normal[3];
    byte color[4];
};
#pragma pack(pop)

enum q3_mapsurfacetype_e {
    MST_BAD,
    MST_PLANAR,
    MST_PATCH,
    MST_TRIANGLE_SOUP,
    MST_FLARE,
};

#pragma pack(push, 1)
struct dsurface3_t {
    s32_t shaderNum;
    s32_t fogNum;
    s32_t surfaceType;

    s32_t firstVert;
    s32_t numVerts;

    s32_t firstIndex;
    s32_t numIndexes;

    s32_t lightmapNum;
    s32_t lightmapX, lightmapY;
    s32_t lightmapWidth, lightmapHeight;

    float lightmapOrigin[3];
    float lightmapVecs[3][3];  // for patches, [0] and [1] are lodbounds

    s32_t patchWidth;
    s32_t patchHeight;
};
#pragma pack(pop)

//=============================================================================

// contents flags are seperate bits
// a given brush can contribute multiple content bits

// these definitions also need to be in q_shared.h!

// an eye is never valid in a solid
constexpr unsigned int CONTENTS_SOLID = 1;
constexpr unsigned int CONTENTS_LAVA = 8;
constexpr unsigned int CONTENTS_SLIME = 16;
constexpr unsigned int CONTENTS_WATER = 32;
constexpr unsigned int CONTENTS_FOG = 64;

constexpr unsigned int CONTENTS_NOTTEAM1 = 0x0080;
constexpr unsigned int CONTENTS_NOTTEAM2 = 0x0100;
constexpr unsigned int CONTENTS_NOBOTCLIP = 0x0200;

constexpr unsigned int CONTENTS_AREAPORTAL = 0x8000;

constexpr unsigned int CONTENTS_PLAYERCLIP = 0x10000;
constexpr unsigned int CONTENTS_MONSTERCLIP = 0x20000;
// bot specific contents types
constexpr unsigned int CONTENTS_TELEPORTER = 0x40000;
constexpr unsigned int CONTENTS_JUMPPAD = 0x80000;
constexpr unsigned int CONTENTS_CLUSTERPORTAL = 0x100000;
constexpr unsigned int CONTENTS_DONOTENTER = 0x200000;
constexpr unsigned int CONTENTS_BOTCLIP = 0x400000;
constexpr unsigned int CONTENTS_MOVER = 0x800000;

// removed before bsping an entity
constexpr unsigned int CONTENTS_ORIGIN = 0x1000000;

// should never be on a brush, only in game
constexpr unsigned int CONTENTS_BODY = 0x2000000;
constexpr unsigned int CONTENTS_CORPSE = 0x4000000;
// brushes not used for the bsp
constexpr unsigned int CONTENTS_DETAIL = 0x8000000;
// brushes used for the bsp
constexpr unsigned int CONTENTS_STRUCTURAL = 0x10000000;
// don't consume surface fragments inside
constexpr unsigned int CONTENTS_TRANSLUCENT = 0x20000000;
constexpr unsigned int CONTENTS_TRIGGER = 0x40000000;
// don't leave bodies or items (death fog, lava)
constexpr unsigned int CONTENTS_NODROP = 0x80000000;

// never give falling damage
constexpr unsigned int SURF_NODAMAGE = 0x1;
// affects game physics
constexpr unsigned int SURF_SLICK = 0x2;
// lighting from environment map
constexpr unsigned int SURF_SKY = 0x4;
constexpr unsigned int SURF_LADDER = 0x8;
// don't make missile explosions
constexpr unsigned int SURF_NOIMPACT = 0x10;
// don't leave missile marks
constexpr unsigned int SURF_NOMARKS = 0x20;
// make flesh sounds and effects
constexpr unsigned int SURF_FLESH = 0x40;
// don't generate a drawsurface at all
constexpr unsigned int SURF_NODRAW = 0x80;
// make a primary bsp splitter
constexpr unsigned int SURF_HINT = 0x100;
// completely ignore, allowing non-closed brushes
constexpr unsigned int SURF_SKIP = 0x200;
// surface doesn't need a lightmap
constexpr unsigned int SURF_NOLIGHTMAP = 0x400;
// generate lighting info at vertexes
constexpr unsigned int SURF_POINTLIGHT = 0x800;
// clanking footsteps
constexpr unsigned int SURF_METALSTEPS = 0x1000;
// no footstep sounds
constexpr unsigned int SURF_NOSTEPS = 0x2000;
// don't collide against curves with this set
constexpr unsigned int SURF_NONSOLID = 0x4000;
// act as a light filter during q3map -light
constexpr unsigned int SURF_LIGHTFILTER = 0x8000;
// do per-pixel light shadow casting in q3map
constexpr unsigned int SURF_ALPHASHADOW = 0x10000;
// don't dlight even if solid (solid lava, skies)
constexpr unsigned int SURF_NODLIGHT = 0x20000;
// leave a dust trail when walking on this surface
constexpr unsigned int SURF_DUST = 0x40000;

// special lightmap numbers
constexpr int LIGHTMAP_BY_VERTEX = -3;
constexpr int LIGHTMAP_WHITEIMAGE = -2;
constexpr int LIGHTMAP_NONE = -1;

#endif

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
