//------------------------------------------------------------------------
//  PATHS
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


//!!!!!! FIXME !!!!!!
#define level_stuff  level_doom


namespace room_build
{

#if 0  // OLD CRAP
void BlockAreaBoundary(area_c *A, area_c *B, char want_stru)
{
	location_c& LA = the_world->Loc(A->focal_x, A->focal_y);
	location_c& LB = the_world->Loc(B->focal_x, B->focal_y);

	if ((LB.Outdoor() && LA.Indoor()) ||
		false) ///// !!!!!  (LA.Indoor() && LB.Indoor() && A->total < B->total))
	{
		BlockAreaBoundary(B, A, want_stru);
		return;
	}

#if 0
	char want_stru = STRU_Railing;
	if (LA.Indoor() && RandomBool())
		want_stru = STRU_Wall;
#endif

	for (int y = A->lo_y; y <= A->hi_y; y++)
	for (int x = A->lo_x; x <= A->hi_x; x++)
	for (int d = 0; d < 4; d++)
	{
		int dxs[4] = { +1, -1, 0, 0 };
		int dys[4] = { 0, 0, +1, -1 };

		int s_dirs[4] = { LOCDIR_W, LOCDIR_E, LOCDIR_S, LOCDIR_N };

		if (the_world->Outside(x+dxs[d], y+dys[d]))
			continue;

		location_c& TA = the_world->Loc(x, y);
		location_c& TB = the_world->Loc(x+dxs[d], y+dys[d]);

		if (TA.Void() || TB.Void())
			continue;

		if (TA.area != A->index || TB.area != B->index)
			continue;
		
		if (TA.stru == STRU_Railing || TA.stru == STRU_Railing2)
		{
			TA.s_dir |= s_dirs[d];
			continue;
		}

		if (TA.stru)  //!!! FIXME: missing railing!!
		{
			PrintDebug("WARNING: cannot block at (%d,%d) : stru %d\n", x, y, TA.stru);
			continue;
		}

		char stru = want_stru;

		// check that putting a solid wall (or window) is OK
		if (stru != STRU_Railing && stru != STRU_Railing2)
		{
			// check behind the current square
			if (the_world->Inside(x-dxs[d],y-dys[d]))
			{
				location_c& TC = the_world->Loc(x-dxs[d], y-dys[d]);

				if (TC.Void() || TC.area != TA.area || TC.stru)
					stru = STRU_Railing2;
			}

			// check the sides
			for (int side = 0; side < 2; side++)
			{
				int sdx = dys[d] * (side ? -1 : 1);
				int sdy = dxs[d] * (side ? -1 : 1);

				int cdx = sdx - dxs[d];
				int cdy = sdy - dys[d];

				if (the_world->Inside(x+sdx, y+sdy) &&
				    the_world->Inside(x+cdx, y+cdy))
				{
					location_c& TS = the_world->Loc(x+sdx, y+sdy);
					location_c& TC = the_world->Loc(x+cdx, y+cdy);

					if (TC.Void() || TC.area != TA.area || TC.stru)
						stru = STRU_Railing2;
				}
			}
		}

		TA.stru  = stru;
		TA.s_dir = s_dirs[d];
	}
}

void AddBoundaryDoor(area_c *A, area_c *B)
{
if (A->island != B->island)  //!!!! REMOVE SOON (SHIT)
return;

	location_c& LA = the_world->Loc(A->focal_x, A->focal_y);
	location_c& LB = the_world->Loc(B->focal_x, B->focal_y);

	if ((LB.Outdoor() && LA.Indoor()) ||
		false) ///// !!!!!  (LA.Indoor() && LB.Indoor() && A->total < B->total))
	{
		AddBoundaryDoor(B, A);
		return;
	}

	// choose a random location
	int lx, ly;
	int dx, dy;

	int loop;
	for (loop = 0; loop < 100000; loop++)  // FIXME !!!! CRAP
	{
		A->RandomLoc(&lx, &ly);

		if (the_world->Loc(lx, ly).stru != 0)
			continue;

		int dxs[4] = { -1, +1, 0, 0 };
		int dys[4] = { 0, 0, -1, +1 };

		int d;
		for (d = 0; d < 4; d++)
		{
			dx = dxs[d];
			dy = dys[d];

			if (the_world->Outside(lx+dx, ly+dy))
				continue;

			location_c& loc = the_world->Loc(lx+dx, ly+dy);

			if (loc.Void() || loc.stru != 0)
				continue;

			if (loc.area == B->index)
				break;
		}

		if (d != 4)
			break;
	}

	if (loop == 100000)
	{
		PrintDebug("__ FAILED TO MAKE DOOR %d -> %d\n", A->index, B->index);
		return;
	}

	PrintDebug("__ boundary door from %d -> %d put at (%d,%d)\n",
		A->index, B->index, lx, ly);

	location_c& loc = the_world->Loc(lx, ly);

	loc.stru = STRU_Door;

	// determine key
	loc.s_act = the_world->Stage(MAX(A->stage, B->stage))->key;

	// close the door
	loc.floor_h = MIN(loc.floor_h, the_world->Loc(lx+dx,ly+dy).floor_h);
	loc.ceil_h = loc.floor_h;
}

void AddBoundaryLift(area_c *A, area_c *B)
{
if (A->island != B->island)  //!!!! REMOVE SOON (SHIT)
return;

	if (A->floor_h < B->floor_h)
	{
		AddBoundaryLift(B, A);
		return;
	}

	SYS_ASSERT(A->floor_h > B->floor_h);

	// choose a random location
	int lx, ly;
	int dx, dy;

	int loop;
	for (loop = 0; loop < 100000; loop++)  // FIXME !!!! CRAP
	{
		A->RandomLoc(&lx, &ly);

		if (the_world->Loc(lx, ly).stru != 0)
			continue;

		int dxs[4] = { -1, +1, 0, 0 };
		int dys[4] = { 0, 0, -1, +1 };

		int d;
		for (d = 0; d < 4; d++)
		{
			dx = dxs[d];
			dy = dys[d];

			if (the_world->Outside(lx+dx, ly+dy))
				continue;

			location_c& loc = the_world->Loc(lx+dx, ly+dy);

			if (loc.Void() || loc.stru != 0)
				continue;

			if (loc.area == B->index)
				break;
		}

		if (d != 4)
			break;
	}

	if (loop == 100000)
	{
		PrintDebug("__ FAILED TO MAKE LIFT %d -> %d\n", A->index, B->index);
		return;
	}

	PrintDebug("__ boundary lift from %d -> %d put at (%d,%d)\n",
		A->index, B->index, lx, ly);

	the_world->Loc(lx, ly).stru = STRU_Lift;
}


void SolidifyGlobalPath()
{
	for (int st_idx = 1; st_idx < the_world->NumStages(); st_idx++)
	{
		stage_c *st = the_world->Stage(st_idx);

//!!!!		AddBoundaryDoor(the_world->Area(st->N), the_world->Area(st->S));
	}

	FOR_AREA(A, ar_idx)
	{
		if (A->stage < 0)
			continue;

		FOR_NEIGHBOUR_IN_AREA(B, N, nb_idx, A);
		{
			if (B->stage < 0)
				continue;

			if (A->stage >= B->stage)
				continue;

			if (A->floor_h >= B->floor_h && A->floor_h < B->ceil_h)
				BlockAreaBoundary(A, B, STRU_Railing);
		}}
	}}
}

void SolidifyLocalPaths()
{
	FOR_AREA(A, ar_idx)
	{
		if (A->stage < 0)
			continue;

		FOR_NEIGHBOUR_IN_AREA(B, N, nb_idx, A);
		{
			if (B->stage != A->stage)
				continue;

			if (A->index >= B->index)
				continue;

			if (N->cull_perc)
			{
				if (A->floor_h < B->ceil_h && B->floor_h < A->ceil_h)
					BlockAreaBoundary(A, B, STRU_Railing2);
			}
			else
			{
				if (A->floor_h != B->floor_h)
					AddBoundaryLift(A, B);
			}
		}}
	}}
}
#endif

//------------------------------------------------------------------------

void AddStairs(area_c *A, area_c *B)
{
	for (int loop = 0; loop < 20000; loop++)
	{
		int x, y;
		A->RandomLoc(&x, &y);

		location_c& loc = the_world->Loc(x, y);

		if (loc.stru != 0 && loc.stru != STRU_Tunnel)
			continue;

		int dxs[4] = { -1, +1, 0, 0 };
		int dys[4] = { 0, 0, -1, +1 };
		int dld[4] = { LOCDIR_W, LOCDIR_E, LOCDIR_S, LOCDIR_N };

		for (int d = 0; d < 4; d++)
		{
			if (the_world->Outside(x+dxs[d], y+dys[d]))
				continue;

			location_c& other = the_world->Loc(x+dxs[d], y+dys[d]);

			if (other.Void() || other.stru == STRU_Wall)
				continue;

			if (other.area != B->index)
				continue;
		
			if (other.stru != 0 && other.stru != STRU_Tunnel)
				continue;

			loc.stru = STRU_Stairs;
			return;
		}	
	}

	FatalError("Failed to add stairs (%d -> %d)\n", A->index, B->index);
}

void AddLift(area_c *A, area_c *B)
{
	// FIXME
	for (int loop = 0; loop < 20000; loop++)
	{
		int x, y;
		A->RandomLoc(&x, &y);

		location_c& loc = the_world->Loc(x, y);

		if (loc.stru != 0 && loc.stru != STRU_Tunnel)
			continue;

		int dxs[4] = { -1, +1, 0, 0 };
		int dys[4] = { 0, 0, -1, +1 };
		int dld[4] = { LOCDIR_W, LOCDIR_E, LOCDIR_S, LOCDIR_N };

		for (int d = 0; d < 4; d++)
		{
			if (the_world->Outside(x+dxs[d], y+dys[d]))
				continue;

			location_c& other = the_world->Loc(x+dxs[d], y+dys[d]);

			if (other.Void() || other.stru == STRU_Wall)
				continue;

			if (other.area != B->index)
				continue;
		
			if (other.stru != 0 && other.stru != STRU_Tunnel)
				continue;

			loc.stru = STRU_Lift;

			// TESTING !!!!
			other.env = loc.env;
			other.mat = loc.mat;
			other.area = loc.area;
			other.stru = STRU_Lift;
			other.floor_h = loc.floor_h;
			other.ceil_h = loc.ceil_h;
			return;
		}	
	}

	FatalError("Failed to add lift (%d -> %d)\n", A->index, B->index);
}

void AddDoor(area_c *A, area_c *B)
{

	// FIXME
	for (int loop = 0; loop < 20000; loop++)
	{
		int x, y;
		A->RandomLoc(&x, &y);

		location_c& loc = the_world->Loc(x, y);

		if (loc.stru != 0 && loc.stru != STRU_Tunnel)
			continue;

		int dxs[4] = { -1, +1, 0, 0 };
		int dys[4] = { 0, 0, -1, +1 };
		int dld[4] = { LOCDIR_W, LOCDIR_E, LOCDIR_S, LOCDIR_N };

		for (int d = 0; d < 4; d++)
		{
			if (the_world->Outside(x+dxs[d], y+dys[d]))
				continue;

			location_c& other = the_world->Loc(x+dxs[d], y+dys[d]);

			if (other.Void() || other.stru == STRU_Wall)
				continue;

			if (other.area != B->index)
				continue;

			if (other.stru != 0 && other.stru != STRU_Tunnel &&
				other.stru != STRU_Railing && other.stru != STRU_Railing2)
				continue;

			loc.stru = STRU_Door;
			other.stru = 0;
			return;
		}	
	}

	FatalError("Failed to add door (%d -> %d)\n", A->index, B->index);
}

void AddBars(area_c *A, area_c *B)
{
	// FIXME
	for (int loop = 0; loop < 20000; loop++)
	{
		int x, y;
		A->RandomLoc(&x, &y);

		location_c& loc = the_world->Loc(x, y);

		if (loc.stru != 0 && loc.stru != STRU_Tunnel)
			continue;

		int dxs[4] = { -1, +1, 0, 0 };
		int dys[4] = { 0, 0, -1, +1 };
		int dld[4] = { LOCDIR_W, LOCDIR_E, LOCDIR_S, LOCDIR_N };

		for (int d = 0; d < 4; d++)
		{
			if (the_world->Outside(x+dxs[d], y+dys[d]))
				continue;

			location_c& other = the_world->Loc(x+dxs[d], y+dys[d]);

			if (other.Void() || other.stru == STRU_Wall)
				continue;

			if (other.area != B->index)
				continue;
		
			if (other.stru != 0 && other.stru != STRU_Tunnel &&
				other.stru != STRU_Railing && other.stru != STRU_Railing2)
				continue;

			loc.stru = STRU_Bars;
			other.stru = 0;
			return;
		}	
	}

	FatalError("Failed to add bars (%d -> %d)\n", A->index, B->index);
}

void CreateConnections(area_c *A)
{
	FOR_NEIGHBOUR_IN_AREA(B, N, nb_idx, A)
	{
		if (! N->soft_link)
			continue;

		switch (N->soft_link)
		{
			case STRU_Stairs: AddStairs(A, B); break;
			case STRU_Lift:   AddLift(A, B); break;
			case STRU_Door:   AddDoor(A, B); break;
			case STRU_Bars:   AddBars(A, B); break;

			default:
				AssertFail("Bad soft link #%d (area %d -> %d)\n", N->soft_link,
					A->index, B->index);
				break;  /* NOT REACHED */
		}
	}}

#if 0	//!!!! TESTING
			int type = 2028;
			switch (N->soft_link)
			{
				case STRU_Lift: type = 41; break;
				case STRU_Door: type = 42; break;
				case STRU_Bars: type = 27; break;
				default: break;
			}
			level_stuff::AddThing(x, y, type);
		}
#endif
}

void SolidifyBoundary(area_c *A)
{
	FOR_LOC_IN_AREA(x, y, loc, A)
	{
		if (loc.stru != 0)
			continue;

		static int dxs[4] = { -1, +1, 0, 0 };
		static int dys[4] = { 0, 0, -1, +1 };
		static int dld[4] = { LOCDIR_W, LOCDIR_E, LOCDIR_S, LOCDIR_N };

		for (int d = 0; d < 4; d++)
		{
			if (the_world->Outside(x+dxs[d], y+dys[d]))
				continue;

			location_c& other = the_world->Loc(x+dxs[d], y+dys[d]);

			if (other.Void() || other.stru == STRU_Wall)
				continue;

			if (other.area == loc.area)
				continue;

			area_c *B = other.Area();
			neighbour_info_c *N = NULL;

			FOR_NEIGHBOUR_IN_AREA(B2, N2, nb_idx, A)
			{
				if (B == B2)
				{
					N = N2;
					break;
				}
			}}

			SYS_ASSERT(N);

			if (N->hard_link == 0)
				continue;

			if (N->hard_link == STRU_Railing)
			{
				if (! loc.stru || loc.stru == STRU_Railing2)
				{
					loc.stru = STRU_Railing;
				}
				loc.s_dir |= dld[d];
			}
			else if (N->hard_link == STRU_Railing2)
			{
				if (! loc.stru)
				{
					loc.stru = STRU_Railing2;
				}
				loc.s_dir |= dld[d];
			}
			else
			{
				loc.stru = N->hard_link;
			}

#if 0
			// natural barrier ?
			if (other.floor_h >= loc.ceil_h || loc.floor_h >= other.ceil_h)
				continue;

			if (other.stru == STRU_Tunnel)
				continue;

			int loc_stage = loc.Area()->stage;
			int oth_stage = other.Area()->stage;

			if (oth_stage < 0)
				continue;

			if ((loc_stage < oth_stage && loc.floor_h < other.floor_h) ||
			    (loc_stage > oth_stage && loc.floor_h > other.floor_h))
				continue;

			if (loc_stage != oth_stage)
			{
				loc.stru = STRU_Railing;
				loc.s_dir |= dld[d];
				continue;
			}

			bool allow = false;

			if (other.area > loc.area) /// FIXME: Arrggghhh!!!
			{
				FOR_NEIGHBOUR_IN_AREA(B, N, nb_idx, A)
				{
					if (B == other.Area())
					{
						allow = (N->cull_perc == 0);
						break;
					}
				}}
			}
			else
			{
				FOR_NEIGHBOUR_IN_AREA(B, N, nb_idx, other.Area())
				{
					if (B == loc.Area())
					{
						allow = (N->cull_perc == 0);
						break;
					}
				}}
			}

			if (allow)
				continue;

			if (loc.stru == 0)
				loc.stru = STRU_Railing2;

			loc.s_dir |= dld[d];
#endif
		}
	}}
}

//------------------------------------------------------------------------

void DecorateInterior(area_c *A)
{
	/// FIXME
}

//------------------------------------------------------------------------

void AddPlayers(area_c *A)
{
	stage_c *st = the_world->Stage(A->stage);

	if (st->index > 0 || st->S1.A != A)
		return;
fprintf(stderr, "ADD PLAYERS\n");

// FIXME: good algorithm!!!
	int x, y;
	A->RandomLoc(&x, &y);

	for (int p = 0; p < 4; p++)
	{
		level_stuff::AddThing(x+(p&1), y+p/2, p+1 /* PLAYER */);
	}
}

void AddSwitch(area_c *A, bool is_exit)
{
	int sx, sy;
	int sdir = LOCDIR_N; //!!!!

	// determine square to use (FIXME: good spot !!)
	for (int loop=0; loop < 400; loop++)
	{
		A->RandomLoc(&sx, &sy);

		location_c& loc = the_world->Loc(sx,sy);

		if (loc.stru != 0)
			continue;
	}

	location_c& loc = the_world->Loc(sx,sy);

	loc.stru = STRU_Switch;
	loc.s_dir = sdir;
	loc.s_act = is_exit ? LOCACT_EXIT : 0;
}

void AddExit(area_c *A)
{
	stage_c *st = the_world->Stage(A->stage);

	if (st->index != the_world->NumStages()-1)
		return;
	
	if (A != st->L1.A)
		return;

	AddSwitch(A, true);
}

void AddKey(area_c *A)
{
	stage_c *st = the_world->Stage(A->stage);

	if (st->K != A)
		return;

PrintDebug("!!! DOING KEY FOR AREA %d\n", A->index);

if(st->index + 1 >= the_world->NumStages()) return; //!!! ???
	SYS_ASSERT(st->index + 1 < the_world->NumStages());

	short type;

	switch (the_world->Stage(st->index+1)->key)
	{
		case 1:  type = 40; /*  5 */ break; /* BLUE KEY */
		case 2:  type = 38; /* 13 */ break; /* RED KEY */
		case 3:  type = 39; /*  6 */ break; /* YELLOW KEY */

		default: AddSwitch(A, false); return;
	}

// FIXME: choose good spot !!
	int x, y;
	A->RandomLoc(&x, &y);

	level_stuff::AddThing(x, y, type);
}

void AddMonsters(area_c *A)
{
	/// FIXME
}

void AddItems(area_c *A)
{
	/// FIXME
}

void SolidifyRoom(area_c *A)
{
	CreateConnections(A);
	SolidifyBoundary(A);

	DecorateInterior(A);

	AddPlayers(A);
	AddKey(A);
	AddExit(A);

	AddMonsters(A);
	AddItems(A);
}

//------------------------------------------------------------------------
//  PUBLIC INTERFACE
//------------------------------------------------------------------------

void CreateRooms()
{
fprintf(stderr, "CREATE_ROOMS\n");
	FOR_AREA(A, a_idx)
	{
		if (A->stage < 0)
			continue;

		SolidifyRoom(A);
	}}
}

} // namespace room_build
