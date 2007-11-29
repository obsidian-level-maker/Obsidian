//------------------------------------------------------------------------
//  LEVEL building - Block exporter
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


namespace level_block
{

/* private data */

std::vector<entity_c *> lev_ents;

FILE *out_fp;


entity_c::entity_c(short _x, short _y, short _z, short _type) :
		x(_x), y(_y), z(_z), type(_type), angle(90)
{
}

entity_c::~entity_c()
{ }



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

void B_WriteHeader()
{
	fprintf(out_fp, "@LEVEL  %d  %d %d\n\n",
			64, the_world->w(), the_world->h());
}

void B_WriteTrailer()
{
	fprintf(out_fp, "@END\n");
}

void B_WriteTextures()
{
	fprintf(out_fp, "@TEXTURES\n");

	// FIXME !!!
	fprintf(out_fp, "std-sky\n");    // #1
	fprintf(out_fp, "std-water\n");  // #2
	fprintf(out_fp, "std-grass\n");  // #3
	fprintf(out_fp, "std-alum\n");   // #4

	fprintf(out_fp, "\n");
}

void B_WriteSquares()
{
	//!!!! FIXME: handle large void areas (use separate blocks)

	fprintf(out_fp, "@BLOCK  0 0  %d %d\n",
			the_world->w(), the_world->h());

	for (int y = 0; y < the_world->h(); y++)
	for (int x = 0; x < the_world->w(); x++)
	{
		location_c& L = the_world->Loc(x, y);

		bool water = (L.env == ENV_Water) ? true : false;

		fprintf(out_fp, "%c _ 0 %d 0  %d %d %d %d  %d %d\n",
				(L.env <= ENV_VOID) ? 'V' : 'A',
				(L.env <= ENV_VOID) ? 0 : (L.env >= ENV_Building) ? 160 : 224,
				water ? 2 : L.Outdoor() ? 3 : 4,
				water ? 2 : L.Outdoor() ? 3 : 4,
				L.Outdoor() ? 1 : 4,
				L.Outdoor() ? 1 : 4,
				L.floor_h * 64 + ((L.env == ENV_Water) ? -20 : 0),
				L.ceil_h * 64 );
	}

	fprintf(out_fp, "\n");
}

void B_WriteObjects()
{
	fprintf(out_fp, "@OBJECTS\n");

	for (int i = 0; i < (int)lev_ents.size(); i++)
	{
		entity_c *E = lev_ents[i];
		SYS_ASSERT(E);

		fprintf(out_fp, "%s  %d %d %d  %d %d\n",
				"player", E->x, E->y, E->z, E->angle, 7);
	}

	fprintf(out_fp, "\n");
}


//------------------------------------------------------------------------
//  PUBLIC INTERFACE
//------------------------------------------------------------------------

void AddThing(short x, short y, short type)
{
	if (type != 1) return; //!!!!

	short z = the_world->Loc(x, y).floor_h*64;

	lev_ents.push_back(new entity_c(VX(x,2), VY(y,2), z, type));
}

void Construct()
{
	// nothing to do


	// FIXME: just testing crap below....
#if 0
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
#endif
}

void Cleanup()
{
	int i;

	for (i = 0; i < (int)lev_ents.size(); i++)
		delete lev_ents[i];
	
	lev_ents.resize(0);
}

void WriteBlock(const char *filename)
{
	out_fp = fopen(filename, "wb");

	if (! out_fp)
		FatalError("Unable to create file: %s\n", filename);

	Construct();

	B_WriteHeader();
	B_WriteTextures();
    B_WriteObjects();
    B_WriteSquares();
	B_WriteTrailer();

	fclose(out_fp);
	out_fp = NULL;

	Cleanup();
}


}  // namespace level_cube
