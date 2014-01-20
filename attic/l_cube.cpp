//------------------------------------------------------------------------
//  LEVEL building - Cube exporter
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

// this includes everything we need
#include "defs.h"


namespace level_cube
{

/* private data */

std::vector<entity_c *> lev_ents;

FILE *out_fp;


entity_c::entity_c(short _x, short _y, short _z, short _type) :
		x(_x), y(_y), z(_z), type(_type)
{
	attrs[0] = attrs[1] = attrs[2] = attrs[3] = 0;
}

entity_c::~entity_c()
{ }


//------------------------------------------------------------------------
//  CUBE DEFINITIONS
//------------------------------------------------------------------------

enum   // block types, order matters!
{
	BK_SOLID    = 0,  // entirely solid cube [only specifies wtex]
	BK_CORNER   = 1,  // half full corner of a wall
	BK_FLOOR_HF = 2,  // floor heightfield using neighbour vdelta values
	BK_CEIL_HF  = 3,  // idem ceiling
	BK_SPACE    = 4   // entirely empty cube
};

enum   // hardcoded texture numbers
{
	DEFAULT_SKY    = 0,
	DEFAULT_LIQUID = 1,
	DEFAULT_WALL   = 2,
	DEFAULT_FLOOR  = 3,
	DEFAULT_CEIL   = 4
};

enum   // static entity types
{
	ENT_INVALID = 0,
	ENT_LIGHT,            // attr1 = radius, attr2 = intensity
	ENT_PLAYERSTART,      // attr1 = angle

	ENT_SHELLS,
	ENT_BULLETS,
	ENT_ROCKETS,
	ENT_ROUNDS,
	ENT_HEALTH,
	ENT_BOOST,
	ENT_GREENARMOUR,
	ENT_YELLOWARMOUR,
	ENT_QUAD,

	ENT_TELEPORT,         // attr1 = idx
	ENT_TELEDEST,         // attr1 = angle, attr2 = idx
	ENT_MAPMODEL,         // attr1 = angle, attr2 = idx
	ENT_MONSTER,          // attr1 = angle, attr2 = monstertype
	ENT_CARROT,           // attr1 = tag, attr2 = type
	ENT_JUMPPAD           // attr1 = zpush, attr2 = ypush, attr3 = xpush
};


//------------------------------------------------------------------------
//  CUBE-FILE OUTPUT
//------------------------------------------------------------------------

inline int VX(int bx, int offset = 0)
{
	return bx * 4 + 4 + offset;
}

inline int VY(int by, int offset = 0)
{
	int sz = 32;

	return (sz - 2 - by) * 4 + 4 + offset;
}

void PutU16(uint16_g val)
{
	fputc(val & 0xFF, out_fp);
	fputc((val >> 8) & 0xFF, out_fp);
}

void PutU32(uint32_g val)
{
	fputc(val & 0xFF, out_fp);
	fputc((val >> 8) & 0xFF, out_fp);
	fputc((val >> 16) & 0xFF, out_fp);
	fputc((val >> 24) & 0xFF, out_fp);
}

void PutNString(const char *str, int max_len)
{
	SYS_ASSERT((int)strlen(str) <= max_len);

	while (*str)
	{
		fputc(*str++, out_fp);
		max_len--;
	}

	for (; max_len > 0; max_len--)
	{
		fputc(0, out_fp);
	}
}

void C_WriteHeader()
{
	PutNString("CUBE", 4);

	PutU32(5);    // version
	PutU32(980);  // header size
	PutU32(7);    // 256x256 squares  (FIXME !!!)
	PutU32(lev_ents.size());

	// title (FIXME)
	PutNString("Random Level by Oblige", 128);

	// texlists - ???
	for (int type = 0; type < 3; type++)
	for (int i = 0; i < 256; i++)
	{
		fputc(i, out_fp);
	}

	// water level, then padding
	PutU32((uint32_g)-100000);

	for (int j = 0; j < 15; j++)
		PutU32(0);
}

void C_WriteSquares()
{
	// FIXME: compress non-void stuff better

	int sz = 32; //!!!!

	for (int y = sz-2; y >= -1; y--)
	{
		for (int row = 0; row < 4; row++)
		for (int x = -1; x < sz-1; x++)
		{
			location_c dummy;
			dummy.env = ENV_VOID;
			dummy.mat = MAT_INVALID;

			location_c& loc = the_world->Outside(x,y) ? dummy : the_world->Loc(x, y);

			// compression for VOID space 
			if (loc.Void() || loc.stru == STRU_Wall)
			{
				int count = 4;

				while (x+1 < sz-1)
				{
					if (count > 240)
						break;

					location_c& next = the_world->Outside(x+1,y) ? dummy :
							the_world->Loc(x+1, y);

					if (! (next.Void() || next.stru == STRU_Wall))
						break;

					// FIXME: if (loc.mat != next.mat) break

					x++; count += 4;
				}
				
				fputc(BK_SOLID, out_fp);      // type
				fputc(DEFAULT_WALL, out_fp);  // wtex
				fputc(0, out_fp);             // vdelta

				fputc(255, out_fp);  // repeat
				fputc(count-1, out_fp);

				continue;
			}

			SYS_ASSERT(the_world->Inside(x, y));

			fputc(BK_SPACE, out_fp);         // type
			fputc(loc.floor_h * 4, out_fp);  // floor_h
			fputc(loc.ceil_h  * 4, out_fp);  // ceil_h

			fputc(DEFAULT_WALL, out_fp);  // wtex
			fputc((loc.env == ENV_Water) ? DEFAULT_LIQUID : DEFAULT_FLOOR, out_fp);  // ftex
			fputc(loc.Outdoor() ? DEFAULT_SKY : DEFAULT_CEIL, out_fp);  // ctex

			fputc(0, out_fp);   // vdelta
			fputc(DEFAULT_WALL, out_fp);  // utex
			fputc(0, out_fp);   // tag

			fputc(255, out_fp);  // repeat
			fputc(3, out_fp);
		}
	}
}

void C_WriteEntities()
{
	for (int i = 0; i < (int)lev_ents.size(); i++)
	{
		entity_c *E = lev_ents[i];
		SYS_ASSERT(E);

		PutU16(E->x);
		PutU16(E->y);
		PutU16(E->z);
		PutU16(E->attrs[0]);

		fputc(E->type, out_fp);
		fputc(E->attrs[1], out_fp);
		fputc(E->attrs[2], out_fp);
		fputc(E->attrs[3], out_fp);
	}
}


//------------------------------------------------------------------------
//  PUBLIC INTERFACE
//------------------------------------------------------------------------

void AddThing(short x, short y, short type)
{
	if (type != 1) return; //!!!!
	type = ENT_PLAYERSTART;

	short z = the_world->Loc(x, y).floor_h*4 + 1;

	lev_ents.push_back(new entity_c(VX(x,2), VY(y,2), z, type));
}

void Construct()
{
	// nothing to do


	// FIXME: just testing crap below....

	FOR_LOC(x, y, loc)
    {
        if (loc.Void())
            continue;

		if (RandomPerc(90))
			continue;

		short z = the_world->Loc(x, y).ceil_h*4 - 2;

		lev_ents.push_back(new entity_c(VX(x,2), VY(y,2), z, ENT_LIGHT));

		entity_c *E = lev_ents[lev_ents.size()-1];

		E->attrs[0] = RandomRange(4,16);
		E->attrs[1] = RandomRange(25,255);
    }}
}

void Cleanup()
{
	int i;

	for (i = 0; i < (int)lev_ents.size(); i++)
		delete lev_ents[i];
	
	lev_ents.resize(0);
}

void WriteCube(const char *filename)
{
	out_fp = fopen(filename, "wb");

	if (! out_fp)
		FatalError("Unable to create file: %s\n", filename);

	Construct();

	C_WriteHeader();
    C_WriteEntities();
    C_WriteSquares();

	fclose(out_fp);
	out_fp = NULL;

	Cleanup();
}


}  // namespace level_cube
