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


namespace path_build
{

///---// returns area index for neighbour in given stage, or -1 if none.
///---int NextDoorAreaWithStage(int src_ar, int stage)
///---{
///---	area_c *A = the_world->Area(src_ar);
///---	SYS_ASSERT(A && A->stage >= 0);
///---
///---	// FIXME: randomize and/or choose best via heuristic (see above)
///---
///---	int nb_offset = RandomRange(0, 100);
///---	for (int nb_idx = 0; nb_idx < A->NumNeighbours(); nb_idx++)
///---	{
///---		int real_nb = (nb_idx + nb_offset) % A->NumNeighbours();
///---
///---		area_c *B = A->neighbours[real_nb].ptr;
///---		SYS_ASSERT(B);
///---
///---		if (B->stage == stage)
///---			return B->index;
///---	}
///---
///---	return -1;
///---}

int GatewayScore(area_c *A, area_c *B, int contacts)
{
	int score = 0;

	location_c& LA = A->Focal();
	location_c& LB = B->Focal();

	if (A->floor_h >= B->ceil_h || B->floor_h >= A->ceil_h)
		score -= 30;
	else if (A->floor_h == B->floor_h)
		score += 100;
	else if (A->floor_h < B->floor_h)
		score += 50;
	else
		score += 33;

	if (LA.env == ENV_Building || LB.env == ENV_Building)
		score += 80;
	else if (LA.env == ENV_Cave || LB.env == ENV_Cave)
		score += 44;
	else if (LA.env == ENV_Land || LB.env == ENV_Land)
		score += 20;

	int a_nbs = A->WalkableNeighbours();
	int b_nbs = B->WalkableNeighbours();

	score -= MIN(5, a_nbs) * 2;
	score += MIN(5, b_nbs) * 3;

	return score;
}

void LinkStart(stage_c *st, stage_c *prev, area_c *S, area_c *N, bool teleport)
{
	if (! st->S1.A)
		st->S1.Set(S, N, teleport);
	else if (! st->S2.A)
		st->S2.Set(S, N, teleport);
	else
		AssertFail("LinkStart: no available start slot in stage %d\n", st->index);

	if (! prev->L1.A)
		prev->L1.Set(N, S, teleport);
	else if (! prev->L2.A)
		prev->L2.Set(N, S, teleport);
	else
		AssertFail("LinkStart: no available leave slot in stage %d\n", st->index);
}

bool FindStartAreaToStage(stage_c *st, stage_c *prev)
{
	PrintDebug("Looking for stage connection %d -> %d\n", prev->index, st->index);

	area_c *best = NULL;
	int best_nb  = -1;
	int best_score = -999;

	FOR_AREA_IN_STAGE(A, a_idx, st->index)
	{
		FOR_NEIGHBOUR_IN_AREA(B, N, nb_idx, A)
		{
			if (B->stage != prev->index)
				continue;

			int score = GatewayScore(A, B, N->contacts);

			if (B == prev->L1.A)
				score -= 12;

			if (prev->L1.A && B->floor_h != prev->L1.A->floor_h)
				score += 5;

			PrintDebug("__ gateway: area %d -> %d  score %d\n", A->index,
					B->index, score);

			if (score > best_score)
			{
				best = A;
				best_nb = nb_idx;
				best_score = score;
			}
		}}
	}}

	if (! best)
	{
		PrintDebug("None found!\n\n");
		return false;
	}

	// update the linkage info...
	LinkStart(st, prev, best, best->neighbours[best_nb].ptr, false);

	PrintDebug("Best was area %d -> %d : score %d\n\n", best->index,
				best->neighbours[best_nb].ptr->index, best_score);
	return true;
}

area_c *FindStageLinkTeleport(stage_c *st)
{
	area_c *best = NULL;
	int best_score = -999;

	FOR_AREA_IN_STAGE(A, a_idx, st->index)
	{
		int score = 0;

		if (! A->teleport)  // already taken ?
			score += 100;

		// FIXME: better evaluate area for teleport

		if (score > best_score)
		{
			best = A;
			best_score = score;
		}
	}}

	if (! best)
		FatalError("Unable to find Teleport area for stage %d\n", st->index);

	return best;
}

void DetermineStartArea(stage_c *st)
{
	// determine previous stage number (usually -1, maybe -2)
	// set them up in a list of choices.

	int prev_stages[MAX_STAGES];
	int num_prev = st->index;
	int i;

	for (i = 0; i < num_prev; i++)
		prev_stages[i] = st->index - 1 - i;

	if (num_prev >= 2 && RandomPerc(25))
	{
		int temp = prev_stages[0];
		prev_stages[0] = prev_stages[1];
		prev_stages[1] = temp;
	}
	else if (num_prev >= 3 && RandomPerc(3))
	{
		RandomShuffle(prev_stages, num_prev);
	}

	// now iterate over the choices, finding a connection between
	// the stages.

	for (i = 0; i < num_prev; i++)
	{
		stage_c *prev = the_world->Stage(prev_stages[i]);

		if (prev->L1.A && prev->L2.A)
			continue;

		if (FindStartAreaToStage(st, prev))
			break;  // OK!
	}

	if (i >= num_prev)
	{
		PrintDebug("Unable to determine start area for stage %d\n", st->index);

		// create a teleport connection
		stage_c *prev = the_world->Stage(st->index - 1);

		LinkStart(st, prev, FindStageLinkTeleport(st),
							FindStageLinkTeleport(prev), true);

		// FIXME: update the teleport link in the areas ???
	}

	PrintDebug("\n");
}

area_c *FindFarAwayArea(stage_c *st, area_c *hated)
{
	PrintDebug("FindFarAwayArea for stage %d\n", st->index);

	area_c *best = hated;
	int best_score = -999;

	FOR_AREA_IN_STAGE(A, a_idx, st->index)
	{
		if (A == hated)
			continue;

		if (A->IsTunnel())
			continue;

		int score = hated ? (A->RoughDist(hated) * 10) : 0;

		int nbs = A->WalkableNeighbours();

		score -= MIN(4, nbs) * 18;  // prefer leafy areas

		if (A->Focal().env == ENV_Water)  // prefer land
			score -= 23;

		if (A->TouchesWorldEdge())  // prefer area at edge of map
			score += 14;

		score += RandomRange(0, 20);

		PrintDebug("___ area %d  score %d  (dist %d)\n", A->index, score,
			hated ? A->RoughDist(hated) : -1);

		if (score > best_score)
		{
			best = A;
			best_score = score;
		}
	}}

	PrintDebug("Best was area %d : score %d\n", best->index, best_score);

	return best;
}

void DetermineLevelEntry()
{
	stage_c *st = the_world->Stage(0);

	SYS_ASSERT(! st->S1.A);

	st->S1.A = FindFarAwayArea(st, st->L1.A);
	st->S1.N = NULL;
}

void DetermineLevelExit()
{
	stage_c *st = the_world->Stage(the_world->NumStages()-1);

	SYS_ASSERT(! st->L1.A);

	st->L1.A = FindFarAwayArea(st, st->S1.A);
	st->L1.N = NULL;
}

int EvaluateKeyArea(stage_c *st, area_c *K)
{
	int score = 0;

	// don't want key in the Start or Leave area
	if (K == st->L1.A || K == st->S1.A)
		return -400 + K->dim();

	// don't want key on the path from S -> L
	if (K->graph_idx == 0)
		score += 200;

	if (! K->IsTunnel())  // prefer no tunnels
		score += 103;

	if (K->island != st->S1.A->island)
		score += 40;
	if (st->L1.A && K->island != st->L1.A->island)
		score += 20;

	int nbs = K->WalkableNeighbours();

	score -= MIN(5, nbs) * 5;  // prefer leafy

	if (K->Focal().env != ENV_Water)
		score += 12;

	// geographical test: we want L between S and K
	if (st->L1.A)
	{
		int K_mx = K->MidX();
		int K_my = K->MidY();

		int S_mx = st->S1.A->MidX();
		int S_my = st->S1.A->MidY();

		int L_mx = st->L1.A->MidX();
		int L_my = st->L1.A->MidY();

		if ((S_mx < L_mx && L_mx < K_mx) || (S_mx > L_mx && L_mx > K_mx))
			score += 26;
		else if ((L_mx < S_mx && S_mx < K_mx) || (L_mx > S_mx && S_mx > K_mx))
			score += 8;

		if ((S_my < L_my && L_my < K_my) || (S_my > L_my && L_my > K_my))
			score += 26;
		else if ((L_my < S_my && S_my < K_my) || (L_my > S_my && S_my > K_my))
			score += 8;
	}

	score += 36 * K->RoughDist(st->S1.A) / the_world->dim();

	if (st->L1.A)
		score += 36 * K->RoughDist(st->L1.A) / the_world->dim();

	return score;
}

void DetermineKeyArea(stage_c *st)
{
	PrintDebug("DetermineKeyArea for stage %d\n", st->index);

	area_c *best = NULL;
	int best_score = -999;

	FOR_AREA_IN_STAGE(A, a_idx, st->index)
	{
		int score = EvaluateKeyArea(st, A);

//      PrintDebug("__ Key area: trying %d:%d  score %d  best %d\n",
//				st->index, A->index, score, best_score);

		if (score > best_score)
		{
			best = A;
			best_score = score;
		}
	}}

	st->K = best;
	SYS_ASSERT(st->K);

	PrintDebug("Best key area was %d, score %d\n\n", st->K->index, best_score);
}

bool FindAuxiliaryStartArea(stage_c *st, stage_c *prev)
{
	PrintDebug("Looking for auxiliary stage connection %d -> %d\n",
			prev->index, st->index);

	area_c *best = NULL;
	int best_nb  = -1;
	int best_score = -999;

	FOR_AREA_IN_STAGE(A, a_idx, st->index)
	{
		// never same as leave area or key area
		if (A == st->L1.A || A == st->K)
			continue;

		FOR_NEIGHBOUR_IN_AREA(B, N, nb_idx, A)
		{
			if (B->stage != prev->index)
				continue;

			int score = GatewayScore(A, B, N->contacts);

			// compatibility check (with existing start)
			if (st->key > 0)
			{
				char A_env = A->Focal().env;
				char B_env = B->Focal().env;

				if (A_env == ENV_Building || B_env == ENV_Building)
					score += 20;
				else if (A_env == ENV_Cave || B_env == ENV_Cave)
					score -= RandomPerc(30) ? 5 : 500;
				else
					score -= 500;
			}

			if (score < -40)
				continue;

			if (A->graph_idx)  // prefer S2 to be on S1->L1 path
				score += 24;

			if (B == prev->L1.A)
				score -= 10;

			score = (score + 125) / 4;
			SYS_ASSERT(0 <= score && score < 100);

			PrintDebug("__ auxiliary gateway: area %d -> %d  score %d\n", A->index,
					B->index, score);

			if (score > best_score)
			{
				best = A;
				best_nb = nb_idx;
				best_score = score;
			}
		}}
	}}

	if (! best)
	{
		PrintDebug("None found\n\n");
		return false;
	}

	PrintDebug("Best was area %d -> %d : score %d\n", best->index,
				best->neighbours[best_nb].ptr->index, best_score);

	SYS_ASSERT(0 <= best_score && best_score <= 100);

	if (RandomPerc(best_score))
	{
		// update the linkage info...
		LinkStart(st, prev, best, best->neighbours[best_nb].ptr, false);

		PrintDebug("Making the link.\n\n");
		return true;
	}

	PrintDebug("Ignoring the link.\n\n");
	return false;
}

void DetermineAuxStart(stage_c *st)
{
	SYS_ASSERT(st->S1.N);

	int highest_prev = st->S1.N->stage - 1;
	if (highest_prev < 0)
		return;

	int prev_stages[MAX_STAGES];
	int num_prev = highest_prev + 1;
	int i;

	for (i = 0; i < num_prev; i++)
		prev_stages[i] = highest_prev - i;

	if (num_prev >= 2)
		RandomShuffle(prev_stages, num_prev);

	for (i = 0; i < num_prev; i++)
	{
		stage_c *prev = the_world->Stage(prev_stages[i]);

		if (prev->L1.A && prev->L2.A)
			continue;

		if (FindAuxiliaryStartArea(st, prev))
			break;  // OK!
	}

	if (i >= num_prev)
	{
		PrintDebug("Unable to find auxiliary link for stage %d\n", st->index);
	}
}

///---int VisitAreaScore(stage_c *st, int ar_idx)
///---{
///---	stage_c *st = the_world->Stage(st_idx);
///---	area_c *A   = the_world->Area(ar_idx);
///---
///---	int score = RandomRange(0, the_world->dim() * 10) / 5;
///---
///---	if (st->S >= 0)
///---	{
///---		area_c *B = the_world->Area(st->S);
///---		SYS_ASSERT(B);
///---
///---		// FIXME: compute real path distance
///---		score += A->RoughDist(B) * 10;
///---	}
///---
///---	// FIXME: check LEAVE areas too
///---
///---	return score;
///---}

void AssignKeysToStages()
{
	int key_perc[MAX_STAGES];

	FOR_STAGE(st, st_idx)
	{
		area_c *SA = st->S1.A;
		area_c *NA = st->S1.N;

		key_perc[st_idx] = 0;

		if (! SA)  // skip first stage
			continue;

		SYS_ASSERT(NA);

		location_c& LS = SA->Focal();
		location_c& LN = NA->Focal();

		if (ABS(LS.floor_h - LN.floor_h) > 1)
			continue;

		key_perc[st_idx] = 5;

		if (LS.floor_h == LN.floor_h)
			key_perc[st_idx] += 40;

		if (LS.env == ENV_Building || LN.env == ENV_Building)
			key_perc[st_idx] = 45;
		else if (LS.env == ENV_Cave || LN.env == ENV_Cave)
			key_perc[st_idx] = 25;

// PrintDebug("___ Stage %d:  can have key %d%%\n", st_idx, key_perc[st_idx]);
	}}

	// shuffle key numbers (in case less than 3 are used)
	int key_list[3];
	RandomShuffle(key_list, 3, true /* fill */);

	// test percentages in a random order
	int try_order[MAX_STAGES];
	RandomShuffle(try_order, MAX_STAGES, true /* fill */);

	int k_idx = 0;

	for (int i = 0; (i < MAX_STAGES) && (k_idx < 3); i++)
	{
		int st_idx = try_order[i];

		if (st_idx < 1 || st_idx >= the_world->NumStages())
			continue;

		if (RandomPerc(key_perc[st_idx]))
		{
			the_world->Stage(st_idx)->key = 1 + key_list[k_idx];

			PrintDebug("Assigning key %d to stage %d\n", 1 + key_list[k_idx], st_idx);
			k_idx++;
		}
	}
}

#define INDEX_OF(X)  ((X) ? (X)->index : -1)
#define STAGE_OF(X)  ((X) ? (X)->stage : -1)

void DumpGlobalPath()
{
	FOR_STAGE(st, st_idx)
	{
		FOR_AREA_IN_STAGE(A, a_idx, st->index)
		{
			location_c& loc = A->Focal();

			PrintDebug("STAGE %d has AREA %2d: %s mat %d\n", st_idx, a_idx,
				area_build::NameForEnv(loc.env), loc.mat);
		}}

		PrintDebug("\n");
	}}

	PrintDebug("\n");

	FOR_STAGE(st, st_idx)
	{
		PrintDebug("Global path: S1 %2d < %2d:%+d   L1 %2d > %2d:%+d   "
				   "S2 %2d < %2d:%+d   L2 %2d > %2d:%+d   K %d\n",
			INDEX_OF(st->S1.A), INDEX_OF(st->S1.N), STAGE_OF(st->S1.N),
			INDEX_OF(st->L1.A), INDEX_OF(st->L1.N), STAGE_OF(st->L1.N),
			INDEX_OF(st->S2.A), INDEX_OF(st->S2.N), STAGE_OF(st->S2.N),
			INDEX_OF(st->L2.A), INDEX_OF(st->L2.N), STAGE_OF(st->L2.N),
			INDEX_OF(st->K));
	}}

	PrintDebug("\n");
}

#undef INDEX_OF
#undef STAGE_OF

void MakeGlobalPath()
{
	int p;
	int num_stages = the_world->NumStages();

	// step 1: assign START areas (and their associated LEAVE areas).
	for (p = 1; p < num_stages; p++)
	{
		DetermineStartArea(the_world->Stage(p));
	}

	AssignKeysToStages();

	// step 2: special handling for level ENTRY and EXIT
	DetermineLevelEntry();
	DetermineLevelExit();

	PrintDebug("\n");

	for (p = 0; p < num_stages; p++)
	{
		stage_c *st = the_world->Stage(p);

		SYS_ASSERT(st->S1.A);

		if (! st->L1.A)
			continue;

		astar_search::FindStagePath(st->S1.A, st->L1.A, AST_Remember);
	}

	PrintDebug("\n");

	// step 3: assign KEY areas
	for (p = 0; p < num_stages; p++)
	{
		DetermineKeyArea(the_world->Stage(p));
	}

	// step 4: assign AUXILLARY linkages
	for (p = 1; p < num_stages; p++)
	{
		DetermineAuxStart(the_world->Stage(p));
	}

	PrintDebug("\n");

	DumpGlobalPath();
}

//------------------------------------------------------------------------

bool TestGraphValid(stage_c *st)
{
	// Algorithm:
	//
	// 1. first set all 'graph_idx' fields to unique values.
	// 2. then perform passes doing a kind-of flood fill,
	//    loop until no changes.
	// 3. check if all graph_idx values are the same.

	FOR_AREA_IN_STAGE(A, a_idx, st->index)
	{
		A->graph_idx = a_idx;
	}}

	for (;;)
	{
		bool changes = false;

		FOR_AREA_IN_STAGE(A, a_idx, st->index)
		{
			FOR_NEIGHBOUR_IN_AREA(B, N, nb_idx, A)
			{
				if (B->stage != A->stage)
					continue;

				if (A->index >= B->index)  // ignore backward links
					continue;

				if (N->cull_perc <= 0 && A->graph_idx != B->graph_idx)
				{
					A->graph_idx = MIN(A->graph_idx, B->graph_idx);
					B->graph_idx = A->graph_idx;

					changes = true;
				}
			}}

			if (A->teleport && A->teleport->stage == A->stage &&
				A->index < A->teleport->index &&
				A->graph_idx != A->teleport->graph_idx)
			{
				A->graph_idx = MIN(A->graph_idx, A->teleport->graph_idx);
				A->teleport->graph_idx = A->graph_idx;

				changes = true;
			}
		}}

		if (! changes)
			break;
	}

	int got_val = -1;
	
	FOR_AREA_IN_STAGE(B, b_idx, st->index)
	{
		if (got_val < 0)
			got_val = B->graph_idx;
		else
			if (got_val != B->graph_idx)
				return false;
	}}

	return true;
}

bool TryPruneLink(area_c *A, neighbour_info_c *N, int cull_perc)
{
	// links only valid for forward, hence must "reverse it" if backward
	// FIXME: Arrrggghhhh !!
	if (A->index > N->ptr->index)
	{
		area_c *B = N->ptr;

		FOR_NEIGHBOUR_IN_AREA(A2, BN, nb_idx, B)
		{
			if (A->index == A2->index)
			{
				SYS_ASSERT(B->index < BN->ptr->index);

				return TryPruneLink(B, BN, cull_perc);
			}
		}}
		
		AssertFail("TryPruneLink: could not find reverse link (area %d -> %d)",
				A->index, N->ptr->index);
		return false; /* NOT REACHED */
	}

	/* SPECIAL CASE: marking the link as never-cullable */
	if (cull_perc == 0)
	{
		N->cull_perc = 0;
		return true;
	}

	SYS_ASSERT(N->cull_perc < 0);

	int old_cull = N->cull_perc;

	N->cull_perc = cull_perc;

	if (! TestGraphValid(the_world->Stage(A->stage)))
	{
		N->cull_perc = old_cull;
		return false;
	}

	PrintDebug("__ Pruned link: Area %d --> %d (cull %d)\n",
			A->index, N->ptr->index, cull_perc);
	return true;
}

void PruneKeyArea(stage_c *st)
{
	area_c *A = st->K;

	if (st->index == the_world->NumStages() - 1)
		A = st->L1.A;

if (! A)return; //!!!!!
	SYS_ASSERT(A);
	SYS_ASSERT(A->stage == st->index);

	FOR_NEIGHBOUR_IN_AREA(B, N, nb_idx, A)
	{
		if (B->stage != st->index)
			continue;

		//!!! FIXME: too simple (determine order by heuristic/random)
		TryPruneLink(A, N, 100);
	}}
}

area_c *FindCullableLink(stage_c *st, neighbour_info_c ** N, int *cull_perc)
{
	*N = 0;

	int best_score = -999;
	area_c *best_A = NULL;
	neighbour_info_c *best_N = NULL;
	int best_cull = -1;

	FOR_AREA_IN_STAGE(A, a_idx, st->index)
	{
		FOR_NEIGHBOUR_IN_AREA(B, N, nb_idx, A)
		{
			if (B->stage != A->stage)
				continue;

			if (A->index >= B->index)
				continue;

			if (N->cull_perc >= 0)
				continue;

			int score = RandomRange(0,100);  //!!!! EVALUATE LINK
			int cull = 80;                   //!!!!

			if (score > best_score)
			{
				best_score = score;
				best_A = A;
				best_N = N;
				best_cull = cull;
			}
		}}
	}}

	if (! best_A)
		PrintDebug("____ FindCullableLink: NONE\n");
	else
		PrintDebug("____ FindCullableLink: area %d -> %d  score %d  cull_perc %d%%\n",
				best_A->index, best_N->ptr->index, best_score, best_cull);

	*N = best_N;
	*cull_perc = best_cull;

	return best_A;
}

void PruneGraphForStage(stage_c *st)
{
	PrintDebug("Pruning graph for stage %d\n", st->index);

	// Algorithm:
	//
	// 	1. prune Key area
	//
	// 	2. loop: find highest score link, try to prune it.
	// 	         if cannot be pruned, mark it as 0% culled,
	// 			 else give it score (1% to 99%)
	// 			 continue until no more links.
	//
	// 	3. perform discretization pass (set cull to 0 or 100).

	SYS_ASSERT(TestGraphValid(st));

	PruneKeyArea(st);
	PrintDebug("\n");

	/* ----- prune pass ----- */

	for (;;)
	{
		area_c *A;
		neighbour_info_c *N;
		int cull_perc;

		A = FindCullableLink(st, &N, &cull_perc);
		
		if (! A)
			break;

		if (! TryPruneLink(A, N, cull_perc))
		{
			TryPruneLink(A, N, 0);  // mark as never cullable
		}
	}

	PrintDebug("\n");
}

#define CL_SWAPEM()  \
{  \
	area_c *tmp_A = A; A = B; B = tmp_A;  \
	neighbour_info_c *tmp_N = NA; NA = NB; NB = tmp_N;  \
}

void CreateLink(area_c *A, neighbour_info_c *NA, area_c *B, neighbour_info_c *NB)
{
	if (! NA)
	{
		FOR_NEIGHBOUR_IN_AREA(B2, N2, cnb, A)
		{
			if (B == B2)
			{
				NA = N2;
				break;
			}
		}}
	}

	if (! NB)
	{
		FOR_NEIGHBOUR_IN_AREA(A2, N2, cnb, B)
		{
			if (A == A2)
			{
				NB = N2;
				break;
			}
		}}
	}

	SYS_ASSERT(NA && NB);

	location_c& LA = A->Focal();
	location_c& LB = B->Focal();

	// DETERMINE HARD-LINK

	if (LB.env == ENV_Building && LA.env != ENV_Building)
	{
		CL_SWAPEM();
	}

	if (A->stage != B->stage)
	{
		if ((A->stage < B->stage && LA.floor_h < LB.floor_h) ||
			(A->stage > B->stage && LA.floor_h > LB.floor_h))
		{ }
		else
			NA->hard_link = STRU_Railing;
	}
	else if (NA->cull_perc > 0)
	{
		NA->hard_link = STRU_Railing2;
	}

	// DETERMINE SOFT-LINK

	if (LB.env == ENV_Building && LA.env != ENV_Building)
	{
		CL_SWAPEM();
	}

	if (A->stage != B->stage)
	{
		int next_stage = MAX(A->stage, B->stage);

		char key = the_world->Stage(next_stage)->key;

		if (key)
		{
			NA->soft_link = STRU_Door;
		}
		else
		{
			NA->soft_link = STRU_Bars;
		}
	}
	else if (NA->cull_perc == 0 && A->floor_h != B->floor_h)
	{
		if (A->floor_h > B->floor_h)
		{
			CL_SWAPEM();
		}

		if ((A->floor_h == B->floor_h-1 ||
			 (A->floor_h == B->floor_h-2 && RandomPerc(50))) &&
			A->ceil_h > B->floor_h)
		{
			NA->soft_link = STRU_Stairs;
		}
		else
		{
			NB->soft_link = STRU_Lift;
		}
	}
}

void DiscretizeLinks(stage_c *st)
{
	// first handle inter-stage connections

	if (st->S1.A && st->S1.N && ! st->S1.teleport)
		CreateLink(st->S1.A, NULL, st->S1.N, NULL);

	if (st->S2.A && st->S2.N && ! st->S2.teleport)
		CreateLink(st->S2.A, NULL, st->S2.N, NULL);

	FOR_AREA_IN_STAGE(A, a_idx, st->index)
	{
		FOR_NEIGHBOUR_IN_AREA(B, N, nb_idx, A)
		{
			if (B->stage != A->stage)
				continue;

			if (A->index >= B->index)
				continue;

			// make the fuzzy value black or white.
			if (N->cull_perc < 0)
				N->cull_perc = 0;
			else
				N->cull_perc = RandomPerc(N->cull_perc) ? 100 : 0;

			// update the backward link
			bool found_bkwd = false;

			FOR_NEIGHBOUR_IN_AREA(C, NB, cnb, B)
			{
				if (C == A)
				{
					NB->cull_perc = N->cull_perc;

					CreateLink(A, N, B, NB);

					found_bkwd = true;
					break;
				}
			}}

			SYS_ASSERT(found_bkwd);

			PrintDebug("_ final link from %d -> %d : %s\n",
					A->index, B->index, N->cull_perc ? "CULLED" : "OK");
		}}
	}}

	SYS_ASSERT(TestGraphValid(st));

	PrintDebug("\n");
}

void CreateLocalPaths()
{
	FOR_STAGE(st, st_idx)
	{
		PruneGraphForStage(st);
		DiscretizeLinks(st);
	}}
}

//------------------------------------------------------------------------
//  PUBLIC INTERFACE
//------------------------------------------------------------------------

void CreatePaths()
{
	MakeGlobalPath();
	CreateLocalPaths();
}

} // namespace path_build
