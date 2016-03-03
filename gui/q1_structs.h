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
 

#ifndef __QUAKE1_BSPFILE_H__
#define __QUAKE1_BSPFILE_H__


// upper design bounds

#define MAX_MAP_HULLS   4

#define MAX_MAP_MODELS    256
#define MAX_MAP_BRUSHES   4096
#define MAX_MAP_ENTITIES  1024
#define MAX_MAP_ENTSTRING 65535

#define MAX_MAP_PLANES    32767
#define MAX_MAP_NODES     32767 /* negative shorts are contents */
#define MAX_MAP_CLIPNODES 32767 /* negative shorts are contents */
#define MAX_MAP_LEAFS     8192

#define MAX_MAP_VERTS         65535
#define MAX_MAP_FACES         65535
#define MAX_MAP_MARKSURFACES  65535
#define MAX_MAP_TEXINFO        4096
#define MAX_MAP_TEXTURES        512

#define MAX_MAP_EDGES        256000
#define MAX_MAP_SURFEDGES    512000
#define MAX_MAP_MIPTEX      0x200000
#define MAX_MAP_LIGHTING    0x100000
#define MAX_MAP_VISIBILITY  0x100000

#define MAX_MAP_PORTALS       65535

// key / value pair sizes

#define MAX_KEY   32
#define MAX_VALUE 1024

//=============================================================================

#define BSPVERSION  29

#define LUMP_ENTITIES       0
#define LUMP_PLANES         1
#define LUMP_TEXTURES       2
#define LUMP_VERTEXES       3
#define LUMP_VISIBILITY     4
#define LUMP_NODES          5
#define LUMP_TEXINFO        6
#define LUMP_FACES          7

#define LUMP_LIGHTING       8
#define LUMP_CLIPNODES      9
#define LUMP_LEAFS         10
#define LUMP_MARKSURFACES  11
#define LUMP_EDGES         12
#define LUMP_SURFEDGES     13
#define LUMP_MODELS        14

#define HEADER_LUMPS  15

// AJA: moved lump_t and dheader_t to q_common.h

typedef struct
{
  float mins[3], maxs[3];
  float origin[3];

  s32_t headnode[MAX_MAP_HULLS];
  s32_t numleafs;   // not including the solid leaf 0
  s32_t firstface, numfaces;

} PACKEDATTR dmodel_t;

typedef struct
{
  s32_t num_miptex;
  s32_t data_ofs[2];   // [nummiptex]

} PACKEDATTR dmiptexlump_t;

#define MIP_LEVELS 4
typedef struct miptex_s
{
  char name[16];
  u32_t width, height;
  u32_t offsets[MIP_LEVELS]; // four mip maps stored

} PACKEDATTR miptex_t;


// AJA: moved dplane_t to q_common.h


#define CONTENTS_EMPTY  -1
#define CONTENTS_SOLID  -2
#define CONTENTS_WATER  -3
#define CONTENTS_SLIME  -4
#define CONTENTS_LAVA   -5
#define CONTENTS_SKY    -6
#define CONTENTS_ORIGIN -7  /* removed at csg time       */
#define CONTENTS_CLIP   -8  /* changed to contents_solid */

#define CONTENTS_CURRENT_0      -9
#define CONTENTS_CURRENT_90    -10
#define CONTENTS_CURRENT_180   -11
#define CONTENTS_CURRENT_270   -12
#define CONTENTS_CURRENT_UP    -13
#define CONTENTS_CURRENT_DOWN  -14


typedef struct
{
  s32_t planenum;
  s16_t children[2];  // negative numbers are -(leafs+1), not nodes

  s16_t mins[3];    // for sphere culling
  s16_t maxs[3];

  u16_t firstface;
  u16_t numfaces; // counting both sides

} PACKEDATTR dnode_t;

/*
 * Note that children are interpreted as unsigned values now, so that we can
 * handle > 32k clipnodes. Values > 0xFFF0 can be assumed to be CONTENTS
 * values and can be read as the signed value to be compatible with the above
 * (i.e. simply subtract 65536).
 */
typedef struct dclipnode_s
{
  s32_t planenum;
  u16_t children[2];

} PACKEDATTR dclipnode_t;

#define CLIP_SPECIAL  0xFFF0


typedef struct
{
  float s[4];   // x/y/z/offset
  float t[4];

  s32_t miptex;
  s32_t flags;

} PACKEDATTR texinfo_t;

// sky or slime: no lightmap, no 256 subdivision
// -AJA- only disables a check on extents, otherwise not used by quake engine
#define TEX_SPECIAL  1


// AJA: dvertex_t and dedge_t moved into q_common.h

// AJA: dface_t also moved into q_common.h


#define NUM_AMBIENTS   4 // automatic ambient sounds

// leaf 0 is the generic CONTENTS_SOLID leaf, used for all solid areas
// all other leafs need visibility info
typedef struct
{
  s32_t contents;
  s32_t visofs;     // -1 = no visibility info

  s16_t mins[3];    // for frustum culling
  s16_t maxs[3];

  u16_t first_marksurf;
  u16_t num_marksurf;

  u8_t ambient_level[NUM_AMBIENTS];

} PACKEDATTR dleaf_t;

#endif /* __QUAKE1_BSPFILE_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
