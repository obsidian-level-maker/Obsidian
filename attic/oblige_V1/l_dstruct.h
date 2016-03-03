//------------------------------------------------------------------------
//  STRUCT : Doom structures, raw on-disk layout
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2005 Andrew Apted
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

#ifndef __OBLIGE_STRUCTS_H__
#define __OBLIGE_STRUCTS_H__


/* ----- The wad structures ---------------------- */

// wad header

typedef struct raw_wad_header_s
{
	char type[4];

	uint32_g num_entries;
	uint32_g dir_start;
}
raw_wad_header_t;


// directory entry

typedef struct raw_wad_entry_s
{
	uint32_g start;
	uint32_g length;

	char name[8];
}
raw_wad_entry_t;


// blockmap

typedef struct raw_blockmap_header_s
{
	sint16_g x_origin, y_origin;
	sint16_g x_blocks, y_blocks;
}
raw_blockmap_header_t;


/* ----- The level structures ---------------------- */

typedef struct raw_vertex_s
{
	sint16_g x, y;
}
raw_vertex_t;

typedef struct raw_v2_vertex_s
{
	sint32_g x, y;
}
raw_v2_vertex_t;


typedef struct raw_linedef_s
{
	uint16_g start;     // from this vertex...
	uint16_g end;       // ... to this vertex
	uint16_g flags;     // linedef flags (impassible, etc)
	uint16_g type;      // linedef type (0 for none, 97 for teleporter, etc)
	sint16_g tag;       // this linedef activates the sector with same tag
	uint16_g sidedef1;  // right sidedef
	uint16_g sidedef2;  // left sidedef (only if this line adjoins 2 sectors)
}
raw_linedef_t;

typedef struct raw_hexen_linedef_s
{
	uint16_g start;        // from this vertex...
	uint16_g end;          // ... to this vertex
	uint16_g flags;        // linedef flags (impassible, etc)
	uint8_g  type;         // linedef type
	uint8_g  specials[5];  // hexen specials
	uint16_g sidedef1;     // right sidedef
	uint16_g sidedef2;     // left sidedef
}
raw_hexen_linedef_t;

#define ML_IMPASSABLE  1
#define ML_TWOSIDED  4
#define ML_LOWER_UNPEG  16

#define LINEFLAG_TWO_SIDED  4

#define HEXTYPE_POLY_START     1
#define HEXTYPE_POLY_EXPLICIT  5


typedef struct raw_sidedef_s
{
	sint16_g x_offset;  // X offset for texture
	sint16_g y_offset;  // Y offset for texture

	char upper_tex[8];  // texture name for the part above
	char lower_tex[8];  // texture name for the part below
	char mid_tex[8];    // texture name for the regular part

	uint16_g sector;    // adjacent sector
}
raw_sidedef_t;


typedef struct raw_sector_s
{
	sint16_g floor_h;   // floor height
	sint16_g ceil_h;    // ceiling height

	char floor_tex[8];  // floor texture
	char ceil_tex[8];   // ceiling texture

	uint16_g light;     // light level (0-255)
	uint16_g special;   // special behaviour (0 = normal, 9 = secret, ...)
	sint16_g tag;       // sector activated by a linedef with same tag
}
raw_sector_t;

#define SECTYPE_DAMAGE_5   7
#define SECTYPE_DAMAGE_10  5
#define SECTYPE_DAMAGE_20  16



typedef struct raw_thing_s
{
	sint16_g x, y;      // position of thing
	sint16_g angle;     // angle thing faces (degrees)
	uint16_g type;      // type of thing
	uint16_g options;   // when appears, deaf, etc..
}
raw_thing_t;


// -JL- Hexen thing definition
typedef struct raw_hexen_thing_s
{
	sint16_g tid;       // thing tag id (for scripts/specials)
	sint16_g x, y;      // position
	sint16_g height;    // start height above floor
	sint16_g angle;     // angle thing faces
	uint16_g type;      // type of thing
	uint16_g options;   // when appears, deaf, dormant, etc..

	uint8_g special;    // special type
	uint8_g arg[5];     // special arguments
} 
raw_hexen_thing_t;


#endif /* __OBLIGE_STRUCTS_H__ */
