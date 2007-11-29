//------------------------------------------------------------------------
//  WORLD storage
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


world_c *the_world = NULL;


area_c *location_c::Area() const
{
	SYS_ASSERT(! Void());
	SYS_ASSERT(area >= 0);

	return the_world->Area(area);
}

void location_c::DebugDump()
{
	PrintDebug("%s mat=%d area=%d ht=%d..%d\n",
		(env == ENV_EMPTY) ? "EMPTY" :
		(env == ENV_VOID)  ? "VOID" :
		(env == ENV_Land)  ? "Land" :
		(env == ENV_Water) ? "Water" :
		(env == ENV_Building) ? "Building" :
		(env == ENV_Cave) ? "Cave" : "<ERROR!>",
		mat, area, floor_h, ceil_h);
}

int location_c::MatchEnv(const location_c& other) const
{
	int score = 0;

	if (env == other.env)
		score += 100;
	else if (Indoor() == other.Indoor())
		score += 50;

	if (mat == other.mat)
		score += 10;
	
	return score;
}

//------------------------------------------------------------------------

//
// World Constructor
//
world_c::world_c(int _width, int _height) :
	width(_width), height(_height), areas()
{
	locs = new location_c[width * height];
}

//
// World Destructor
//
world_c::~world_c()
{
	delete[] locs;
}

Fl_Color world_c::EnvColorAt(int x, int y)
{
	if (! Loc(x,y).Void() && Loc(x,y).stru == STRU_Tunnel)
	{
		return fl_color_cube(4,0,4);
	}

	int kk = ((Loc(x,y).area + 400) % 3) * 24;
	
	switch (Loc(x,y).env)
	{
		case ENV_EMPTY:    return FL_BLACK;
		case ENV_VOID:     return Fl_Color(FL_GRAY_RAMP+6);

		case ENV_Land:     return fl_rgb_color(0,160+kk,0);
		case ENV_Water:    return fl_rgb_color(0,0,128+kk);
		case ENV_Building: return fl_rgb_color(192+kk, 170+kk, 0);
		case ENV_Cave:     return fl_rgb_color(160+kk,0,0);

		default:
			AssertFail("Bad environment value %d\n", Loc(x,y).env);
			return FL_RED;  /* NOT REACHED */
	}
}

area_c *world_c::NewArea(int index, int focal_x, int focal_y)
{
	SYS_ASSERT(index >= NumAreas() || areas[index] == NULL);

	if (index >= NumAreas())
	{
		int old = NumAreas();

		areas.resize(index + 1);

		for (; old < NumAreas(); old++)
			areas[old] = NULL;
	}

	areas[index] = new area_c(index, focal_x, focal_y);

	return Area(index);
}

area_c *world_c::RandomArea()
{
	SYS_ASSERT(NumAreas() > 0);

	for (;;)
	{
		area_c *result = Area(RandomIndex(NumAreas()));

		if (result)
			return result;
	}

	return NULL; /* NOT REACHED */
}

void world_c::PurgeDeadAreas()
{
	for (int ar_idx = 0; ar_idx < NumAreas(); ar_idx++)
	{
		if (areas[ar_idx] && areas[ar_idx]->total == 0)
		{
			PrintDebug("Purging dead area %d\n", ar_idx);

			delete areas[ar_idx];
			areas[ar_idx] = NULL;
		}
	}
}

int world_c::RealAreas()
{
	int result = 0;

	for (int ar_idx = 0; ar_idx < NumAreas(); ar_idx++)
	{
		if (Area(ar_idx))
			result++;
	}

	return result;
}

stage_c *world_c::NewStage()
{
	int index = NumStages();

	stages.resize(index + 1);

	stages[index] = new stage_c(index, 0);

	return Stage(index);
}

void world_c::RenumberStages(int *mapping)
{
	// update areas...

	for (int ar_idx = 0; ar_idx < the_world->NumAreas(); ar_idx++)
	{
		area_c *A = the_world->Area(ar_idx);
		if (! A)
			continue;

		if (A->stage >= 0)
			A->stage = mapping[A->stage];
	}

	// update stages...

	int num_stages = NumStages();
	int i;

	stage_c *temp[MAX_STAGES];

	for (i = 0; i < num_stages; i++)
	{
		SYS_ASSERT(stages[i]->index >= 0);
		SYS_ASSERT(stages[i]->index < num_stages);

		temp[i] = stages[i];
		temp[i]->index = mapping[temp[i]->index];

	}
	
	for (i = 0; i < num_stages; i++)
		stages[temp[i]->index] = temp[i];

	for (i = 0; i < num_stages; i++)
	{
		SYS_ASSERT(i == stages[i]->index);
	}
}

