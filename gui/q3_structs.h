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
#ifndef __QUAKE3_FILES_H__
#define __QUAKE3_FILES_H__


/*
==============================================================================
  .BSP file format
==============================================================================
*/

// little-endian "IBSP"
#define IDBSPHEADER  (('P'<<24)+('S'<<16)+('B'<<8)+'I')

#define BSP_VERSION		46


// upper design bounds
// leaffaces, leafbrushes, planes, and verts are still bounded by
// 16 bit short limits
#define MAX_MAP_MODELS		0x400
#define MAX_MAP_BRUSHES		0x8000
#define MAX_MAP_ENTITIES	0x800
#define MAX_MAP_ENTSTRING	0x40000
#define MAX_MAP_SHADERS		0x400

#define MAX_MAP_AREAS		0x100	// MAX_MAP_AREA_BYTES in q_shared must match!
#define MAX_MAP_FOGS		0x100
#define MAX_MAP_PLANES		0x20000
#define MAX_MAP_NODES		0x20000
#define MAX_MAP_BRUSHSIDES	0x20000
#define MAX_MAP_LEAFS		0x20000
#define MAX_MAP_LEAFFACES	0x20000
#define MAX_MAP_LEAFBRUSHES	0x40000
#define MAX_MAP_PORTALS		0x20000
#define MAX_MAP_LIGHTING	0x800000
#define MAX_MAP_LIGHTGRID	0x800000
#define MAX_MAP_VISIBILITY	0x200000

#define MAX_MAP_DRAW_SURFS	0x20000
#define MAX_MAP_DRAW_VERTS	0x80000
#define MAX_MAP_DRAW_INDEXES	0x80000

#define LIGHTMAP_WIDTH		128
#define LIGHTMAP_HEIGHT		128

// key / value pair sizes

#define MAX_KEY    32
#define MAX_VALUE  1024

//=============================================================================

#define LUMP_ENTITIES		0
#define LUMP_SHADERS		1
#define LUMP_PLANES			2
#define LUMP_NODES			3
#define LUMP_LEAFS			4
#define LUMP_LEAFSURFACES	5
#define LUMP_LEAFBRUSHES	6
#define LUMP_MODELS			7
#define LUMP_BRUSHES		8
#define LUMP_BRUSHSIDES		9
#define LUMP_DRAWVERTS		10
#define LUMP_DRAWINDEXES	11
#define LUMP_FOGS			12
#define LUMP_SURFACES		13
#define LUMP_LIGHTMAPS		14
#define LUMP_LIGHTGRID		15
#define LUMP_VISIBILITY		16


/* AJA: dheader3_t moved to q_common.h */


typedef struct
{
	float		mins[3], maxs[3];

	s32_t		firstSurface, numSurfaces;
	s32_t		firstBrush, numBrushes;

} PACKEDATTR dmodel3_t;


typedef struct
{
	char		shader[64];

	u32_t		surfaceFlags;
	u32_t		contentFlags;

} PACKEDATTR dshader3_t;


/* AJA: dplane3_t moved to q_common.h */


typedef struct
{
	s32_t		planeNum;
	s32_t		children[2];	// negative numbers are -(leafs+1), not nodes

	s32_t		mins[3];		// for frustom culling
	s32_t		maxs[3];

} PACKEDATTR dnode3_t;


typedef struct
{
	s32_t		cluster;			// -1 = opaque cluster (do I still store these?)
	s32_t		area;

	s32_t		mins[3];			// for frustum culling
	s32_t		maxs[3];

	s32_t		firstLeafSurface;
	s32_t		numLeafSurfaces;

	s32_t		firstLeafBrush;
	s32_t		numLeafBrushes;

} PACKEDATTR dleaf3_t;


typedef struct
{
	s32_t		planeNum;			// positive plane side faces out of the leaf
	s32_t		shaderNum;

} PACKEDATTR dbrushside3_t;


typedef struct
{
	s32_t		firstSide;
	s32_t		numSides;

	s32_t		shaderNum;		// the shader that determines the contents flags

} PACKEDATTR dbrush3_t;


typedef struct
{
	char		shader[64];

	s32_t		brushNum;
	s32_t		visibleSide;	// the brush side that ray tests need to clip against (-1 == none)

} PACKEDATTR dfog3_t;


/* AJA : moved dlightgrid3_t to q_light.h */


typedef struct
{
	float		xyz[3];
	float		st[2];
	float		lightmap[2];
	float		normal[3];
	byte		color[4];

} PACKEDATTR ddrawvert3_t;


typedef enum
{
	MST_BAD,
	MST_PLANAR,
	MST_PATCH,
	MST_TRIANGLE_SOUP,
	MST_FLARE

} q3_mapsurfacetype_e;


typedef struct
{
	s32_t		shaderNum;
	s32_t		fogNum;
	s32_t		surfaceType;

	s32_t		firstVert;
	s32_t		numVerts;

	s32_t		firstIndex;
	s32_t		numIndexes;

	s32_t		lightmapNum;
	s32_t		lightmapX, lightmapY;
	s32_t		lightmapWidth, lightmapHeight;

	float		lightmapOrigin[3];
	float		lightmapVecs[3][3];	// for patches, [0] and [1] are lodbounds

	s32_t		patchWidth;
	s32_t		patchHeight;

} PACKEDATTR dsurface3_t;


//=============================================================================

// contents flags are seperate bits
// a given brush can contribute multiple content bits

// these definitions also need to be in q_shared.h!

#define CONTENTS_SOLID			1		// an eye is never valid in a solid
#define CONTENTS_LAVA			8
#define CONTENTS_SLIME			16
#define CONTENTS_WATER			32
#define CONTENTS_FOG			64

#define CONTENTS_NOTTEAM1		0x0080
#define CONTENTS_NOTTEAM2		0x0100
#define CONTENTS_NOBOTCLIP		0x0200

#define CONTENTS_AREAPORTAL		0x8000

#define CONTENTS_PLAYERCLIP		0x10000
#define CONTENTS_MONSTERCLIP	0x20000
//bot specific contents types
#define CONTENTS_TELEPORTER		0x40000
#define CONTENTS_JUMPPAD		0x80000
#define CONTENTS_CLUSTERPORTAL	0x100000
#define CONTENTS_DONOTENTER		0x200000
#define CONTENTS_BOTCLIP		0x400000
#define CONTENTS_MOVER			0x800000

#define CONTENTS_ORIGIN			0x1000000	// removed before bsping an entity

#define CONTENTS_BODY			0x2000000	// should never be on a brush, only in game
#define CONTENTS_CORPSE			0x4000000
#define CONTENTS_DETAIL			0x8000000	// brushes not used for the bsp
#define CONTENTS_STRUCTURAL		0x10000000	// brushes used for the bsp
#define CONTENTS_TRANSLUCENT	0x20000000	// don't consume surface fragments inside
#define CONTENTS_TRIGGER		0x40000000
#define CONTENTS_NODROP			0x80000000	// don't leave bodies or items (death fog, lava)


#define SURF_NODAMAGE			0x1		// never give falling damage
#define SURF_SLICK				0x2		// effects game physics
#define SURF_SKY				0x4		// lighting from environment map
#define SURF_LADDER				0x8
#define SURF_NOIMPACT			0x10	// don't make missile explosions
#define SURF_NOMARKS			0x20	// don't leave missile marks
#define SURF_FLESH				0x40	// make flesh sounds and effects
#define SURF_NODRAW				0x80	// don't generate a drawsurface at all
#define SURF_HINT				0x100	// make a primary bsp splitter
#define SURF_SKIP				0x200	// completely ignore, allowing non-closed brushes
#define SURF_NOLIGHTMAP			0x400	// surface doesn't need a lightmap
#define SURF_POINTLIGHT			0x800	// generate lighting info at vertexes
#define SURF_METALSTEPS			0x1000	// clanking footsteps
#define SURF_NOSTEPS			0x2000	// no footstep sounds
#define SURF_NONSOLID			0x4000	// don't collide against curves with this set
#define SURF_LIGHTFILTER		0x8000	// act as a light filter during q3map -light
#define SURF_ALPHASHADOW		0x10000	// do per-pixel light shadow casting in q3map
#define SURF_NODLIGHT			0x20000	// don't dlight even if solid (solid lava, skies)
#define SURF_DUST				0x40000	// leave a dust trail when walking on this surface


// special lightmap numbers
#define LIGHTMAP_BY_VERTEX  -3
#define LIGHTMAP_WHITEIMAGE -2
#define LIGHTMAP_NONE       -1


#endif /* __QUAKE3_FILES_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
