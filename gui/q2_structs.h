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
#ifndef __QUAKE2_FILES_H__
#define __QUAKE2_FILES_H__


/*
==============================================================================
  .BSP file format
==============================================================================
*/

#define IDBSPHEADER  (('P'<<24)+('S'<<16)+('B'<<8)+'I')

#define BSPVERSION  38


// upper design bounds
// leaffaces, leafbrushes, planes, and verts are still bounded by
// 16 bit short limits
#define MAX_MAP_MODELS     1024
#define MAX_MAP_BRUSHES    8192
#define MAX_MAP_ENTITIES   2048
#define MAX_MAP_TEXINFO    8192

#define MAX_MAP_PLANES        65535
#define MAX_MAP_NODES         65535
#define MAX_MAP_BRUSHSIDES    65535
#define MAX_MAP_LEAFS         65535
#define MAX_MAP_VERTS         65535
#define MAX_MAP_FACES         65535
#define MAX_MAP_LEAFFACES     65535
#define MAX_MAP_LEAFBRUSHES   65535
#define MAX_MAP_PORTALS       65535

#define MAX_MAP_AREAS           256
#define MAX_MAP_AREAPORTALS    1024
#define MAX_MAP_EDGES        128000
#define MAX_MAP_SURFEDGES    256000
#define MAX_MAP_LIGHTING   0x200000
#define MAX_MAP_VISIBILITY 0x100000
#define MAX_MAP_ENTSTRING   0x40000

// key / value pair sizes

#define MAX_KEY    32
#define MAX_VALUE  1024

//=============================================================================

#define LUMP_ENTITIES     0
#define LUMP_PLANES       1
#define LUMP_VERTEXES     2
#define LUMP_VISIBILITY   3
#define LUMP_NODES        4
#define LUMP_TEXINFO      5
#define LUMP_FACES        6
#define LUMP_LIGHTING     7

#define LUMP_LEAFS        8
#define LUMP_LEAFFACES    9
#define LUMP_LEAFBRUSHES  10
#define LUMP_EDGES        11
#define LUMP_SURFEDGES    12
#define LUMP_MODELS       13
#define LUMP_BRUSHES      14
#define LUMP_BRUSHSIDES   15
#define LUMP_POP          16
#define LUMP_AREAS        17
#define LUMP_AREAPORTALS  18

#define HEADER_LUMPS      19

// AJA: moved dheader_t to q_common.h

typedef struct
{
  float mins[3], maxs[3];
  float origin[3];   // for sounds or lights

  s32_t headnode;
  s32_t firstface, numfaces;  // submodels just draw faces
                              // without walking the bsp tree

} PACKEDATTR dmodel2_t;


// planes (x&~1) and (x&~1)+1 are always opposites
// AJA: the pair is also ordered, first plane should have a normal
//      whose greatest axis is positive.

// AJA: moved dplane_t to q_common.h


// contents flags are seperate bits
// a given brush can contribute multiple content bits
// multiple brushes can be in a single leaf

// these definitions also need to be in q_shared.h!

// lower bits are stronger, and will eat weaker brushes completely
#define CONTENTS_SOLID     1   // an eye is never valid in a solid
#define CONTENTS_WINDOW    2   // translucent, but not watery
#define CONTENTS_AUX       4
#define CONTENTS_LAVA      8
#define CONTENTS_SLIME    16
#define CONTENTS_WATER    32
#define CONTENTS_MIST     64

// remaining contents are non-visible, and don't eat brushes
#define LAST_VISIBLE_CONTENTS  64

#define CONTENTS_AREAPORTAL       0x8000
#define CONTENTS_PLAYERCLIP      0x10000
#define CONTENTS_MONSTERCLIP     0x20000

// currents can be added to any other contents, and may be mixed
#define CONTENTS_CURRENT_EAST    0x40000
#define CONTENTS_CURRENT_NORTH   0x80000
#define CONTENTS_CURRENT_WEST   0x100000
#define CONTENTS_CURRENT_SOUTH  0x200000
#define CONTENTS_CURRENT_UP     0x400000
#define CONTENTS_CURRENT_DOWN   0x800000

#define CONTENTS_ORIGIN         0x1000000  // removed before bsping an entity
#define CONTENTS_MONSTER        0x2000000  // should never be on a brush, only in game
#define CONTENTS_DEADMONSTER    0x4000000
#define CONTENTS_DETAIL         0x8000000  // brushes to be added after vis leafs
#define CONTENTS_TRANSLUCENT   0x10000000  // auto set if any surface has trans
#define CONTENTS_LADDER        0x20000000


typedef struct
{
  s32_t planenum;
  s32_t children[2];  // negative numbers are -(leafs+1), not nodes

  s16_t mins[3];    // for frustom culling
  s16_t maxs[3];

  u16_t firstface;
  u16_t numfaces;  // counting both sides

} PACKEDATTR dnode2_t;


#define SURF_LIGHT     0x1   // value will hold the light strength
#define SURF_SLICK     0x2   // effects game physics
#define SURF_SKY       0x4   // don't draw, but add to skybox
#define SURF_WARP      0x8   // turbulent water warp
#define SURF_TRANS33  0x10
#define SURF_TRANS66  0x20
#define SURF_FLOWING  0x40   // scroll towards angle
#define SURF_NODRAW   0x80   // don't bother referencing the texture


typedef struct
{
  float s[4];   // x/y/z/offset
  float t[4];

  u32_t flags;  // miptex flags + overrides
  s32_t value;  // light emission, etc

  char  texture[32];  // texture name (textures/*.wal)
  s32_t anim_next;    // for animations, -1 = end of chain

} PACKEDATTR texinfo2_t;


// AJA: dvertex_t and dedge_t moved to q_common.h

// AJA: dface2_t also moved to q_common.h


typedef struct
{
  u32_t contents;      // OR of all brushes

  s16_t cluster;
  s16_t area;

  s16_t mins[3];      // for frustum culling
  s16_t maxs[3];

  u16_t first_leafface;
  u16_t num_leaffaces;

  u16_t first_leafbrush;
  u16_t num_leafbrushes;

} PACKEDATTR dleaf2_t;


typedef struct
{
  u16_t planenum;    // facing out of the leaf
  s16_t texinfo;

} PACKEDATTR dbrushside_t;

typedef struct
{
  s32_t firstside;
  s32_t numsides;

  u32_t contents;

} PACKEDATTR dbrush_t;


// special yaw angles which orient entities up or down
#define ANGLE_UP    -1
#define ANGLE_DOWN  -2


// the visibility lump consists of a header with a count, then
// byte offsets for the PVS and PHS of each cluster, then the raw
// compressed bit vectors
#define DVIS_PVS  0
#define DVIS_PHS  1

typedef struct
{
  s32_t numclusters;
  s32_t offsets[1][2];   // [NUMCLUSTERS][2]

} PACKEDATTR dvis_t;

// each area has a list of portals that lead into other areas
// when portals are closed, other areas may not be visible or
// hearable even if the vis info says that it could be.
typedef struct
{
  s32_t portal_id;
  s32_t otherarea;

} PACKEDATTR dareaportal_t;

typedef struct
{
  s32_t num_portals;
  s32_t first_portal;

} PACKEDATTR darea_t;

#endif /* __QUAKE2_FILES_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
