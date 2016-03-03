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

///--- #include <stdint.h>

///--- #include "qtypes.h"

// upper design bounds

#define MAX_MAP_HULLS   4

#define MAX_MAP_MODELS    256
#define MAX_MAP_BRUSHES   4096
#define MAX_MAP_ENTITIES  1024
#define MAX_MAP_ENTSTRING 65536

#define MAX_MAP_PLANES    8192
#define MAX_MAP_NODES     32767 /* negative shorts are contents */
#define MAX_MAP_CLIPNODES 32767 /* negative shorts are contents */
#define MAX_MAP_LEAFS     32767 /* negative shorts are contents */

#define MAX_MAP_VERTS         65535
#define MAX_MAP_FACES         65535
#define MAX_MAP_MARKSURFACES  65535
#define MAX_MAP_TEXINFO        4096
#define MAX_MAP_TEXTURES        512

#define MAX_MAP_EDGES        256000
#define MAX_MAP_SURFEDGES    512000
#define MAX_MAP_MIPTEX     0x200000
#define MAX_MAP_LIGHTING   0x100000
#define MAX_MAP_VISIBILITY 0x100000

#define MAX_MAP_PORTALS       65535

// key / value pair sizes

#define MAX_KEY   32
#define MAX_VALUE 1024

//=============================================================================

#define BSPVERSION  29

typedef struct
{
  s32_t start;
  s32_t length;
}
lump_t;

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

typedef struct
{
  float mins[3], maxs[3];
  float origin[3];

  s32_t headnode[MAX_MAP_HULLS];
  s32_t visleafs;   // not including the solid leaf 0
  s32_t firstface, numfaces;
}
dmodel_t;

typedef struct
{
  s32_t version;
  lump_t lumps[HEADER_LUMPS];
}
dheader_t;

typedef struct
{
  s32_t num_miptex;
  s32_t data_ofs[2];   // [nummiptex]
}
dmiptexlump_t;

#define MIP_LEVELS 4
typedef struct miptex_s
{
  char name[16];
  u32_t width, height;
  u32_t offsets[MIP_LEVELS]; // four mip maps stored
}
miptex_t;

typedef struct
{
  float x, y, z;
}
dvertex_t;


// 0-2 are axial planes
#define PLANE_X   0
#define PLANE_Y   1
#define PLANE_Z   2

// 3-5 are non-axial planes snapped to the nearest
#define PLANE_ANYX  3
#define PLANE_ANYY  4
#define PLANE_ANYZ  5

typedef struct
{
  float normal[3];
  float dist;
  s32_t type; // PLANE_X - PLANE_ANYZ 
}
dplane_t;


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
}
dnode_t;

/*
 * Note that children are interpreted as unsigned values now, so that we can
 * handle > 32k clipnodes. Values > 0xFFF0 can be assumed to be CONTENTS
 * values and can be read as the signed value to be compatible with the above
 * (i.e. simply subtract 65536).
 *
 * I should probably change the type here to u16_t eventaully and fix up
 * the rest of the code.
 */
typedef struct dclipnode_s
{
  s32_t planenum;
  u16_t children[2];
}
dclipnode_t;

#define CLIP_SPECIAL  0xFFF0


typedef struct texinfo_s
{
  float s[4];   // x/y/z/offset
  float t[4];

  s32_t miptex;
  s32_t flags;
}
texinfo_t;

// sky or slime: no lightmap, no 256 subdivision
// -AJA- only disables a check on extents, otherwise not used by quake engine
#define TEX_SPECIAL  1

// note that edge 0 is never used, because negative edge nums are used for
// counterclockwise use of the edge in a face
typedef struct
{
  u16_t v[2]; // vertex numbers
}
dedge_t;

#define MAXLIGHTMAPS  4

typedef struct
{
  s16_t planenum;
  s16_t side;

  s32_t firstedge;    // we must support > 64k edges
  s16_t numedges;
  s16_t texinfo;

  // lighting info
  u8_t  styles[MAXLIGHTMAPS];
  s32_t lightofs;   // start of [numstyles*surfsize] samples
}
dface_t;


#define AMBIENT_WATER  0
#define AMBIENT_SKY    1
#define AMBIENT_SLIME  2
#define AMBIENT_LAVA   3

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
}
dleaf_t;

#endif /* __QUAKE1_BSPFILE_H__ */
