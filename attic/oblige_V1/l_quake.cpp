//------------------------------------------------------------------------
//  LEVEL building - Quake style
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


namespace level_quake
{
/* private data */

std::vector<brush_c *> lev_brushes;
std::vector<entity_c *> lev_ents;

FILE *text_fp;


//------------------------------------------------------------------------


brush_c::brush_c(short _x, short _y, short _low, short _high, const char *_tex) :
	x(_x), y(_y), low(_low), high(_high)
{
	SYS_ASSERT(strlen(_tex) <= 16);

	strcpy(tex_name, _tex);
}

brush_c::~brush_c()
{ }


entity_c::entity_c(short _x, short _y, short _z, short _type) :
		x(_x), y(_y), z(_z), angle(90), type(_type), options(7),
		light_ity(200)
{ }

entity_c::~entity_c()
{ }


//------------------------------------------------------------------------
//  MAP-FILE OUTPUT
//------------------------------------------------------------------------

inline int VX(int bx, int offset = 0)
{
	return (bx - (the_world->w() / 2)) * 64 + offset;
}

inline int VY(int by, int offset = 0)
{
	return (by - (the_world->h() / 2)) * 64 + offset;
}

void T_WriteField(const char *field, const char *val_str, ...)
{
	fprintf(text_fp, "  \"%s\"  \"", field);

	va_list args;

	va_start(args, val_str);
	vfprintf(text_fp, val_str, args);
	va_end(args);

	fprintf(text_fp, "\"\n");
}

void T_WriteBrush(brush_c *B)
{
    fprintf(text_fp, "  {\n");

	int lx = VX(B->x);
	int ly = VY(B->y);
	int lz = B->low;

	int hx = lx + 64;
	int hy = ly + 64;
	int hz = B->high;

	// East
	fprintf(text_fp, "    ( %d %d %d ) ( %d %d %d ) ( %d %d %d ) %s 0 0 0 1 1\n",
			hx, ly, lz,  hx, ly, hz,  hx, hy, lz, B->tex_name);

	// South
	fprintf(text_fp, "    ( %d %d %d ) ( %d %d %d ) ( %d %d %d ) %s 0 0 0 1 1\n",
			lx, ly, lz,  lx, ly, hz,  hx, ly, lz, B->tex_name);

	// West
	fprintf(text_fp, "    ( %d %d %d ) ( %d %d %d ) ( %d %d %d ) %s 0 0 0 1 1\n",
			lx, hy, lz,  lx, hy, hz,  lx, ly, lz, B->tex_name);

	// North
	fprintf(text_fp, "    ( %d %d %d ) ( %d %d %d ) ( %d %d %d ) %s 0 0 0 1 1\n",
			hx, hy, lz,  hx, hy, hz,  lx, hy, lz, B->tex_name);

	// Top
	fprintf(text_fp, "    ( %d %d %d ) ( %d %d %d ) ( %d %d %d ) %s 0 0 0 1 1\n",
			lx, ly, hz,  lx, hy, hz,  hx, ly, hz, B->tex_name);

	// Bottom
	fprintf(text_fp, "    ( %d %d %d ) ( %d %d %d ) ( %d %d %d ) %s 0 0 0 1 1\n",
			lx, ly, lz,  hx, ly, lz,  lx, hy, lz, B->tex_name);

    fprintf(text_fp, "  }\n");
}

void T_WriteWorld()
{
fprintf(stderr, "text_fp = %p\n", text_fp);
	fprintf(text_fp, "{\n");
	
	T_WriteField("classname", "worldspawn");
	T_WriteField("worldtype", "0");
	T_WriteField("wad", "textures.wad");

	fprintf(text_fp, "\n");

	for (int i = 0; i < (int)lev_brushes.size(); i++)
	{
		brush_c *B = lev_brushes[i];
		if (! B) continue;

		T_WriteBrush(B);
	}
	
	fprintf(text_fp, "}\n\n");
}

void T_WriteEntities()
{
	for (int i = 0; i < (int)lev_ents.size(); i++)
	{
		entity_c *E = lev_ents[i];
		if (! E) continue;

		fprintf(text_fp, "{\n");
		
		T_WriteField("classname", "%s", E->ClassName());
		T_WriteField("origin", "%d %d %d", E->x, E->y, E->z);
		T_WriteField("angle", "%d", E->angle);

		if (E->type == 2)
			T_WriteField("light", "%d", E->light_ity);

		fprintf(text_fp, "}\n");
	}
}


//------------------------------------------------------------------------
//  CONSTRUCTION (world -> map)
//------------------------------------------------------------------------

const char *MaterialTex(char mat)
{
	switch (mat)
	{
		// Land
		case MAT_Grass:  return "ground1_1";
		case MAT_Sand:   return "ground1_6";
		case MAT_Rock:   return "rock4_2";
		case MAT_Stone:  return "stone1_3";

		// Water
		case MAT_Water:  return "*water0";
		case MAT_Lava:   return "*lava1";
		case MAT_Nukage: return "slip";
		case MAT_Slime:  return "*slime1";
		case MAT_Blood:  return "rune_a";

		// Building
		case MAT_Lead:   return "wizmet1_2";
		case MAT_Alum:   return "lgmetal4";
		case MAT_Tech:   return "tech01_1";
		case MAT_Light:  return "tlight01";
		case MAT_Wood:   return "wood1_1";
		case MAT_Brick:  return "bricka2_1";
		case MAT_Marble: return "dung01_1";

		// Cave
		case MAT_Ash:    return "rock5_2";

		default:
			return "dopefish";  // ILLEGAL
	}
}

void AddFloorBrush(int x, int y, const location_c& loc)
{
	SYS_ASSERT(! loc.Void());

	lev_brushes.push_back(new brush_c(x, y, -1024, int(loc.floor_h) * 64,
		MaterialTex(loc.mat))); 

	if (loc.mat >= MAT_Water && loc.mat <= MAT_Blood)
		lev_brushes.push_back(new brush_c(x, y, -1088, -1024, "city2_5"));
}

void AddCeilingBrush(int x, int y, const location_c& loc)
{
	SYS_ASSERT(! loc.Void());

	lev_brushes.push_back(new brush_c(x, y, int(loc.ceil_h) * 64, +1024,
		(loc.env <= ENV_Water) ? "sky1" :
			MaterialTex(loc.mat))); 
}

void AddSideBrush(int x, int y, const location_c& loc)
{
	lev_brushes.push_back(new brush_c(x, y, -1024, +1024,
		(loc.mat >= MAT_Water && loc.mat <= MAT_Blood) ? "city2_5" :
			MaterialTex(loc.mat))); 
}

void ConstructBrushes()
{
	FOR_LOC(x, y, loc)
	{
		if (x == 0)
			AddSideBrush(x - 1, y, loc);
		else if (x == the_world->w() - 1)
			AddSideBrush(x + 1, y, loc);

		if (y == 0)
			AddSideBrush(x, y - 1, loc);
		else if (y == the_world->h() - 1)
			AddSideBrush(x, y + 1, loc);

		if (! loc.Void())
		{
			AddFloorBrush(x, y, loc);
			AddCeilingBrush(x, y, loc);
		}
		else  /* Void */
		{
			for (int d = 0; d < 4; d++)
			{
				static const int dxs[4] = { -1, +1, 0, 0 };
				static const int dys[4] = { 0, 0, -1, +1 };

				if (the_world->Outside(x+dxs[d], y+dys[d]))
					continue;

				if (the_world->Loc(x+dxs[d], y+dys[d]).Void())
					continue;

				AddSideBrush(x, y, loc);
				break;
			}
		}
	}}
}

void ConstructEntities()
{
	// FIXME: just testing crap here....

	FOR_LOC(x, y, loc)
    {
        if (loc.Void())
            continue;

		if (RandomPerc(95))
			continue;
#if 0
		area_c *A = the_world->Area(loc.area);
		if (! A || A->island < 0 || A->stage < 0)
			continue;

		if (A->graph_idx == 123)
			continue;

		A->graph_idx = 123;
#endif
		short z = the_world->Loc(x, y).ceil_h * 64 - 32;

		lev_ents.push_back(new entity_c(VX(x,32), VY(y,32), z, (x&7) ? 2 : 3));
		
		lev_ents[lev_ents.size()-1]->light_ity = RandomRange(100,600);
    }}
}

//------------------------------------------------------------------------
//  PUBLIC INTERFACE
//------------------------------------------------------------------------

void AddThing(short x, short y, short type)
{
	if (type != 1) return; //!!!!

	short z = the_world->Loc(x, y).floor_h * 64 + 32;

	lev_ents.push_back(new entity_c(VX(x,32), VY(y,32), z, type));
}

void Construct()
{
	ConstructBrushes();
	ConstructEntities();
}

void Cleanup()
{
	int i;

	for (i = 0; i < (int)lev_brushes.size(); i++)
		delete lev_brushes[i];

	for (i = 0; i < (int)lev_ents.size(); i++)
		delete lev_ents[i];
	
	lev_brushes.resize(0);
	lev_ents.resize(0);
}

void WriteText(const char *filename)
{
	text_fp = fopen(filename, "w");

	if (! text_fp)
		FatalError("Unable to create file: %s\n", filename);

	Construct();

fprintf(stderr, "text_fp = %p\n", text_fp);
	T_WriteWorld();
    T_WriteEntities();

	fclose(text_fp);
	text_fp = NULL;

	Cleanup();
}


}  // namespace level_quake
