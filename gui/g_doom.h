//------------------------------------------------------------------------
//  LEVEL building - DOOM format
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2009 Andrew Apted
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

#ifndef __OBLIGE_DOOM_OUT_H__
#define __OBLIGE_DOOM_OUT_H__

class qLump_c;


/***** VARIABLES ****************/

typedef enum
{
	SUBFMT_Hexen  = 1,
	SUBFMT_Strife = 2,
}
doom_subformat_e;

extern int dm_sub_format;


/***** FUNCTIONS ****************/

bool DM_StartWAD(const char *filename);
bool DM_EndWAD();

void DM_BeginLevel();
void DM_EndLevel(const char *level_name);

void DM_WriteLump(const char *name, qLump_c *lump);

// the section parameter can be:
//   'P' : patches   //   'F' : flats
//   'S' : sprites   //   'C' : colormaps (Boom)
//   'T' : textures (Zdoom)
void DM_AddSectionLump(char section, const char *name, qLump_c *lump);


void DM_HeaderPrintf(const char *str, ...);


void DM_AddVertex(int x, int y);

void DM_AddSector(int f_h, const char * f_tex, 
                  int c_h, const char * c_tex,
                  int light, int special, int tag);

void DM_AddSidedef(int sector, const char *l_tex,
                   const char *m_tex, const char *u_tex,
                   int x_offset, int y_offset);

void DM_AddLinedef(int vert1, int vert2, int side1, int side2,
                   int type,  int flags, int tag,
                   const byte *args);

void DM_AddThing(int x, int y, int h, int type, int angle, int options,
                 int tid, byte special, const byte *args);

int DM_NumVertexes();
int DM_NumSectors();
int DM_NumSidedefs();
int DM_NumLinedefs();
int DM_NumThings();


/* ----- Level structures ---------------------- */

typedef struct
{
	s16_t x, y;

} PACKEDATTR raw_vertex_t;


typedef struct
{
	u16_t start;     // from this vertex...
	u16_t end;       // ... to this vertex
	u16_t flags;     // linedef flags (impassible, etc)
	u16_t type;      // linedef type (0 for none, 97 for teleporter, etc)
	s16_t tag;       // this linedef activates the sector with same tag
	u16_t sidedef1;  // right sidedef
	u16_t sidedef2;  // left sidedef (only if this line adjoins 2 sectors)

} PACKEDATTR raw_linedef_t;

typedef enum
{
	MLF_BlockAll    = 0x0001,
	MLF_TwoSided    = 0x0004,
	MLF_UpperUnpeg  = 0x0008,
	MLF_LowerUnpeg  = 0x0010,
	MLF_DontDraw    = 0x0080,
}
doom_lineflag_e;


typedef struct
{
	u16_t start;        // from this vertex...
	u16_t end;          // ... to this vertex
	u16_t flags;        // linedef flags (impassible, etc)
	u8_t  special;      // special type
	u8_t  args[5];      // special arguments
	u16_t sidedef1;     // right sidedef
	u16_t sidedef2;     // left sidedef

} PACKEDATTR raw_hexen_linedef_t;


typedef struct
{
	s16_t x_offset;  // X offset for texture
	s16_t y_offset;  // Y offset for texture

	char upper_tex[8];  // texture name for the part above
	char lower_tex[8];  // texture name for the part below
	char mid_tex[8];    // texture name for the regular part

	u16_t sector;    // adjacent sector

} PACKEDATTR raw_sidedef_t;


typedef struct
{
	s16_t floor_h;   // floor height
	s16_t ceil_h;    // ceiling height

	char floor_tex[8];  // floor texture
	char ceil_tex[8];   // ceiling texture

	u16_t light;     // light level (0-255)
	u16_t special;   // special behaviour (0 = normal, 9 = secret, ...)
	s16_t tag;       // sector activated by a linedef with same tag

} PACKEDATTR raw_sector_t;


typedef struct
{
	s16_t x, y;      // position of thing
	s16_t angle;     // angle thing faces (degrees)
	u16_t type;      // type of thing
	u16_t options;   // when appears, deaf, etc..

} PACKEDATTR raw_thing_t;

typedef enum
{
	MTF_Easy    = 1,
	MTF_Medium  = 2,
	MTF_Hard    = 4,
	MTF_Ambush  = 8,

	MTF_NotSP   = 16,
	MTF_NotDM   = 32,
	MTF_NotCOOP = 64,

	MTF_Friend   = 128,  // MBF
	MTF_Reserved = 256,  // BOOM
	MTF_Dormant  = 512,  // Eternity
}
doom_thingflag_e;

#define MTF_EDGE_EXFLOOR_MASK    0x3C00
#define MTF_EDGE_EXFLOOR_SHIFT   10


typedef struct
{
	s16_t tid;       // thing tag id (for scripts/specials)
	s16_t x, y;      // position
	s16_t height;    // start height above floor
	s16_t angle;     // angle thing faces
	u16_t type;      // type of thing
	u16_t options;   // when appears, deaf, dormant, etc..

	u8_t special;    // special type
	u8_t args[5];    // special arguments

}  PACKEDATTR raw_hexen_thing_t;


typedef struct
{
	char marker[4];  // 'ACS' 0

	u32_t offset;

	u32_t func_num;
	u32_t str_num;

} PACKEDATTR raw_behavior_header_t;


/* ----- Other structures ---------------------- */

typedef struct
{
	u16_t width;
	u16_t height;

	s16_t x_offset;
	s16_t y_offset;

} PACKEDATTR raw_patch_header_t;


typedef struct raw_gl_vertex_s
{
	s32_t x, y;

} PACKEDATTR raw_gl_vertex_t;


typedef struct raw_gl_seg_s
{
	u16_t start;      // from this vertex...
	u16_t end;        // ... to this vertex
	u16_t linedef;    // linedef that this seg goes along, or -1
	u16_t side;       // 0 if on right of linedef, 1 if on left
	u16_t partner;    // partner seg number, or -1

} PACKEDATTR raw_gl_seg_t;

#define IS_GL_VERT  0x8000


typedef struct raw_subsec_s
{
	u16_t num;     // number of Segs in this Sub-Sector
	u16_t first;   // first Seg

} PACKEDATTR raw_subsec_t;

#endif /* __OBLIGE_DOOM_OUT_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
