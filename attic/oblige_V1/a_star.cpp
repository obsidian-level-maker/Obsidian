//----------------------------------------------------------------------------
//  A* Search Algorithm
//----------------------------------------------------------------------------
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
//----------------------------------------------------------------------------

#include "defs.h"

namespace astar_search
{

priority_heap_c *ar_heap = NULL;


int Compute_G(area_c *A, area_c *B, bool is_teleport)
{
	if (is_teleport)
	{
		return 200;
	}

	int score = A->RoughDist(B) * 10;

	if (A->floor_h >= B->ceil_h || B->floor_h >= A->ceil_h)
		score += 305;
	else if (A->floor_h < B->floor_h-1)
		score += 185;
	else if (A->floor_h == B->floor_h-1)
		score += 105;

	if (A->Focal().env != B->Focal().env)
		score += 32;

	if (A->Focal().env == ENV_Water || B->Focal().env == ENV_Water)
		score += 36;

	return score;
}

int Compute_H(area_c *E, area_c *A)
{
	return E->RoughDist(A) * 10;
}

void CheckOneJoin(area_c *E, area_c *A, area_c *B, bool is_teleport)
{
	if (B->star.IsClosed())
		return;

	int G_score = Compute_G(A, B, is_teleport);

	if (G_score < 0)  // impassable
		return;

	// compute total distance for path
	G_score += A->star.G_score;

	if (! ar_heap->IsMapped(B->index))
	{
		B->star.Open(A->index, G_score, Compute_H(E, B));
		ar_heap->Insert(B->index, B->star.F_score());
	}
	else if (G_score < B->star.G_score)
	{
		B->star.Improve(A->index, G_score);
		ar_heap->Change(B->index, B->star.F_score());
	}
}

//----------------------------------------------------------------------------
//  PUBLIC INTERFACE
//----------------------------------------------------------------------------

//
// AST_FindStagePath
//
// Find the best path from the START area (S) to the END area (E).
// Only considers areas within a single stage.
//
// When the AST_Remember flag is set, the graph_idx value in each
// area_c will record the path status: 1 when on path, 0 when off.
//
// Returns -1 when no path exists, otherwise the distance score
// (roughly 10 * number of blocks, but includes various penalties).
//
int FindStagePath(area_c *S, area_c *E, int flags)
{
	SYS_ASSERT(S->stage >= 0);
	SYS_ASSERT(S->stage == E->stage);

	if (! ar_heap)
		ar_heap = new priority_heap_c(the_world->NumAreas());

	ar_heap->Clear();

	FOR_AREA_IN_STAGE(A, a_idx, S->stage)
	{
		A->star.Reset();

		if (flags & AST_Remember)
			A->graph_idx = 0;
	}}

	PrintDebug("Searching Path: area %d -> %d\n", S->index, E->index);

	S->star.Open(astar_info_c::PAR_NONE, 0, Compute_H(E, S));
	ar_heap->Insert(S->index, S->star.F_score());

	int result = -1;

	// iterate until target found or all avenues are exhausted
	for (;;)
	{
		if (ar_heap->IsEmpty())
		{
			PrintDebug("NO PATH FOUND !\n\n");
			return -1;
		}

		area_c *cur = the_world->Area(ar_heap->RemoveHead());
		SYS_ASSERT(cur);

//		PrintDebug("  Visiting %2d : (%2d, %2d) score %d\n", cur->index,
//				cur->MidX(), cur->MidY(), cur->star.F_score());

		cur->star.Close();

		if (cur == E)
		{
			result = cur->star.F_score();
			PrintDebug("PATH Found: score %d\n", result);
			break;
		}

		if (cur->teleport)
		{
			CheckOneJoin(E, cur, cur->teleport, true);
		}

		FOR_NEIGHBOUR_IN_AREA(back, N, nb_idx, cur)
		{
			if (back->stage != S->stage)
				continue;

			CheckOneJoin(E, cur, back, false);
		}}
	}

	if (flags & AST_Remember)
	{
//		PrintDebug("Rememering path:\n");

		// loop backwards from END node to START node
		area_c *cur = E;

		for (;;)
		{
//			PrintDebug("|  Area %d\n", cur->index);

			cur->graph_idx = 1;

			if (cur->star.parent == astar_info_c::PAR_NONE)
				break;

			cur = the_world->Area(cur->star.parent);
		}
	}

	return result;
}


}  // namespace astar_search
