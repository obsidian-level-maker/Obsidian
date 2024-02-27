//------------------------------------------------------------------------
//
//  AJ-BSP  Copyright (C) 2007-2023  Andrew Apted
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

/* ----- The wad structures ---------------------- */

// wad header
#pragma pack(push, 1)
struct RawWadHeader
{
    char ident[4];

    uint32_t num_entries;
    uint32_t dir_start;
};
#pragma pack(pop)

// directory entry
#pragma pack(push, 1)
struct RawWadEntry
{
    uint32_t pos;
    uint32_t size;

    char name[8];
};
#pragma pack(pop)

// Lump order in a map WAD: each map needs a couple of lumps
// to provide a complete scene geometry description.
enum LumpOrder
{
    kLumpLabel = 0,   // A separator name, ExMx or MAPxx
    kLumpThings,      // Monsters, items..
    kLumpLinedefs,    // LineDefs, from editing
    kLumpSidedefs,    // SideDefs, from editing
    kLumpVertexes,    // Vertices, edited and BSP splits generated
    kLumpSegs,        // LineSegs, from LineDefs split by BSP
    kLumpSubSectors,  // SubSectors, list of LineSegs
    kLumpNodes,       // BSP nodes
    kLumpSectors,     // Sectors, from editing
    kLumpReject,      // LUT, sector-sector visibility
    kLumpBlockmap,    // LUT, motion clipping, walls/grid element
    kLumpBehavior     // Hexen scripting stuff
};

/* ----- The level structures ---------------------- */
#pragma pack(push, 1)
struct RawVertex
{
    int16_t x, y;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct RawV2Vertex
{
    int32_t x, y;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct RawLinedef
{
    uint16_t start;  // from this vertex...
    uint16_t end;    // ... to this vertex
    uint16_t flags;  // linedef flags (impassible, etc)
    uint16_t type;   // special type (0 for none, 97 for teleporter, etc)
    int16_t  tag;    // this linedef activates the sector with same tag
    uint16_t right;  // right sidedef
    uint16_t left;   // left sidedef (only if this line adjoins 2 sectors)
};
#pragma pack(pop)

#pragma pack(push, 1)
struct RawHexenLinedef
{
    uint16_t start;    // from this vertex...
    uint16_t end;      // ... to this vertex
    uint16_t flags;    // linedef flags (impassible, etc)
    uint8_t  type;     // special type
    uint8_t  args[5];  // special arguments
    uint16_t right;    // right sidedef
    uint16_t left;     // left sidedef
};
#pragma pack(pop)

#pragma pack(push, 1)
struct RawSidedef
{
    int16_t x_offset;  // X offset for texture
    int16_t y_offset;  // Y offset for texture

    char upper_tex[8];  // texture name for the part above
    char lower_tex[8];  // texture name for the part below
    char mid_tex[8];    // texture name for the regular part

    uint16_t sector;  // adjacent sector
};
#pragma pack(pop)

#pragma pack(push, 1)
struct RawSector
{
    int16_t floorh;  // floor height
    int16_t ceilh;   // ceiling height

    char floor_tex[8];  // floor texture
    char ceil_tex[8];   // ceiling texture

    uint16_t light;  // light level (0-255)
    uint16_t type;   // special type (0 = normal, 9 = secret, ...)
    int16_t  tag;    // sector activated by a linedef with same tag
};
#pragma pack(pop)

#pragma pack(push, 1)
struct RawThing
{
    int16_t  x, y;     // position of thing
    int16_t  angle;    // angle thing faces (degrees)
    uint16_t type;     // type of thing
    uint16_t options;  // when appears, deaf, etc..
};
#pragma pack(pop)

#pragma pack(push, 1)
// -JL- Hexen thing definition
struct RawHexenThing
{
    int16_t  tid;      // tag id (for scripts/specials)
    int16_t  x, y;     // position
    int16_t  height;   // start height above floor
    int16_t  angle;    // angle thing faces
    uint16_t type;     // type of thing
    uint16_t options;  // when appears, deaf, dormant, etc..

    uint8_t special;  // special type
    uint8_t args[5];  // special arguments
};
#pragma pack(pop)

/* ----- The BSP tree structures ----------------------- */
#pragma pack(push, 1)
struct RawSeg
{
    uint16_t start;    // from this vertex...
    uint16_t end;      // ... to this vertex
    uint16_t angle;    // angle (0 = east, 16384 = north, ...)
    uint16_t linedef;  // linedef that this seg goes along
    uint16_t flip;     // true if not the same direction as linedef
    uint16_t dist;     // distance from starting point
};
#pragma pack(pop)

#pragma pack(push, 1)
struct RawGLSeg
{
    uint16_t start;    // from this vertex...
    uint16_t end;      // ... to this vertex
    uint16_t linedef;  // linedef that this seg goes along, or -1
    uint16_t side;     // 0 if on right of linedef, 1 if on left
    uint16_t partner;  // partner seg number, or -1
};
#pragma pack(pop)

#pragma pack(push, 1)
struct RawV5Seg
{
    uint32_t start;    // from this vertex...
    uint32_t end;      // ... to this vertex
    uint16_t linedef;  // linedef that this seg goes along, or -1
    uint16_t side;     // 0 if on right of linedef, 1 if on left
    uint32_t partner;  // partner seg number, or -1
};
#pragma pack(pop)

#pragma pack(push, 1)
struct RawZDoomSeg
{
    uint32_t start;    // from this vertex...
    uint32_t end;      // ... to this vertex
    uint16_t linedef;  // linedef that this seg goes along, or -1
    uint8_t  side;     // 0 if on right of linedef, 1 if on left
};
#pragma pack(pop)

#pragma pack(push, 1)
struct RawBoundingBox
{
    int16_t maxy, miny;
    int16_t minx, maxx;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct RawNode
{
    int16_t        x, y;    // starting point
    int16_t        dx, dy;  // offset to ending point
    RawBoundingBox b1, b2;  // bounding rectangles
    uint16_t right, left;   // children: Node or SSector (if high bit is set)
};
#pragma pack(pop)

#pragma pack(push, 1)
struct RawSubsector
{
    uint16_t num;    // number of Segs in this Sub-Sector
    uint16_t first;  // first Seg
};
#pragma pack(pop)

#pragma pack(push, 1)
struct RawV5Subsector
{
    uint32_t num;    // number of Segs in this Sub-Sector
    uint32_t first;  // first Seg
};
#pragma pack(pop)

#pragma pack(push, 1)
struct RawZDoomSubsector
{
    uint32_t segnum;

    // NOTE : no "first" value, segs must be contiguous and appear
    //        in an order dictated by the subsector list, e.g. all
    //        segs of the second subsector must appear directly after
    //        all segs of the first subsector.
};
#pragma pack(pop)

#pragma pack(push, 1)
struct RawV5Node
{
    // this structure used by ZDoom nodes too

    int16_t        x, y;    // starting point
    int16_t        dx, dy;  // offset to ending point
    RawBoundingBox b1, b2;  // bounding rectangles
    uint32_t right, left;   // children: Node or SSector (if high bit is set)
};
#pragma pack(pop)

#pragma pack(push, 1)
struct RawBlockmapHeader
{
    int16_t x_origin, y_origin;
    int16_t x_blocks, y_blocks;
};
#pragma pack(pop)

/* ----- Graphical structures ---------------------- */
#pragma pack(push, 1)
struct RawPatchDefinition
{
    int16_t x_origin;
    int16_t y_origin;

    uint16_t pname;     // index into PNAMES
    uint16_t stepdir;   // NOT USED
    uint16_t colormap;  // NOT USED
};
#pragma pack(pop)

#pragma pack(push, 1)
struct RawStrifePatchDefinition
{
    int16_t  x_origin;
    int16_t  y_origin;
    uint16_t pname;  // index into PNAMES
};
#pragma pack(pop)

// Texture definition.
//
// Each texture is composed of one or more patches,
// with patches being lumps stored in the WAD.
//
#pragma pack(push, 1)
struct RawTexture
{
    char name[8];

    uint32_t masked;  // NOT USED
    uint16_t width;
    uint16_t height;
    uint16_t column_dir[2];  // NOT USED
    uint16_t patch_count;

    RawPatchDefinition patches[1];
};
#pragma pack(pop)

#pragma pack(push, 1)
struct RawStrifeTexture
{
    char name[8];

    uint32_t masked;  // NOT USED
    uint16_t width;
    uint16_t height;
    uint16_t patch_count;

    RawStrifePatchDefinition patches[1];
};
#pragma pack(pop)

// Patches.
//
// A patch holds one or more columns.
// Patches are used for sprites and all masked pictures,
// and we compose textures from the TEXTURE1/2 lists
// of patches.
//
#pragma pack(push, 1)
struct Patch
{
    // bounding box size
    int16_t width;
    int16_t height;

    // pixels to the left of origin
    int16_t leftoffset;

    // pixels below the origin
    int16_t topoffset;

    uint32_t columnofs[1];  // only [width] used
};
#pragma pack(pop)

//
// LineDef attributes.
//

enum LineFlag
{
    // solid, is an obstacle
    kLineFlagBlocking = 0x0001,

    // blocks monsters only
    kLineFlagBlockMonsters = 0x0002,

    // backside will not be present at all if not two sided
    kLineFlagTwoSided = 0x0004,

    // If a texture is pegged, the texture will have
    // the end exposed to air held constant at the
    // top or bottom of the texture (stairs or pulled
    // down things) and will move with a height change
    // of one of the neighbor sectors.
    //
    // Unpegged textures allways have the first row of
    // the texture at the top pixel of the line for both
    // top and bottom textures (use next to windows).

    // upper texture unpegged
    kLineFlagUpperUnpegged = 0x0008,

    // lower texture unpegged
    kLineFlagLowerUnpegged = 0x0010,

    // in AutoMap: don't map as two sided: IT'S A SECRET!
    kLineFlagSecret = 0x0020,

    // sound rendering: don't let sound cross two of these
    kLineFlagSoundBlock = 0x0040,

    // don't draw on the automap at all
    kLineFlagDontDraw = 0x0080,

    // set as if already seen, thus drawn in automap
    kLineFlagMapped = 0x0100,

    // -AJA- this one is from Boom. Allows multiple lines to
    //       be pushed simultaneously.
    kLineFlagBoomPassThrough = 0x0200,
};

enum LineFlagEternity
{
    kLineFlagEternity3DMidTex = 0x0400,
};

enum LineFlagXDoom
{
    // -AJA- these three are from XDoom
    kLineFlagXDoomTranslucent = 0x0400,
    kLineFlagXDoomShootBlock  = 0x0800,
    kLineFlagXDoomSightBlock  = 0x1000,
};

enum LineFlagHexen
{
    // flags 0x001 .. 0x200 are same as DOOM above

    kLineFlagHexenRepeatable = 0x0200,
    kLineFlagHexenActivation = 0x1c00,
};

enum LineFlagZDoom
{
    // these are supported by ZDoom (and derived ports)
    kLineFlagZDoomMonstersCanActivate = 0x2000,
    kLineFlagZDoomBlockPlayers        = 0x4000,
    kLineFlagZDoomBlockEverything     = 0x8000,
};

constexpr int16_t kBoomGeneralizedLineFirst = 0x2f80;
constexpr int16_t kBoomGeneralizedLineLast  = 0x7fff;

inline bool IsBoomGeneralizedLine(int16_t line)
{
    return (line >= kBoomGeneralizedLineFirst &&
            line <= kBoomGeneralizedLineLast);
}

enum HexenActivation
{
    kSpecialActivationCross   = 0,  // when line is crossed (W1 / WR)
    kSpecialActivationUse     = 1,  // when line is used    (S1 / SR)
    kSpecialActivationMonster = 2,  // when monster walks over line
    kSpecialActivationImpact = 3,  // when bullet/projectile hits line (G1 / GR)
    kSpecialActivationPush   = 4,  // when line is bumped (player is stopped)
    kSpecialActivationPCross = 5,  // when projectile crosses the line
};

//
// Sector attributes.
//

enum BoomSectorFlag
{
    kBoomSectorFlagTypeMask   = 0x001F,
    kBoomSectorFlagDamageMask = 0x0060,
    kBoomSectorFlagSecret     = 0x0080,
    kBoomSectorFlagFriction   = 0x0100,
    kBoomSectorFlagWind       = 0x0200,
    kBoomSectorFlagNoSounds   = 0x0400,
    kBoomSectorFlagQuietPlane = 0x0800
};

constexpr int16_t kBoomFlagBits = 0x0FE0;

//
// Thing attributes.
//

enum ThingOption
{
    // these four used in Hexen too
    kThingEasy            = 1,
    kThingMedium          = 2,
    kThingHard            = 4,
    kThingAmbush          = 8,
    kThingNotSinglePlayer = 16,
    kThingNotDeathmatch   = 32,
    kThingNotCooperative  = 64,
    kThingFriend          = 128,
    kThingReserved        = 256,
};

constexpr int16_t kExtraFloorMask     = 0x3C00;
constexpr uint8_t kExtraFloorBitShift = 10;

enum HexenOption
{
    kThingHexenDormant      = 16,
    kThingHexenFighter      = 32,
    kThingHexenCleric       = 64,
    kThingHexenMage         = 128,
    kThingHexenSinglePlayer = 256,
    kThingHexenCooperative  = 512,
    kThingHexenDeathmatch   = 1024,
};

//
// Polyobject stuff
//
constexpr uint8_t kHexenPolyobjectStart    = 1;
constexpr uint8_t kHexenPolyobjectExplicit = 5;

// -JL- Hexen polyobj thing types
constexpr int16_t kPolyobjectAnchorType     = 3000;
constexpr int16_t kPolyobjectSpawnType      = 3001;
constexpr int16_t kPolyobjectSpawnCrushType = 3002;

// -JL- ZDoom polyobj thing types
constexpr int16_t kZDoomPolyobjectAnchorType     = 9300;
constexpr int16_t kZDoomPolyobjectSpawnType      = 9301;
constexpr int16_t kZDoomPolyobjectSpawnCrushType = 9302;

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
