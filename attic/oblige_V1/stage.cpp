//------------------------------------------------------------------------
//  STAGES
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


stage_c::stage_c(int _index, char _key) : index(_index), key(_key),
	num_areas(0), num_squares(0), mid_x(0), mid_y(0),
	S1(), S2(), L1(), L2(), K(NULL)
{ }

stage_c::~stage_c()
{ }

void stage_c::ComputeInfo()
{
	num_areas = 0;
	num_squares = 0;

	mid_x = mid_y = 0;

	FOR_AREA_IN_STAGE(A, ar_idx, index)
	{
		mid_x += A->MidX();
		mid_y += A->MidY();

		num_areas++;
		num_squares += A->total;
	}}

	SYS_ASSERT(num_areas > 0);
	SYS_ASSERT(num_squares > 0);

	mid_x /= num_areas;
	mid_y /= num_areas;
}

//------------------------------------------------------------------------

namespace stage_build
{

void InitialStages()
{
	int possible_areas = 0;

	FOR_AREA(A, idx)
	{
		if (A->island >= 0)
			possible_areas++;
	}}

	// give some leeway on tiny maps
	if (possible_areas >= 2)
		possible_areas--;

	SYS_ASSERT(possible_areas > 0);

	int num_stages = (20 + the_world->dim() / 3 +
					  RandomRange(0,20) - RandomRange(0, 20)) / 10;

	if (num_stages < 1) num_stages = 1;
	if (num_stages > possible_areas) num_stages = possible_areas;
	if (num_stages > MAX_STAGES) num_stages = MAX_STAGES;

	PrintDebug("Stage count = %d\n", num_stages);

	for (int st_idx = 0; st_idx < num_stages; st_idx++)
	{
		the_world->NewStage();
	}

	PrintDebug("\n");
}

void AssignStageToArea(int st_idx, int pos_x, int pos_y)
{
	// finds the area which is closest to the given location and
	// is not already assigned, and assigns it to the given stage.

	PrintDebug("Assigning stage %d (pos %d,%d) ", st_idx, pos_x, pos_y);

	area_c * best_A = NULL;
	area_c * could_A = NULL;

	int best_dist = (1 << 30);

	FOR_AREA(A, ar_j)
	{
		if (A->island < 0)
			continue;

		if (A->stage >= 0)  // already assigned ?
			continue;

		if (! could_A)
			could_A = A;

		int dx = pos_x - A->MidX();
		int dy = pos_y - A->MidY();

		int dist = (dx * dx) + (dy * dy);

		if (dist < best_dist)
		{
			best_A = A;
			best_dist = dist;
		}
	}}

	if (! best_A)
	{
		PrintDebug("--> FAILED (possible: #%d)\n", could_A ? could_A->index : -1);

		best_A = could_A;
	}
	else
	{
		PrintDebug("--> AREA %2d @ (%2d,%2d) with dist = %d\n",
			best_A->index, best_A->MidX(), best_A->MidY(), best_dist);
	}

	if (! best_A)
		FatalError("Unable to assign stage #%d to an area\n", st_idx);

	best_A->stage = st_idx;

	// handle teleporters (the area on each side must have same stage)
	if (best_A->teleport)
	{
		SYS_ASSERT(best_A->teleport->stage < 0);
		best_A->teleport->stage = best_A->stage;
	}
}

void InitialStageAreas()
{
	/* ---- assign stage numbers to areas on the map ---- */

	int num_stages = the_world->NumStages();

	// high nibble is X pos, low nibble is Y pos
	static const int pos_list[MAX_STAGES] =
	{
		0x01, 0x21, 0x12, 0x10,  // N, E, S, W
		0x02, 0x20, 0x00, 0x22   // NW,SE,SW,NE
	};

	int pos[MAX_STAGES];

	int p;
	int pos_base = 0;

	if (num_stages <= 2 && RandomBool()) pos_base += 2;
	if (num_stages <= 4 && RandomBool()) pos_base += 4;

	int p_using = (num_stages <= 2) ? 2 : (num_stages <= 4) ? 4 : MAX_STAGES;

	for (p = 0; p < p_using; p++)
		pos[p] = pos_list[(p + pos_base) % MAX_STAGES];

	RandomShuffle(pos, p_using);

	static const int pos_perc[3] = { 20, 50, 80 };

	for (p = 0; p < num_stages; p++)
	{
		int pos_x = pos_perc[pos[p] >> 4] * the_world->w() / 100;
		int pos_y = pos_perc[pos[p] & 3]  * the_world->h() / 100;

		AssignStageToArea(p, pos_x, pos_y);
	}

	PrintDebug("\n");
}

//------------------------------------------------------------------------

int Joinability(area_c *A, area_c *B, int contacts)
{
	location_c& LA = A->Focal();
	location_c& LB = B->Focal();

	SYS_ASSERT(! LA.Void());
	SYS_ASSERT(! LB.Void());

	if (A->ceil_h <= B->floor_h || A->floor_h >= B->ceil_h)
		return 5;

	int score = 5;

	// update score based on high difference
	if (A->floor_h == B->floor_h)
		score += 35;
	else if (ABS(A->floor_h - B->floor_h) == 1)
		score += 20;
	else if (ABS(A->floor_h - B->floor_h) == 2)
		score += 7;

	// update score based on environment difference
	if (LA.env == LB.env)
		score += 25;
	else if (LA.env == ENV_Land || LB.env == ENV_Land)
		score += 15;

	// update score based on amount of contact
	int con_score = contacts * 25 * 2 / the_world->dim();
	if (con_score > 25) con_score = 25;

	score += con_score;

	SYS_ASSERT(5 <= score && score <= 95);

	return score;
}

void DoJoin(area_c *A, area_c *B, int score)
{
	SYS_ASSERT(A->island >= 0 && A->stage >= 0);
	SYS_ASSERT(B->island >= 0 && B->stage < 0);

	B->stage = A->stage;

	// handle teleporters (the area on each side must have same stage)
	if (B->teleport)
	{
		SYS_ASSERT(B->teleport->stage < 0);
		B->teleport->stage = B->stage;
	}

	PrintDebug("@ Assigning stage %d --> AREA %2d @ (%2d,%2d) with score = %d\n",
			B->stage, B->index, B->MidX(), B->MidY(), score);
}

int JoinPass(int *areas, int num_areas, bool force_link)
{
	struct join_info_s
	{
		area_c *A;
		area_c *B;

		int score;

		void Clear()
		{
			A = B = NULL; score = -1;
		}
	};

	join_info_s info[MAX_STAGES];

	for (int p = 0; p < MAX_STAGES; p++)
	{
		info[p].Clear();
	}

	// Note: this reflects number of empty areas _before_ this pass
	int empty_areas = 0;

	// loop over areas in area list.  If it belongs to an ungrown stage,
	// attempt to join it with a single non-assigned neighbour area
	// chosen at random.

	for (int idx = 0; idx < num_areas; idx++)
	{
		area_c *A = the_world->Area(areas[idx]);

		if (!A || A->island < 0)
			continue;

		if (A->stage < 0)
		{
			empty_areas++;
			continue;
		}

		int best_nb = -1;
		int best_score = -999;

		FOR_NEIGHBOUR_IN_AREA(B, N, nb_idx, A)
		{
			if (B->island < 0 || B->stage >= 0)
				continue;

			int score = Joinability(A, B, N->contacts);

			if (score > best_score)
			{
				best_nb = nb_idx;
				best_score = score;
			}
		}}

#if 0
		PrintDebug("___ JoinPass: area %d stage %d: best neighbour #%d (area %d) score %d\n",
				A->index, A->stage, best_nb,
				best_nb >= 0 ? A->neighbours[best_nb].ptr->index : -1,
				best_score);
#endif

		if (best_nb >= 0 && best_score > info[A->stage].score)
		{
			info[A->stage].A = A;
			info[A->stage].B = A->neighbours[best_nb].ptr;
			info[A->stage].score = best_score;
		}
	}

//	PrintDebug("\n");

	// for each stage, now make the found link (if any).
	// Iterate through stages in a random order.

	int order[MAX_STAGES];

	RandomShuffle(order, MAX_STAGES, true /* fill */);

	for (int i = 0; i < MAX_STAGES; i++)
	{
		join_info_s& J = info[order[i]];

//		PrintDebug("[ST_%d] --> %d to %d, score %d\n", order[i],
//				J.A ? J.A->index : -1, J.B ? J.B->index : -1, J.score);

		if (J.score < 0)
			continue;

		// handle the case of two stages trying to connect to the same
		// area at the same time.  First in gets it.
		if (J.B->stage >= 0)
			continue;

		if (force_link || RandomPerc(J.score))
		{
			DoJoin(J.A, J.B, J.score);
		}
	}

//	PrintDebug("\n");

	return empty_areas;
}

#if 0
inline bool TryCopyStage(area_c *A, int src_x, int src_y)
{
	if (the_world->Loc(src_x, src_y).Void())
		return false;

	area_c *B = the_world->Area(the_world->Loc(src_x, src_y).area);

	if (! B || B == A || B->island < 0 || B->stage < 0)
		return false;

	A->stage = B->stage;
	return true;
}

void JoinClosestStage(area_c *A, int away_dist)
{
	int lo_x = A->lo_x - away_dist;
	int lo_y = A->lo_y - away_dist;
	int hi_x = A->hi_x + away_dist;
	int hi_y = A->hi_y + away_dist;

	// prevent infinite loops you fool :)
	if (hi_x == lo_x) hi_x++;
	if (hi_y == lo_y) hi_y++;

	for (int y = lo_y; y <= hi_y; y += (hi_y - lo_y))
	for (int x = lo_x; x <= hi_x; x++)
	{
		if (the_world->Inside(x, y))
			if (TryCopyStage(A, x, y))
				return;
	}

	for (int x = lo_x; x <= hi_x; x += (hi_x - lo_x))
	for (int y = lo_y; y <= hi_y; y++)
	{
		if (the_world->Inside(x, y))
			if (TryCopyStage(A, x, y))
				return;
	}
}
#endif

void EnlargeStages()
{
	int num_areas = the_world->NumAreas();

	if (num_areas <= 1)
		return;

	int *area_list = new int[num_areas + 1];
	int empty;

	RandomShuffle(area_list, num_areas, true /* fill */);

	for (int loop = 200; loop >= 0; loop--)
	{
		empty = JoinPass(area_list, num_areas, (loop % 8) == 0);

		if ((loop % 4) == 0)
			PrintDebug("JoinStages: loop %d empty %d\n", loop, empty);

		if (empty == 0)
			break;

		RandomShuffle(area_list, num_areas, false /* fill */);
	}

	PrintDebug("\n");

	if (empty != 0)
		FatalError("Failed to enlarge stages.\n");

#if 0
	// for separated bits, they may not have received a stage yet.
	// Handle them now (find the closest stage).

	for (int away_dist = 0; away_dist < the_world->dim(); away_dist++)
	{
// PrintDebug("Away dist %d  Empty: %d\n", away_dist, JoinPass());

		if (JoinPass() == 0)
			break;

		FOR_AREA(A, ar_idx)
		{
			if (A->island < 0 || A->stage >= 0)
				continue;

			JoinClosestStage(A, away_dist);
		}}
	}
#endif
}

//------------------------------------------------------------------------

int StageEnvironScore(const area_c *source, const area_c *dest)
{
	location_c& LA = the_world->Loc(source->focal_x, source->focal_y);
	location_c& LB = the_world->Loc(dest->focal_x, dest->focal_y);

	if (LA.env == ENV_Building || LB.env == ENV_Building)
		return 100;

	if (LA.env == ENV_Cave || LB.env == ENV_Cave)
		return 50;

	return 0;
}

int StageHeightScore(const area_c *source, const area_c *dest)
{
	if (source->floor_h == dest->floor_h)
		return 100;

	if (source->floor_h < dest->floor_h)
		return 50;

	return 0;
}

int StageContactScore(int contacts)
{
	int score = 100 - contacts * 200 / the_world->dim();

	return MAX(0, score);
}

int EvaluateStagePair(int source, int dest)
{
	int touches = 0;

	int env_score = 0;
	int ht_score  = 0;
	int con_score = 0;

	FOR_AREA_IN_STAGE(A, ar_idx, source)
	{
		FOR_NEIGHBOUR_IN_AREA(B, N, nb_idx, A)
		{
			if (B->stage != dest)
				continue;

			touches++;

			env_score += StageEnvironScore(A, B);
			ht_score  += StageHeightScore(A, B);
			con_score += StageContactScore(A->neighbours[nb_idx].contacts);
		}}
	}}

	if (touches == 0)
	{
//		PrintDebug("__ evaluate pair %d -> %d: NO TOUCHES\n", source, dest);
		return 0;
	}

	env_score /= touches;
	ht_score  /= touches;
	con_score /= touches;

	int score = 300;

	score += env_score * 35 / 100;
	score += ht_score  * 25 / 100;
	score += con_score * 15 / 100;

//	PrintDebug("__ evaluate pair %d -> %d: score %d  "
//			   "(touches %d  env %d  ht %d  con %d)\n",
//			source, dest, score, touches, env_score, ht_score, con_score);

	return score;
}

int EvaluateStageOrdering(int *order, int num_stages)
{
	int total = 0;

	for (int p = 0; p < num_stages-1; p++)
	{
		total += EvaluateStagePair(order[p], order[p+1]);
	}

	return total;
}

void OptimizeStages()
{
	int num_stages = the_world->NumStages();

	if (num_stages < 2)
		return;

	int reorder[MAX_STAGES];
	int p;

	for (p = 0; p < num_stages; p++)
		reorder[p] = p;

	int best_score = EvaluateStageOrdering(reorder, num_stages);

	for (int loop = 0; loop < 200; loop++)
	{
		int test_order[MAX_STAGES];

		RandomShuffle(test_order, num_stages, true /* fill */);

		int score = EvaluateStageOrdering(test_order, num_stages);

		if ((loop % 10) == 0)
			PrintDebug("OptimizeStages loop %d: cur_score %d, best %d\n",
					loop, score, best_score);

		if (score > best_score)
		{
			best_score = score;

			for (p = 0; p < num_stages; p++)
				reorder[p] = test_order[p];
		}
	}

	PrintDebug("\nOptimized mapping: ");

	for (p = 0; p < num_stages; p++)
		PrintDebug("%d->%d ", reorder[p], p);

	PrintDebug("\n\n");

	// perform the actual re-ordering.  We first need to convert our
	// inverse mapping into a normal mapping...

	int mapping[MAX_STAGES];

	for (int m = 0; m < num_stages; m++)
		mapping[reorder[m]] = m;

	the_world->RenumberStages(mapping);
}

void ComputeStageInfo()
{
	FOR_STAGE(st, st_idx)
	{
		st->ComputeInfo();

		PrintDebug("Stage %d @ (%2d,%2d)  areas %d  squares %d\n",
				st->index, st->mid_x, st->mid_y, st->num_areas, st->num_squares);
	}}

	PrintDebug("\n");
}

//------------------------------------------------------------------------
//  PUBLIC INTERFACE
//------------------------------------------------------------------------

void CreateStages()
{
	InitialStages();
	InitialStageAreas();

	EnlargeStages();
	OptimizeStages();
	ComputeStageInfo();
}


} // namespace stage_build

