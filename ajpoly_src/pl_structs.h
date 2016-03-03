//------------------------------------------------------------------------
//
//  AJ-Polygonator (C) 2000-2013 Andrew Apted
//
//  This library is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This library is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#ifndef __AJPOLY_STRUCTS_H__
#define __AJPOLY_STRUCTS_H__

#ifdef __GNUC__
#define PACKEDATTR __attribute__((packed))
#else
#define PACKEDATTR
#endif

typedef struct
{
	char type[4];

	u32_t num_entries;
	u32_t dir_start;

} PACKEDATTR raw_wad_header_t;


typedef struct
{
	u32_t start;
	u32_t length;

	char name[8];

} PACKEDATTR raw_wad_entry_t;


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

typedef struct
{
	u16_t start;        // from this vertex...
	u16_t end;          // ... to this vertex
	u16_t flags;        // linedef flags (impassible, etc)
	u8_t  type;         // linedef type
	u8_t  specials[5];  // hexen specials
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


typedef struct
{
	s16_t tid;       // thing tag id (for scripts/specials)
	s16_t x, y;      // position
	s16_t height;    // start height above floor
	s16_t angle;     // angle thing faces
	u16_t type;      // type of thing
	u16_t options;   // when appears, deaf, dormant, etc..

	u8_t special;    // special type
	u8_t arg[5];     // special arguments

}  PACKEDATTR raw_hexen_thing_t;


#endif /* __AJPOLY_STRUCTS_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
