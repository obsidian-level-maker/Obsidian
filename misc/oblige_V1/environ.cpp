//------------------------------------------------------------------------
//  ENVIRON
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

namespace environ_build
{

/* private data */
char land_mat;
char water_mat;
char building_mat;
char cave_mat;


void SetupMaterials()
{
	static const char land_mats[4] =
	{
		MAT_Grass, MAT_Sand, MAT_Rock,  MAT_Stone
	};

	static const char water_mats[5] =
	{
		MAT_Water,  MAT_Lava, MAT_Nukage, MAT_Slime, MAT_Blood
	};

	static const char building_mats[7] =
	{
		MAT_Lead, MAT_Alum, MAT_Tech,
		MAT_Wood, MAT_Brick, MAT_Marble, MAT_Stone
	};

	static const char cave_mats[2] =
	{
		MAT_Ash, MAT_Rock
	};

	land_mat = land_mats[RandomIndex(4)];
	water_mat = water_mats[RandomIndex(5)];
	building_mat = building_mats[RandomIndex(7)];
	cave_mat = cave_mats[RandomIndex(2)];
}

char MaterialForEnv(char env)
{
	switch (env)
	{
		case ENV_Land:     return land_mat;
		case ENV_Water:    return water_mat;
		case ENV_Building: return building_mat;
		case ENV_Cave:     return cave_mat;
			
		default:
			return MAT_INVALID;
	}
}

char RandomSpeed()
{
	return (RandomRange(1,3) << 4) + RandomRange(1,3);
}

bool BoxIsEmpty(int bx, int by, int bw, int bh)
{
	SYS_ASSERT(bx >= 0 && by >= 0);
	SYS_ASSERT(bw >  0 && bh >  0);

	for (int y = by; y < by+bh; y++)
	for (int x = bx; x < bx+bw; x++)
	{
		if (the_world->Loc(x, y).env != ENV_EMPTY)
			return false;
	}

	return true;
}

void BoxFill(int bx, int by, int bw, int bh,
			 char env, char mat, short area, char speed)
{
	SYS_ASSERT(bx >= 0 && by >= 0);
	SYS_ASSERT(bw >  0 && bh >  0);

	for (int y = by; y < by+bh; y++)
	for (int x = bx; x < bx+bw; x++)
	{
		the_world->SetEnv(x, y, env, mat, area, speed);
	}
}

void AddBuilding(short *area)
{
	int bw, bh;

	for (;;)
	{
		bw = 5 + RandomRange(0, the_world->w() / 3);
		bh = 5 + RandomRange(0, the_world->h() / 3);

		if (bw*bh < 700)
			break;
	}

	int bx = RandomRange(0, the_world->w() - bw);
	int by = RandomRange(0, the_world->h() - bh);

	BoxFill(bx, by, bw, bh, (char)ENV_Building, building_mat, *area, 0);
	(*area) += 1;
}

void AddBuildingToCorner(int cx, int cy, short *area)
{
	int bw, bh;

	for (;;)
	{
		bw = 5 + RandomRange(0, the_world->w() / 3);
		bh = 5 + RandomRange(0, the_world->h() / 3);

		if (bw*bh < 700)
			break;
	}

	int bx = cx ? the_world->w() - bw : 0;
	int by = cy ? the_world->h() - bh : 0;

	BoxFill(bx, by, bw, bh, (char)ENV_Building, building_mat, *area, 0);
	(*area) += 1;
}

void AddCorners(short *area)
{
	for (int cy = 0; cy < 2; cy++)
	for (int cx = 0; cx < 2; cx++)
	{
		int x = cx ? the_world->w() - 2 : 0;
		int y = cy ? the_world->h() - 2 : 0;

		if (! BoxIsEmpty(x, y, 2, 2))
			continue;

		if (RandomPerc(50))
		{
			the_world->SetEnv(x, y, ENV_VOID, MAT_INVALID, 0, 0x33);
			continue;
		}

		char env = ENV_Land + RandomRange(0, 3);
		char mat = MaterialForEnv(env);

		if (env == ENV_Building)
		{
			AddBuildingToCorner(cx, cy, area);
			continue;
		}

		BoxFill(x, y, 2, 2, env, mat, *area, RandomSpeed());
		(*area) += 1;
	}
}

void AddSpawnPoint(char env, short *area, int chain_div)
{
	int x = -1;
	int y = -1;

	for (int loop = 0; ; loop++)
	{
		if (loop == 50)
			return;

		x = RandomRange(0, the_world->w() - 2);
		y = RandomRange(0, the_world->h() - 2);

		if (BoxIsEmpty(x, y, 2, 2))
			break;
	}

	// support for "Chains"
	int chain_len = RandomRange(1, 1 + the_world->dim() / chain_div);

	int cdx = RandomBool() ? -1 : +1;
	int cdy = RandomBool() ? -1 : +1;

	for (; chain_len > 0; chain_len--)
	{
		if (env == ENV_VOID)
		{
			BoxFill(x, y, 2, 2, ENV_VOID, MAT_INVALID, 0, 0x22);
		}
		else
		{
			BoxFill(x, y, 2, 2, env, MaterialForEnv(env), *area, RandomSpeed());

			if (RandomPerc((env == ENV_Cave) ? 50 : 25))
				(*area) += 1;
		}

		x += cdx * RandomRange(-1, 9);
		y += cdy * RandomRange(-1, 9);

		if (the_world->Outside(x, y) || the_world->Outside(x+1,y+1))
			break;

		if (! BoxIsEmpty(x, y, 2, 2))
			break;
	}

	// make sure area has definitely changed
	(*area) += 1;
}

void AddVoidSeparators(short *area)
{
	int x_divs = the_world->w() / RandomRange(60,120);
	int y_divs = the_world->h() / RandomRange(60,120);

	for (int ix = 0; ix < x_divs; ix++)
	{
		int x = the_world->w() * (ix + 1) / (x_divs + 1) + RandomRange(-5,+5);

		for (int y = 0; y < the_world->h(); y++)
			the_world->SetEnv(x, y, ENV_VOID, MAT_INVALID, 0, 0x01);
	}

	for (int iy = 0; iy < y_divs; iy++)
	{
		int y = the_world->w() * (iy + 1) / (y_divs + 1) + RandomRange(-5,+5);
		
		for (int x = 0; x < the_world->w(); x++)
			the_world->SetEnv(x, y, ENV_VOID, MAT_INVALID, 0, 0x10);
	}
}

void InitialEnvironment()
{
	int base = the_world->dim() / 10 + 2;
	int total;

	int num_land, num_water;
	int num_buildings, num_caves;
	int num_void;

	// ensure good mix (especially: not all zero)
	for (;;)
	{
		num_buildings = RandomRange(1, base) * 3;
		num_land      = RandomRange(0, base) * 2;
		num_water     = RandomRange(0, base) * 1;
		num_caves     = RandomRange(0, base) * 1;
		num_void      = RandomRange(1, base) * 2;

		total = num_buildings + num_land + num_water + num_caves;

		if (total > base/2)
			break;
	}

	short i;
	short area = TEMP_AREA;

	AddVoidSeparators(&area);
	
	for (i = 0; i < num_buildings; i++)
		AddBuilding(&area);

	AddCorners(&area);

	for (i = 0; i < num_void; i++)
		AddSpawnPoint(ENV_VOID, &area, 40);
	
	for (i = 0; i < num_water; i++)
		AddSpawnPoint(ENV_Water, &area, 10);

	for (i = 0; i < num_land; i++)
		AddSpawnPoint(ENV_Land, &area, 16);

	for (i = 0; i < num_caves; i++)
		AddSpawnPoint(ENV_Cave, &area, 24);

	SYS_ASSERT(area > TEMP_AREA);
}

//------------------------------------------------------------------------

void GrowCell(int x, int y, int dx, int dy)
{
	if (the_world->Outside(x+dx, y+dy))
		return;
	
	char env = the_world->Loc(x, y).env;
	char speed = the_world->Loc(x, y).speed;

	if (dx != 0)
		speed &= 0x03;
	else
		speed = (speed >> 4) & 0x03;

	if (env == ENV_EMPTY || speed == 0)
		return;

	if (the_world->Loc(x+dx, y+dy).env != ENV_EMPTY)
		return;

	if (RandomPerc(25*(speed+1)))
	{
		the_world->CopyEnv(x+dx, y+dy, x, y);
	}
}

void GrowPass(const int *rowcol_order, int dim_max)
{
	for (int i = 0; i < dim_max; i++)
	{
		int dir = RandomBool() ? -1 : +1;

		if (RandomBool())  /* horizontal */
		{
			int GY = rowcol_order[i];

			if (GY >= the_world->h())
				continue;

			for (int x = 0; x < the_world->w(); x++)
				GrowCell(dir < 0 ? x : the_world->w()-1-x, GY, dir, 0);
		}
		else  /* vertical */
		{
			int GX = rowcol_order[i];

			if (GX >= the_world->w())
				continue;

			for (int y = 0; y < the_world->h(); y++)
				GrowCell(GX, dir < 0 ? y : the_world->h()-1-y, 0, dir);
		}
	}
}

int CountEmpty()
{
	int count = 0;

	FOR_LOC(x, y, loc)
	{
		if (loc.env == ENV_EMPTY) count++;
	}}

	return count;
}

void SetVoidMaterials()
{
	// even void space has a material (based on the surrounding
	// environment).  This is needed to fix a problem where some
	// one-sided lines had an out-of-place texture.

	for (int loop = 0; loop < 10; loop++)
	{
		FOR_LOC(x, y, loc)
		{
			if (loc.env != ENV_VOID || loc.mat != MAT_INVALID)
				continue;

			int dir_rand = RandomIndex(4);

			static const int dxs[4] = { +1, 0, -1, 0 };
			static const int dys[4] = { 0, +1, 0, -1 };

			for (int dir = 0; dir < 4; dir++)
			{
				int x2 = x + dxs[dir ^ dir_rand];
				int y2 = y + dys[dir ^ dir_rand];

				if (the_world->Outside(x2, y2))
					continue;

				if (the_world->Loc(x2, y2).mat == MAT_INVALID)
					continue;

				loc.mat = the_world->Loc(x2, y2).mat;
				break;
			}
		}}
	}
}

void GrowEnvironment()
{
	int rowcol_order[MAX_DIM];
	int dim_max = MAX(the_world->w(), the_world->h());

	SYS_ASSERT(dim_max <= MAX_DIM);

	RandomShuffle(rowcol_order, dim_max, true /* fill */);

	int last_empty = (1 << 30);

	for (;;)
	{
		for (int pass = 0; pass < 6; pass++)
		{
			GrowPass(rowcol_order, dim_max);
			RandomShuffle(rowcol_order, dim_max, false /* fill */);
		}

		int empty = CountEmpty();

		// stop when number of EMPTY cells is no longer decreasing
		if (empty == last_empty)
			break;

		last_empty = empty;
	}

	PrintDebug("Empty blocks: %d\n", last_empty);

	// Replace any EMPTY cells with void space
	FOR_LOC(x, y, loc)
	{
		if (loc.env == ENV_EMPTY)
			the_world->SetEnv(x, y, ENV_VOID, MAT_INVALID, 0, 0);
	}}

	SetVoidMaterials();
}

//------------------------------------------------------------------------

void PolishEnvironment()
{
	//!!!!! ensure no "diagonal only" touches

	//!!! ensure that no more than 3 sectors touch a corner

	PrintDebug("\n");
}


//------------------------------------------------------------------------
//  PUBLIC INTERFACE
//------------------------------------------------------------------------

void CreateEnv()
{
	SetupMaterials();
	InitialEnvironment();
  	GrowEnvironment();
	PolishEnvironment();
}

} // namespace environ_build

