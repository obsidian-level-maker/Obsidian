//------------------------------------------------------------------------
//  LEVEL building - Wolf3d format
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006,2007 Andrew Apted
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

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"

#include "g_wolf.h"

#include "main.h"
#include "ui_dialog.h"
#include "ui_window.h"


#define RLEW_TAG  0xABCD

#define NO_TILE  48
#define NO_OBJ   0

#define OBJ_PLAYER_START  19  /* + direction */


/* private data */

std::vector<thing_c *> lev_things;

static FILE *map_fp;
static FILE *head_fp;

static int map_offset;

//------------------------------------------------------------------------

thing_c::thing_c(short _x, short _y, short _type) :
		x(_x), y(_y), type(_type)
{ }

thing_c::~thing_c()
{ }


//------------------------------------------------------------------------
//  WOLF OUTPUT
//------------------------------------------------------------------------

static void WF_PutU16(uint16_g val, FILE *fp)
{
	fputc(val & 0xFF, fp);
	fputc((val >> 8) & 0xFF, fp);
}

static void WF_PutU32(uint32_g val, FILE *fp)
{
	fputc(val & 0xFF, fp);
	fputc((val >> 8) & 0xFF, fp);
	fputc((val >> 16) & 0xFF, fp);
	fputc((val >> 24) & 0xFF, fp);
}

static void WF_PutNString(const char *str, int max_len, FILE *fp)
{
	SYS_ASSERT((int)strlen(str) <= max_len);

	while (*str)
	{
		fputc(*str++, fp);
		max_len--;
	}

	for (; max_len > 0; max_len--)
	{
		fputc(0, fp);
	}
}

namespace rle_comp
{
/* private */
	unsigned short value;
	unsigned short repeat;

	void Begin()
	{
		repeat = 0;
	}

	void Flush()
	{
		while (repeat > 3)
		{
			int actual = MIN(128, repeat);

			WF_PutU16(RLEW_TAG, map_fp);  // tag
			WF_PutU16(actual, map_fp);    // count
			WF_PutU16(value, map_fp);     // value

			repeat -= actual;
		}

		for (; repeat > 0; repeat--)
		{
			WF_PutU16(value, map_fp);
		}
	}

	void Add(unsigned short datum)
	{
		// don't want no Carmackization...
		SYS_ASSERT((datum & 0xFF00) != 0xA700);
		SYS_ASSERT((datum & 0xFF00) != 0xA800);

		// it shouldn't match the RLEW tag either...
		SYS_ASSERT(datum != RLEW_TAG);

#if 1
		WF_PutU16(datum, map_fp);
#else
		if (repeat > 0)
		{
			if (datum == value)
			{
				repeat++;
				return;
			}

			Flush();
		}

		value = datum;
		repeat = 1;
#endif
	}

} // namespace rle_comp


char Material_Tile(char mat)
{
	return (mat*2);

#if 0 //!!!
	switch (mat)
	{
		// Land
		case MAT_Grass:  return 18;
		case MAT_Sand:   return 53;
		case MAT_Rock:   return 0;
		case MAT_Stone:  return 7;

		// Water
		case MAT_Water:  return 4;
		case MAT_Lava:   return 2;
		case MAT_Nukage: return 47;
		case MAT_Slime:  return 47;
		case MAT_Blood:  return 30;

		// Building
		case MAT_Lead:   return 51;
		case MAT_Alum:   return 14;
		case MAT_Tech:   return 41;
		case MAT_Light:  return 15;
		case MAT_Wood:   return 11;
		case MAT_Brick:  return 16;
		case MAT_Marble: return 49;

		// Cave
		case MAT_Ash:    return 50;

		default:
			return 48;  // ILLEGAL
	}
#endif
}

static void WriteSolidPlane(int *offset, int *length)
{
	*offset = (int)ftell(map_fp);

	WF_PutU16(64*64*2 + 2, map_fp);  // compressed size (FIXME: could go wrong!)
	WF_PutU16(64*64*2, map_fp);      // expanded size

	rle_comp::Begin();

	for (int y = 63; y >= 0; y--)
	for (int x = 0;  x < 64; x++)
	{
		if (the_world->Outside(x-1, y-1))
		{
			rle_comp::Add(NO_TILE);
			continue;
		}

		location_c& loc = the_world->Loc(x-1, y-1);

		if (loc.Void() || loc.stru == STRU_Wall)
		{
			rle_comp::Add(Material_Tile(loc.mat));
			continue;
		}

		rle_comp::Add(107 /* AREATILE */);  //!!! FIXME
	}

	rle_comp::Flush();

	*length = (int)ftell(map_fp);
	*length -= *offset;
}

static void WriteThingPlane(int *offset, int *length)
{
	*offset = (int)ftell(map_fp);

	WF_PutU16(64*64*2 + 2, map_fp);  // compressed size (FIXME: could be wrong)
	WF_PutU16(64*64*2, map_fp);      // expanded size

	rle_comp::Begin();

	for (int y = 63; y >= 0; y--)
	for (int x = 0;  x < 64; x++)
	{
		if (the_world->Outside(x-1, y-1))
		{
			rle_comp::Add(NO_OBJ);
			continue;
		}

		location_c& loc = the_world->Loc(x-1, y-1);

		if (loc.Void() || loc.stru == STRU_Wall)
		{
			rle_comp::Add(NO_OBJ);
			continue;
		}

		// FIXME: this is stupidly inefficient
		int obj_type = NO_OBJ;

		for (int i = 0; i < (int)lev_things.size(); i++)
		{
			thing_c *T = lev_things[i];
			SYS_ASSERT(T);

			if (T->x == x && T->y == y)
			{
				obj_type = T->type;
				break;
			}
		}

		rle_comp::Add(obj_type);
	}

	rle_comp::Flush();

	*length = (int)ftell(map_fp);
	*length -= *offset;
}

static void WriteBlankPlane(int *offset, int *length)
{
	*offset = (int)ftell(map_fp);

	WF_PutU16(3*2 + 2, map_fp);  // compressed size + 2
	WF_PutU16(64*64*2, map_fp);  // expanded size

	WF_PutU16(RLEW_TAG, map_fp); // tag
	WF_PutU16(64 * 64, map_fp);  // count
	WF_PutU16(0, map_fp);        // value

	*length = (int)ftell(map_fp);
	*length -= *offset;
}

static void WriteMap(void)
{
	SYS_ASSERT(the_world->w() <= 62);
	SYS_ASSERT(the_world->h() <= 62);

	const char *message = OBLIGE_TITLE " " OBLIGE_VERSION;

	WF_PutNString(message, 64, map_fp);

	int plane_offsets[3];
	int plane_lengths[3];

	WriteSolidPlane(plane_offsets+0, plane_lengths+0);
	WriteThingPlane(plane_offsets+1, plane_lengths+1);
	WriteBlankPlane(plane_offsets+2, plane_lengths+2);

	map_offset = (int)ftell(map_fp);
	// FIXME: validate (error check)

	WF_PutU32(plane_offsets[0], map_fp);
	WF_PutU32(plane_offsets[1], map_fp);
	WF_PutU32(plane_offsets[2], map_fp);

	WF_PutU16(plane_lengths[0], map_fp);
	WF_PutU16(plane_lengths[1], map_fp);
	WF_PutU16(plane_lengths[2], map_fp);

	// width and height
	WF_PutU16(64, map_fp);
	WF_PutU16(64, map_fp);

	WF_PutNString("Custom Map", 16, map_fp);  // name

	WF_PutNString("!ID!", 4, map_fp);  // sanity check ??
}

static void WriteHead(void)
{
	WF_PutU16(RLEW_TAG, head_fp);

	// offset to first map (info struct)
	WF_PutU32(map_offset, head_fp);

	// set remaining offsets to zero (=> no map)
	for (int lev = 1; lev < 60; lev++)
	{
		WF_PutU32(0, head_fp);
	}
}


//------------------------------------------------------------------------
//  PUBLIC INTERFACE
//------------------------------------------------------------------------

void AddThing(short x, short y, short type)
{
	if (type != 1) return; //!!!!

	type = 19;  // player start

	lev_things.push_back(new thing_c(x, y, type));
}


void Wolf_InitLua(lua_State *L)
{
//  luaL_register(L, "wolf", wad_funcs);
}

void Wolf_Begin(void)
{
	map_fp = fopen("GAMEMAPS.OUT", "wb");
	if (! map_fp)
		FatalError("unable to open GAMEMAPS.OUT\n");

	head_fp = fopen("MAPHEAD.OUT", "wb");
	if (! head_fp)
		FatalError("unable to open MAPHEAD.OUT\n");

}

bool Wolf_Finish(void)
{
  // FIXME

	WriteMap();
	WriteHead();

	fclose(map_fp);
	fclose(head_fp);

	map_fp = head_fp = NULL;
}

