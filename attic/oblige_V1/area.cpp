//------------------------------------------------------------------------
//  AREAS
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


area_c::area_c(int _index, int fx, int fy) : index(_index),
	island(-1), stage(-1),
	floor_h(0), ceil_h(2), focal_x(fx), focal_y(fy),
	lo_x(fx), lo_y(fy), hi_x(fx), hi_y(fy), total(1),
	neighbours(), teleport(NULL),
	graph_idx(-1), star()
{ }

area_c::~area_c()
{ }

void area_c::AddPoint(int x, int y)
{
	lo_x = MIN(x, lo_x);
	lo_y = MIN(y, lo_y);

	hi_x = MAX(x, hi_x);
	hi_y = MAX(y, hi_y);

	total++;
}

void area_c::DetermineNeighbours()
{
	if (the_world->NumAreas() < 2)
		return;

	for (int ar_idx = 0; ar_idx < the_world->NumAreas(); ar_idx++)
	{
		if (ar_idx == index)
			continue;

		const area_c *other = the_world->Area(ar_idx);
		if (! other)
			continue;

		// quick BBox test
		int min_x = MAX(lo_x, other->lo_x);
		int min_y = MAX(lo_y, other->lo_y);

		int max_x = MIN(hi_x, other->hi_x);
		int max_y = MIN(hi_y, other->hi_y);

		if (max_x+1 < min_x || max_y+1 < min_y)
			continue;

		int count = 0;

		for (int y = min_y-1; y <= max_y+1; y++)
		for (int x = min_x-1; x <= max_x+1; x++)
		{
			if (the_world->Outside(x, y))
				continue;

			if ((int)the_world->Loc(x, y).area != index)
				continue;

			for (int dy = -1; dy <= +1; dy++)
			for (int dx = -1; dx <= +1; dx++)
			{
				if (dx == 0 && dy == 0)
					continue;

				if (! (dx == 0 || dy == 0))
					continue;

				if (the_world->Outside(x+dx, y+dy))
					continue;

				if ((int)the_world->Loc(x+dx, y+dy).area == ar_idx)
				{
					count++;
				}
			}
		}

		if (count > 0)
		{
			// Found one!
			NewNeighbour(ar_idx, count);

			PrintDebug("Neighbour of %d is %d (contacts %d)\n",
					index, ar_idx, count);
		}
	}
}

int area_c::NewNeighbour(int _area, int _contacts)
{
	int nb_idx = neighbours.size();

	neighbours.resize(nb_idx + 1);
	neighbours[nb_idx].Set(the_world->Area(_area), _contacts);

	SYS_ASSERT(neighbours[nb_idx].ptr);

	return nb_idx;
}

bool area_c::IsDamage() const
{
	switch (the_world->Loc(focal_x, focal_y).mat)
	{
		case MAT_Lava: case MAT_Nukage: case MAT_Slime:
			return true;

		default: return false;
	}
}

bool area_c::IsTunnel() const
{
	return (the_world->Loc(focal_x, focal_y).stru == STRU_Tunnel);
}

int area_c::WalkableNeighbours() const
{
	int count = 0;

	for (int nb_idx = 0; nb_idx < NumNeighbours(); nb_idx++)
	{
		const area_c *N = neighbours[nb_idx].ptr;
		SYS_ASSERT(N);

		if (N->IsDamage())
			continue;

		if (floor_h >= N->ceil_h || N->floor_h >= ceil_h)
			continue;

		count++;
	}

	return count;
}

bool area_c::TouchesWorldEdge() const
{
	return (lo_x == 0 || hi_x == the_world->w() - 1 ||
			lo_y == 0 || hi_y == the_world->h() - 1);
}

int area_c::dim() const
{
	return 1 + (hi_x - lo_x) / 2 + (hi_y - lo_y) / 2;
}

int area_c::RoughDist(const area_c *other) const
{
	int dx = ABS(MidX() - other->MidX());
	int dy = ABS(MidY() - other->MidY());

	if (dx > dy)
		return dx + dy / 2;
	else
		return dy + dx / 2;
}

void area_c::RandomLoc(int *X, int *Y) const
{
	for (;;)
	{
		*X = RandomRange(lo_x, hi_x);
		*Y = RandomRange(lo_y, hi_y);

		if (the_world->Loc(*X, *Y).area == index)
			return;
	}
}

void area_c::MakeVoid()
{
	PrintDebug("Voiding area %d\n", index);

	FOR_LOC_IN_AREA(x, y, loc, this)
	{
		loc.env = ENV_VOID;
		total--;
	}}

	SYS_ASSERT(total == 0);

	island = -1;
}

void area_c::DebugDump()
{
	PrintDebug("AREA %d: stage=%d ht=%d..%d focal=(%d,%d)\n",
		index, stage, floor_h, ceil_h, focal_x, focal_y);
	
	PrintDebug("__ bbox=(%d,%d)..(%d,%d) total=%d\n",
		lo_x, lo_y, hi_x, hi_y, total);

	PrintDebug("__ focal location: ");
	the_world->Loc(focal_x, focal_y).DebugDump();
}

//------------------------------------------------------------------------

namespace area_build
{

const char *NameForEnv(char env)
{
	switch (env)
	{
		case ENV_EMPTY:    return "EMPTY";
		case ENV_VOID:     return "VOID";

		case ENV_Land:     return "Land";
		case ENV_Water:    return "Water";
		case ENV_Building: return "Building";
		case ENV_Cave:     return "Cave";
	
		default: return ">>Error<<";
	}
}

int ExpandArea(area_c *A, short pseudo_area)
{
	SYS_ASSERT(pseudo_area >= TEMP_AREA);
	SYS_ASSERT(A->index < TEMP_AREA);

	int changes = 0;

	FOR_LOC_IN_AREA(x, y, loc, A)
	{
		if (loc.Void() || loc.area != A->index)
			continue;

		static const int dxs[4] = { +1, 0, -1, 0 };
		static const int dys[4] = { 0, +1, 0, -1 };

		for (int d = 0; d < 4; d++)
		{
			if (the_world->Outside(x+dxs[d], y+dys[d]))
				continue;

			location_c& next = the_world->Loc(x+dxs[d], y+dys[d]);

			if (next.Void())
				continue;

			if (next.area == pseudo_area)
			{
				next.area = A->index;

				A->AddPoint(x+dxs[d], y+dys[d]);

				changes++;
			}
		}
	}}

	return changes;
}

void DebugShowAreas()
{
	for (int y = the_world->h() - 1; y >= 0; y--)
	{
		for (int x = 0; x < the_world->w(); x++)
		{
			location_c& loc = the_world->Loc(x, y);

			PrintDebug("%c", loc.Void() ? '.' : loc.area >= TEMP_AREA ?
				('a' + (loc.area - 0*TEMP_AREA) % 26) : ('A' + loc.area % 26));
		}

		PrintDebug("\n");
	}

	PrintDebug("\n");
}

void InitialAreas()
{
	short real_index = 0;

	FOR_LOC(x, y, loc)
	{
		if (loc.Void() || loc.area < TEMP_AREA)
			continue;

		short pseudo_area = loc.area;
		loc.area = real_index;

		area_c *A = the_world->NewArea(real_index, x, y);
		real_index++;

		while (ExpandArea(A, pseudo_area) != 0)
		{ }

		PrintDebug("Area %2d @ (%2d,%2d)  %-8s *%3d  BBOX: (%2d,%2d) .. (%2d,%2d)\n",
			A->index, A->MidX(), A->MidY(),
			NameForEnv(loc.env), A->total,
			A->lo_x, A->lo_y, A->hi_x, A->hi_y);
	}}

	PrintDebug("\n");

	SYS_ASSERT(real_index > 0);
}

void MergeTwoAreas(area_c *DST, area_c *SRC)
{
	PrintDebug("Merging area %d into %d\n", SRC->index, DST->index);

	FOR_LOC_IN_AREA(x, y, loc, SRC)
	{
		the_world->CopyEnv(x, y, DST->focal_x, DST->focal_y);
		SYS_ASSERT(loc.area == DST->index);

		DST->AddPoint(x, y);
		SRC->total--;
	}}

	SYS_ASSERT(SRC->total == 0);
}


void PurgeArea(area_c *A)
{
//	PrintDebug("Purging area %d : size %d  bbox %dx%d\n",
//			A->index, A->total, A->hi_x - A->lo_x, A->hi_y - A->lo_y);

	// find a neighbour to merge with.  If none, make the space blank.

	area_c *best_ar = NULL;
	int best_match = -1;
	int best_size = -1;

	FOR_LOC_IN_AREA(x, y, loc, A)
	{
		static const int dxs[4] = { +1, 0, -1, 0 };
		static const int dys[4] = { 0, +1, 0, -1 };

		for (int d = 0; d < 4; d++)
		{
			if (the_world->Outside(x+dxs[d], y+dys[d]))
				continue;

			location_c& next = the_world->Loc(x+dxs[d], y+dys[d]);

			if (next.Void() || next.area == A->index)
				continue;

			area_c *B = the_world->Area(next.area);

			int match = next.MatchEnv(loc);

			// choose the best matching neighbour (smallest if same)
			if (! best_ar || match > best_match ||
				(match == best_match &&B->total < best_size))
			{
				best_ar = B;
				best_match = match;
				best_size = B->total;
			}
		}
	}}

	if (best_ar)
	{
		MergeTwoAreas(best_ar, A);
		return;
	}

	// replace this area with void space
	A->MakeVoid();
}

void PurgeSmallAreas()
{
	int small_size = 8 + the_world->dim() / 16;

	for (;;)
	{
		// find one of the smallest areas
		area_c *best_ar = NULL;
		int best_size = -1;

		FOR_AREA(A, a_idx)
		{
			if (A->total == 0)  // already done
				continue;

			if (A->total > small_size &&
				(A->hi_x - A->lo_x) > 2 && (A->hi_y - A->lo_y) > 2)
				continue;

			if (! best_ar || A->total < best_size)
			{
				best_ar = A;
				best_size = A->total;
			}
		}}

		if (! best_ar)
			break;

		PurgeArea(best_ar);
	}

	PrintDebug("\n");

	the_world->PurgeDeadAreas();
	PrintDebug("\n");
}

//------------------------------------------------------------------------

void FindNeighbours()
{
	FOR_AREA(A, a_idx)
	{
		A->DetermineNeighbours();
	}}

	PrintDebug("\n");

}

//------------------------------------------------------------------------

int BalanceOnePair(area_c *A, area_c *B)
{
	location_c& LA = the_world->Loc(A->focal_x, A->focal_y);
	location_c& LB = the_world->Loc(B->focal_x, B->focal_y);

	SYS_ASSERT(! LA.Void());
	SYS_ASSERT(! LB.Void());

#if 0
PrintDebug("### A=%d env=%d ht=%d..%d  |  B=%d env=%d ht=%d..%d\n",
A->index, LA.env, A->floor_h, A->ceil_h,
B->index, LB.env, B->floor_h, B->ceil_h);
#endif

	// general rule here: we can widen area A (lower floor or raise
	// ceiling) or we can narrow B (raise floor or lower ceiling).

	int do_ceil  = 0; // value == 2 forces it to area A
	int do_floor = 0; //

	if (LA.Outdoor() && LB.Outdoor() && A->ceil_h < B->ceil_h)
		do_ceil = 1;

	if (LA.Outdoor() && LB.Indoor() && A->ceil_h <= B->ceil_h)
		do_ceil = 1;
	
	if (LA.env == ENV_Water && LB.env != ENV_Water && A->floor_h > B->floor_h)
		do_floor = 1;

#if 1  // QUAKE and CUBE need this
	if (LA.env == ENV_Water && LB.env == ENV_Water && A->floor_h > B->floor_h)
		do_floor = 1;
#endif

	if (LA.env == ENV_Cave && LB.env == ENV_Cave)
	{
		if (A->floor_h == B->floor_h)
			do_floor = 1;
		else if (A->ceil_h == B->ceil_h)
			do_ceil = 1;
	}

	if (A->ceil_h <= A->floor_h+1)
	{
		if (RandomBool())
			do_ceil = 2;
		else
			do_floor = 2;
	}

	// apply results of the tests

	if (do_ceil)
	{
		if (do_ceil == 2 || RandomPerc(66))
			A->ceil_h ++;
		else
			B->ceil_h -= RandomPerc(25) ? 2 : 1;
	}

	if (do_floor)
	{
		if (do_floor == 2 || RandomPerc(66))
			A->floor_h --;
		else
			B->floor_h += RandomPerc(25) ? 2 : 1;
	}

#if 0
PrintDebug("--> do_ceil %d  do_floor %d\n", do_ceil, do_floor);
PrintDebug("--> A=%d env=%d ht=%d..%d  |  B=%d env=%d ht=%d..%d\n",
A->index, LA.env, A->floor_h, A->ceil_h,
B->index, LB.env, B->floor_h, B->ceil_h);
#endif

	return do_ceil + do_floor;
}

int BalancePass()
{
	int result = 0;

	int a_offset = RandomIndex(1024);

	// loop over each area and balance it with a single neighbour
	// chosen at random.  We start at a random area (IDEALLY we
	// would use a randomly-shuffled ordering).

	for (int ar_idx = 0; ar_idx < the_world->NumAreas(); ar_idx++)
	{
		int real_ar = (ar_idx + a_offset) % the_world->NumAreas();

		area_c *A = the_world->Area(real_ar);

		if (!A || A->NumNeighbours() == 0)
			continue;

		int nb_idx = RandomIndex(A->NumNeighbours());

		area_c *B = A->neighbours[nb_idx].ptr;
		SYS_ASSERT(B);

		result += BalanceOnePair(A, B);
	}

	return result;
}

void BalanceAreas()
{
	// set initial floor/ceiling heights
	FOR_AREA(A, a_idx)
	{
		A->floor_h = RandomRange(-4,+4);
		A->ceil_h  = A->floor_h + RandomRange(2,4);
	}}

	int pass_count = the_world->dim() + 160;

	for (int loop = 0; loop < pass_count; loop++)
	{
		int score = BalancePass();

		if ((loop % 10) == 0)
			PrintDebug("BalanceArea: loop %d score %d\n", loop, score);
	}

	// update map info
	FOR_LOC(x, y, loc)
	{
		if (loc.Void())
			continue;

		area_c *A = the_world->Area(loc.area);
		SYS_ASSERT(A);

		loc.floor_h = A->floor_h;
		loc.ceil_h  = A->ceil_h;
	}}

	PrintDebug("\n");
}

//------------------------------------------------------------------------
//  PUBLIC INTERFACE
//------------------------------------------------------------------------

void CreateAreas()
{
	InitialAreas();
	PurgeSmallAreas();
	FindNeighbours();
	BalanceAreas();
}

} // namespace area_build

