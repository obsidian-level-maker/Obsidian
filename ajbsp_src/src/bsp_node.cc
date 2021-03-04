//------------------------------------------------------------------------
//
//  AJ-BSP  Copyright (C) 2000-2018  Andrew Apted, et al
//          Copyright (C) 1994-1998  Colin Reed
//          Copyright (C) 1997-1998  Lee Killough
//
//  Originally based on the program 'BSP', version 2.3.
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


//
// To be able to divide the nodes down, this routine must decide which
// is the best Seg to use as a nodeline. It does this by selecting the
// line with least splits and has least difference of Segs on either
// side of it.
//
// Credit to Raphael Quinet and DEU, this routine is a copy of the
// nodeline picker used in DEU5beta. I am using this method because
// the method I originally used was not so good.
//
// Rewritten by Lee Killough to significantly improve performance,
// while not affecting results one bit in >99% of cases (some tiny
// differences due to roundoff error may occur, but they are
// insignificant).
//
// Rewritten again by Andrew Apted (-AJA-), 1999-2000.
//

#include "main.h"


namespace ajbsp
{

#define PRECIOUS_MULTIPLY  100

#define SEG_FAST_THRESHHOLD  200


#define DEBUG_PICKNODE  0
#define DEBUG_SPLIT     0
#define DEBUG_CUTLIST   0


typedef struct eval_info_s
{
	int cost;
	int splits;
	int iffy;
	int near_miss;

	int real_left;
	int real_right;
	int mini_left;
	int mini_right;
}
eval_info_t;


static intersection_t *quick_alloc_cuts = NULL;


static intersection_t *NewIntersection(void)
{
	intersection_t *cut;

	if (quick_alloc_cuts)
	{
		cut = quick_alloc_cuts;
		quick_alloc_cuts = cut->next;
	}
	else
	{
		cut = (intersection_t *) UtilCalloc(sizeof(intersection_t));
	}

	return cut;
}


void FreeQuickAllocCuts(void)
{
	while (quick_alloc_cuts)
	{
		intersection_t *cut = quick_alloc_cuts;
		quick_alloc_cuts = cut->next;

		UtilFree(cut);
	}
}


//
// Fill in the fields 'angle', 'len', 'pdx', 'pdy', etc...
//
void RecomputeSeg(seg_t *seg)
{
	seg->psx = seg->start->x;
	seg->psy = seg->start->y;
	seg->pex = seg->end->x;
	seg->pey = seg->end->y;
	seg->pdx = seg->pex - seg->psx;
	seg->pdy = seg->pey - seg->psy;

	seg->p_length = UtilComputeDist(seg->pdx, seg->pdy);

	if (seg->p_length <= 0)
		BugError("Seg %p has zero p_length.\n", seg);

	seg->p_perp =  seg->psy * seg->pdx - seg->psx * seg->pdy;
	seg->p_para = -seg->psx * seg->pdx - seg->psy * seg->pdy;
}


//
// -AJA- Splits the given seg at the point (x,y).  The new seg is
//       returned.  The old seg is shortened (the original start
//       vertex is unchanged), whereas the new seg becomes the cut-off
//       tail (keeping the original end vertex).
//
//       If the seg has a partner, than that partner is also split.
//       NOTE WELL: the new piece of the partner seg is inserted into
//       the same list as the partner seg (and after it) -- thus ALL
//       segs (except the one we are currently splitting) must exist
//       on a singly-linked list somewhere.
//
// Note: we must update the count values of any superblock that
//       contains the seg (and/or partner), so that future processing
//       is not fucked up by incorrect counts.
//
static seg_t * SplitSeg(seg_t *old_seg, double x, double y)
{
	seg_t *new_seg;
	vertex_t *new_vert;

# if DEBUG_SPLIT
	if (old_seg->linedef)
		DebugPrintf("Splitting Linedef %d (%p) at (%1.1f,%1.1f)\n",
				old_seg->linedef->index, old_seg, x, y);
	else
		DebugPrintf("Splitting Miniseg %p at (%1.1f,%1.1f)\n", old_seg, x, y);
# endif

	// update superblock, if needed
	if (old_seg->block)
		SplitSegInSuper(old_seg->block, old_seg);

	new_vert = NewVertexFromSplitSeg(old_seg, x, y);
	new_seg  = NewSeg();

	// copy seg info
	new_seg[0] = old_seg[0];
	new_seg->next = NULL;

	old_seg->end = new_vert;
	RecomputeSeg(old_seg);

	new_seg->start = new_vert;
	RecomputeSeg(new_seg);

# if DEBUG_SPLIT
	DebugPrintf("Splitting Vertex is %04X at (%1.1f,%1.1f)\n",
			new_vert->index, new_vert->x, new_vert->y);
# endif

	// handle partners

	if (old_seg->partner)
	{
#   if DEBUG_SPLIT
		DebugPrintf("Splitting Partner %p\n", old_seg->partner);
#   endif

		// update superblock, if needed
		if (old_seg->partner->block)
			SplitSegInSuper(old_seg->partner->block, old_seg->partner);

		new_seg->partner = NewSeg();

		// copy seg info
		new_seg->partner[0] = old_seg->partner[0];

		// IMPORTANT: keep partner relationship valid.
		new_seg->partner->partner = new_seg;

		old_seg->partner->start = new_vert;
		RecomputeSeg(old_seg->partner);

		new_seg->partner->end = new_vert;
		RecomputeSeg(new_seg->partner);

		// link it into list
		old_seg->partner->next = new_seg->partner;
	}

	return new_seg;
}


//
// -AJA- In the quest for slime-trail annihilation :->, this routine
//       calculates the intersection location between the current seg
//       and the partitioning seg, and takes advantage of some common
//       situations like horizontal/vertical lines.
//
static inline void ComputeIntersection(seg_t *seg, seg_t *part,
		double perp_c, double perp_d, double *x, double *y)
{
	double ds;

	// horizontal partition against vertical seg
	if (part->pdy == 0 && seg->pdx == 0)
	{
		*x = seg->psx;
		*y = part->psy;
		return;
	}

	// vertical partition against horizontal seg
	if (part->pdx == 0 && seg->pdy == 0)
	{
		*x = part->psx;
		*y = seg->psy;
		return;
	}

	// 0 = start, 1 = end
	ds = perp_c / (perp_c - perp_d);

	if (seg->pdx == 0)
		*x = seg->psx;
	else
		*x = seg->psx + (seg->pdx * ds);

	if (seg->pdy == 0)
		*y = seg->psy;
	else
		*y = seg->psy + (seg->pdy * ds);
}


static void AddIntersection(intersection_t ** cut_list,
		vertex_t *vert, seg_t *part, bool self_ref)
{
	intersection_t *cut;
	intersection_t *after;

	/* check if vertex already present */
	for (cut=(*cut_list) ; cut ; cut=cut->next)
	{
		if (vert == cut->vertex)
			return;
	}

	/* create new intersection */
	cut = NewIntersection();

	cut->vertex = vert;
	cut->along_dist = UtilParallelDist(part, vert->x, vert->y);
	cut->self_ref = self_ref;

	cut->before = VertexCheckOpen(vert, -part->pdx, -part->pdy);
	cut->after  = VertexCheckOpen(vert,  part->pdx,  part->pdy);

	/* enqueue the new intersection into the list */

	for (after=(*cut_list) ; after && after->next ; after=after->next)
	{ }

	while (after && cut->along_dist < after->along_dist)
		after = after->prev;

	/* link it in */
	cut->next = after ? after->next : (*cut_list);
	cut->prev = after;

	if (after)
	{
		if (after->next)
			after->next->prev = cut;

		after->next = cut;
	}
	else
	{
		if (*cut_list)
			(*cut_list)->prev = cut;

		(*cut_list) = cut;
	}
}


//
// Returns true if a "bad seg" was found early.
//
static int EvalPartitionWorker(superblock_t *seg_list, seg_t *part,
		int best_cost, eval_info_t *info)
{
	seg_t *check;

	double qnty;
	double a, b, fa, fb;

	int num;
	int factor = cur_info->factor;

	// -AJA- this is the heart of my superblock idea, it tests the
	//       _whole_ block against the partition line to quickly handle
	//       all the segs within it at once.  Only when the partition
	//       line intercepts the box do we need to go deeper into it.

	num = BoxOnLineSide(seg_list, part);

	if (num < 0)
	{
		// LEFT

		info->real_left += seg_list->real_num;
		info->mini_left += seg_list->mini_num;

		return false;
	}
	else if (num > 0)
	{
		// RIGHT

		info->real_right += seg_list->real_num;
		info->mini_right += seg_list->mini_num;

		return false;
	}

# define ADD_LEFT()  \
	do {  \
		if (check->linedef) info->real_left += 1;  \
		else                info->mini_left += 1;  \
	} while (0)

# define ADD_RIGHT()  \
	do {  \
		if (check->linedef) info->real_right += 1;  \
		else                info->mini_right += 1;  \
	} while (0)

	/* check partition against all Segs */

	for (check=seg_list->segs ; check ; check=check->next)
	{
		// This is the heart of my pruning idea - it catches
		// bad segs early on. Killough

		if (info->cost > best_cost)
			return true;

		/* get state of lines' relation to each other */
		if (check->source_line == part->source_line)
		{
			a = b = fa = fb = 0;
		}
		else
		{
			a = UtilPerpDist(part, check->psx, check->psy);
			b = UtilPerpDist(part, check->pex, check->pey);

			fa = fabs(a);
			fb = fabs(b);
		}

		/* check for being on the same line */
		if (fa <= DIST_EPSILON && fb <= DIST_EPSILON)
		{
			// this seg runs along the same line as the partition.  Check
			// whether it goes in the same direction or the opposite.

			if (check->pdx*part->pdx + check->pdy*part->pdy < 0)
			{
				ADD_LEFT();
			}
			else
			{
				ADD_RIGHT();
			}

			continue;
		}

		// -AJA- check for passing through a vertex.  Normally this is fine
		//       (even ideal), but the vertex could on a sector that we
		//       DONT want to split, and the normal linedef-based checks
		//       may fail to detect the sector being cut in half.  Thanks
		//       to Janis Legzdinsh for spotting this obscure bug.

		if (fa <= DIST_EPSILON || fb <= DIST_EPSILON)
		{
			if (check->linedef && check->linedef->is_precious)
				info->cost += 40 * factor * PRECIOUS_MULTIPLY;
		}

		/* check for right side */
		if (a > -DIST_EPSILON && b > -DIST_EPSILON)
		{
			ADD_RIGHT();

			/* check for a near miss */
			if ((a >= IFFY_LEN && b >= IFFY_LEN) ||
					(a <= DIST_EPSILON && b >= IFFY_LEN) ||
					(b <= DIST_EPSILON && a >= IFFY_LEN))
			{
				continue;
			}

			info->near_miss++;

			// -AJA- near misses are bad, since they have the potential to
			//       cause really short minisegs to be created in future
			//       processing.  Thus the closer the near miss, the higher
			//       the cost.

			if (a <= DIST_EPSILON || b <= DIST_EPSILON)
				qnty = IFFY_LEN / MAX(a, b);
			else
				qnty = IFFY_LEN / MIN(a, b);

			info->cost += (int) (100 * factor * (qnty * qnty - 1.0));
			continue;
		}

		/* check for left side */
		if (a < DIST_EPSILON && b < DIST_EPSILON)
		{
			ADD_LEFT();

			/* check for a near miss */
			if ((a <= -IFFY_LEN && b <= -IFFY_LEN) ||
					(a >= -DIST_EPSILON && b <= -IFFY_LEN) ||
					(b >= -DIST_EPSILON && a <= -IFFY_LEN))
			{
				continue;
			}

			info->near_miss++;

			// the closer the miss, the higher the cost (see note above)
			if (a >= -DIST_EPSILON || b >= -DIST_EPSILON)
				qnty = IFFY_LEN / -MIN(a, b);
			else
				qnty = IFFY_LEN / -MAX(a, b);

			info->cost += (int) (70 * factor * (qnty * qnty - 1.0));
			continue;
		}

		// When we reach here, we have a and b non-zero and opposite sign,
		// hence this seg will be split by the partition line.

		info->splits++;

		// If the linedef associated with this seg has a tag >= 900, treat
		// it as precious; i.e. don't split it unless all other options
		// are exhausted. This is used to protect deep water and invisible
		// lifts/stairs from being messed up accidentally by splits.

		if (check->linedef && check->linedef->is_precious)
			info->cost += 100 * factor * PRECIOUS_MULTIPLY;
		else
			info->cost += 100 * factor;

		// -AJA- check if the split point is very close to one end, which
		//       is quite an undesirable situation (producing really short
		//       segs).  This is perhaps _one_ source of those darn slime
		//       trails.  Hence the name "IFFY segs", and a rather hefty
		//       surcharge :->.

		if (fa < IFFY_LEN || fb < IFFY_LEN)
		{
			info->iffy++;

			// the closer to the end, the higher the cost
			qnty = IFFY_LEN / MIN(fa, fb);
			info->cost += (int) (140 * factor * (qnty * qnty - 1.0));
		}
	}

	/* handle sub-blocks recursively */

	for (num=0 ; num < 2 ; num++)
	{
		if (! seg_list->subs[num])
			continue;

		if (EvalPartitionWorker(seg_list->subs[num], part, best_cost, info))
			return true;
	}

	/* no "bad seg" was found */
	return false;
}

//
// -AJA- Evaluate a partition seg & determine the cost, taking into
//       account the number of splits, difference between left &
//       right, and linedefs that are tagged 'precious'.
//
// Returns the computed cost, or a negative value if the seg should be
// skipped altogether.
//
static int EvalPartition(superblock_t *seg_list, seg_t *part,
						 int best_cost)
{
	eval_info_t info;

	/* initialise info structure */
	info.cost   = 0;
	info.splits = 0;
	info.iffy   = 0;
	info.near_miss  = 0;

	info.real_left  = 0;
	info.real_right = 0;
	info.mini_left  = 0;
	info.mini_right = 0;

	if (EvalPartitionWorker(seg_list, part, best_cost, &info))
		return -1;

	/* make sure there is at least one real seg on each side */
	if (info.real_left == 0 || info.real_right == 0)
	{
#   if DEBUG_PICKNODE
		DebugPrintf("Eval : No real segs on %s%sside\n",
				info.real_left  ? "" : "left ",
				info.real_right ? "" : "right ");
#   endif

		return -1;
	}

	/* increase cost by the difference between left & right */
	info.cost += 100 * ABS(info.real_left - info.real_right);

	// -AJA- allow miniseg counts to affect the outcome, but only to a
	//       lesser degree than real segs.

	info.cost += 50 * ABS(info.mini_left - info.mini_right);

	// -AJA- Another little twist, here we show a slight preference for
	//       partition lines that lie either purely horizontally or
	//       purely vertically.

	if (part->pdx != 0 && part->pdy != 0)
		info.cost += 25;

# if DEBUG_PICKNODE
	DebugPrintf("Eval %p: splits=%d iffy=%d near=%d left=%d+%d right=%d+%d "
			"cost=%d.%02d\n", part, info.splits, info.iffy, info.near_miss,
			info.real_left, info.mini_left, info.real_right, info.mini_right,
			info.cost / 100, info.cost % 100);
# endif

	return info.cost;
}


static void EvaluateFastWorker(superblock_t *seg_list,
		seg_t **best_H, seg_t **best_V, int mid_x, int mid_y)
{
	seg_t *part;
	int num;

	for (part=seg_list->segs ; part ; part = part->next)
	{
		/* ignore minisegs as partition candidates */
		if (! part->linedef)
			continue;

		if (part->pdy == 0)
		{
			// horizontal seg
			if (! *best_H)
				*best_H = part;
			else
			{
				int old_dist = abs((int)(*best_H)->psy - mid_y);
				int new_dist = abs((int)(   part)->psy - mid_y);

				if (new_dist < old_dist)
					*best_H = part;
			}
		}
		else if (part->pdx == 0)
		{
			// vertical seg
			if (! *best_V)
				*best_V = part;
			else
			{
				int old_dist = abs((int)(*best_V)->psx - mid_x);
				int new_dist = abs((int)(   part)->psx - mid_x);

				if (new_dist < old_dist)
					*best_V = part;
			}
		}
	}

	/* handle sub-blocks recursively */

	for (num=0 ; num < 2 ; num++)
	{
		if (! seg_list->subs[num])
			continue;

		EvaluateFastWorker(seg_list->subs[num], best_H, best_V, mid_x, mid_y);
	}
}


static seg_t *FindFastSeg(superblock_t *seg_list, const bbox_t *bbox)
{
	seg_t *best_H = NULL;
	seg_t *best_V = NULL;

	int mid_x = (bbox->minx + bbox->maxx) / 2;
	int mid_y = (bbox->miny + bbox->maxy) / 2;

	EvaluateFastWorker(seg_list, &best_H, &best_V, mid_x, mid_y);

	int H_cost = -1;
	int V_cost = -1;

	if (best_H)
		H_cost = EvalPartition(seg_list, best_H, 99999999);

	if (best_V)
		V_cost = EvalPartition(seg_list, best_V, 99999999);

# if DEBUG_PICKNODE
	DebugPrintf("FindFastSeg: best_H=%p (cost %d) | best_V=%p (cost %d)\n",
			best_H, H_cost, best_V, V_cost);
# endif

	if (H_cost < 0 && V_cost < 0)
		return NULL;

	if (H_cost < 0) return best_V;
	if (V_cost < 0) return best_H;

	return (V_cost < H_cost) ? best_V : best_H;
}


/* returns false if cancelled */
static bool PickNodeWorker(superblock_t *part_list,
		superblock_t *seg_list, seg_t ** best, int *best_cost)
{
	seg_t *part;

	int num;
	int cost;

	/* use each Seg as partition */
	for (part=part_list->segs ; part ; part = part->next)
	{
		if (cur_info->cancelled)
			return false;

#   if DEBUG_PICKNODE
		DebugPrintf("PickNode:   %sSEG %p  sector=%d  (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n",
				part->linedef ? "" : "MINI", part,
				part->sector ? part->sector->index : -1,
				part->start->x, part->start->y, part->end->x, part->end->y);
#   endif

		/* ignore minisegs as partition candidates */
		if (! part->linedef)
			continue;

		cost = EvalPartition(seg_list, part, *best_cost);

		/* seg unsuitable or too costly ? */
		if (cost < 0 || cost >= *best_cost)
			continue;

		/* we have a new better choice */
		(*best_cost) = cost;

		/* remember which Seg */
		(*best) = part;
	}

	/* recursively handle sub-blocks */

	for (num=0 ; num < 2 ; num++)
	{
		if (part_list->subs[num])
			PickNodeWorker(part_list->subs[num], seg_list, best, best_cost);
	}

	return true;
}


//
// Find the best seg in the seg_list to use as a partition line.
//
seg_t *PickNode(superblock_t *seg_list, int depth, const bbox_t *bbox)
{
	seg_t *best=NULL;

	int best_cost=INT_MAX;

# if DEBUG_PICKNODE
	DebugPrintf("PickNode: BEGUN (depth %d)\n", depth);
# endif

	/* -AJA- here is the logic for "fast mode".  We look for segs which
	 *       are axis-aligned and roughly divide the current group into
	 *       two halves.  This can save *heaps* of times on large levels.
	 */
	if (cur_info->fast && seg_list->real_num >= SEG_FAST_THRESHHOLD)
	{
#   if DEBUG_PICKNODE
		DebugPrintf("PickNode: Looking for Fast node...\n");
#   endif

		best = FindFastSeg(seg_list, bbox);

		if (best)
		{
#     if DEBUG_PICKNODE
			DebugPrintf("PickNode: Using Fast node (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n",
					best->start->x, best->start->y, best->end->x, best->end->y);
#     endif

			return best;
		}
	}

	if (! PickNodeWorker(seg_list, seg_list, &best, &best_cost))
	{
		/* hack here : BuildNodes will detect the cancellation */
		return NULL;
	}

# if DEBUG_PICKNODE
	if (! best)
	{
		DebugPrintf("PickNode: NO BEST FOUND !\n");
	}
	else
	{
		DebugPrintf("PickNode: Best has score %d.%02d  (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n",
				best_cost / 100, best_cost % 100, best->start->x, best->start->y,
				best->end->x, best->end->y);
	}
# endif

	/* all finished, return best Seg */
	return best;
}


//
// Apply the partition line to the given seg, taking the necessary
// action (moving it into either the left list, right list, or
// splitting it).
//
// -AJA- I have rewritten this routine based on the EvalPartition
//       routine above (which I've also reworked, heavily).  I think
//       it is important that both these routines follow the exact
//       same logic when determining which segs should go left, right
//       or be split.
//
void DivideOneSeg(seg_t *seg, seg_t *part,
		superblock_t *left_list, superblock_t *right_list,
		intersection_t ** cut_list)
{
	seg_t *new_seg;

	double x, y;

	/* get state of lines' relation to each other */
	double a = UtilPerpDist(part, seg->psx, seg->psy);
	double b = UtilPerpDist(part, seg->pex, seg->pey);

	bool self_ref = seg->linedef ? seg->linedef->self_ref : false;

	if (seg->source_line == part->source_line)
		a = b = 0;

	/* check for being on the same line */
	if (fabs(a) <= DIST_EPSILON && fabs(b) <= DIST_EPSILON)
	{
		AddIntersection(cut_list, seg->start, part, self_ref);
		AddIntersection(cut_list, seg->end,   part, self_ref);

		// this seg runs along the same line as the partition.  check
		// whether it goes in the same direction or the opposite.

		if (seg->pdx*part->pdx + seg->pdy*part->pdy < 0)
		{
			AddSegToSuper(left_list, seg);
		}
		else
		{
			AddSegToSuper(right_list, seg);
		}

		return;
	}

	/* check for right side */
	if (a > -DIST_EPSILON && b > -DIST_EPSILON)
	{
		if (a < DIST_EPSILON)
			AddIntersection(cut_list, seg->start, part, self_ref);
		else if (b < DIST_EPSILON)
			AddIntersection(cut_list, seg->end, part, self_ref);

		AddSegToSuper(right_list, seg);
		return;
	}

	/* check for left side */
	if (a < DIST_EPSILON && b < DIST_EPSILON)
	{
		if (a > -DIST_EPSILON)
			AddIntersection(cut_list, seg->start, part, self_ref);
		else if (b > -DIST_EPSILON)
			AddIntersection(cut_list, seg->end, part, self_ref);

		AddSegToSuper(left_list, seg);
		return;
	}

	// when we reach here, we have a and b non-zero and opposite sign,
	// hence this seg will be split by the partition line.

	ComputeIntersection(seg, part, a, b, &x, &y);

	new_seg = SplitSeg(seg, x, y);

	AddIntersection(cut_list, seg->end, part, self_ref);

	if (a < 0)
	{
		AddSegToSuper(left_list,  seg);
		AddSegToSuper(right_list, new_seg);
	}
	else
	{
		AddSegToSuper(right_list, seg);
		AddSegToSuper(left_list,  new_seg);
	}
}


void SeparateSegs(superblock_t *seg_list, seg_t *part,
		superblock_t *lefts, superblock_t *rights,
		intersection_t ** cut_list)
{
	int num;

	while (seg_list->segs)
	{
		seg_t *seg = seg_list->segs;
		seg_list->segs = seg->next;

		seg->block = NULL;

		DivideOneSeg(seg, part, lefts, rights, cut_list);
	}

	// recursively handle sub-blocks
	for (num=0 ; num < 2 ; num++)
	{
		superblock_t *A = seg_list->subs[num];

		if (A)
		{
			SeparateSegs(A, part, lefts, rights, cut_list);

			if (A->real_num + A->mini_num > 0)
				BugError("SeparateSegs: child %d not empty!\n", num);

			FreeSuper(A);
			seg_list->subs[num] = NULL;
		}
	}

	seg_list->real_num = seg_list->mini_num = 0;
}


static void FindLimitWorker(superblock_t *block, bbox_t *bbox)
{
	for (seg_t *seg=block->segs ; seg ; seg=seg->next)
	{
		double x1 = seg->start->x;
		double y1 = seg->start->y;
		double x2 = seg->end->x;
		double y2 = seg->end->y;

		int lx = (int) floor(MIN(x1, x2));
		int ly = (int) floor(MIN(y1, y2));
		int hx = (int) ceil(MAX(x1, x2));
		int hy = (int) ceil(MAX(y1, y2));

		if (lx < bbox->minx) bbox->minx = lx;
		if (ly < bbox->miny) bbox->miny = ly;
		if (hx > bbox->maxx) bbox->maxx = hx;
		if (hy > bbox->maxy) bbox->maxy = hy;
	}

	// recursive handle sub-blocks

	for (int num=0 ; num < 2 ; num++)
	{
		if (block->subs[num])
			FindLimitWorker(block->subs[num], bbox);
	}
}


//
// Find the limits from a list of segs, by stepping through the segs
// and comparing the vertices at both ends.
//
void FindLimits(superblock_t *seg_list, bbox_t *bbox)
{
	bbox->minx = bbox->miny = SHRT_MAX;
	bbox->maxx = bbox->maxy = SHRT_MIN;

	FindLimitWorker(seg_list, bbox);
}


void AddMinisegs(seg_t *part,
		superblock_t *left_list, superblock_t *right_list,
		intersection_t *cut_list)
{
	intersection_t *cur, *next;
	seg_t *seg, *buddy;

	if (! cut_list)
		return;

# if DEBUG_CUTLIST
	DebugPrintf("CUT LIST:\n");
	DebugPrintf("PARTITION: (%1.1f,%1.1f) += (%1.1f,%1.1f)\n",
			part->psx, part->psy, part->pdx, part->pdy);

	for (cur=cut_list ; cur ; cur=cur->next)
	{
		DebugPrintf("  Vertex %8X (%1.1f,%1.1f)  Along %1.2f  [%d/%d]  %s\n",
				cur->vertex->index, cur->vertex->x, cur->vertex->y,
				cur->along_dist,
				cur->before ? cur->before->index : -1,
				cur->after ? cur->after->index : -1,
				cur->self_ref ? "SELFREF" : "");
	}
# endif

	// STEP 1: fix problems the intersection list...

	cur  = cut_list;
	next = cur->next;

	while (cur && next)
	{
		double len = next->along_dist - cur->along_dist;

		if (len < -0.1)
			BugError("Bad order in intersect list: %1.3f > %1.3f\n",
					cur->along_dist, next->along_dist);

		if (len > 0.2)
		{
			cur  = next;
			next = cur->next;
			continue;
		}

		if (len > DIST_EPSILON)
		{
			MinorIssue("Skipping very short seg (len=%1.3f) near (%1.1f,%1.1f)\n",
					len, cur->vertex->x, cur->vertex->y);
		}

		// merge the two intersections into one

# if DEBUG_CUTLIST
		DebugPrintf("Merging cut (%1.0f,%1.0f) [%d/%d] with %p (%1.0f,%1.0f) [%d/%d]\n",
				cur->vertex->x, cur->vertex->y,
				cur->before ? cur->before->index : -1,
				cur->after ? cur->after->index : -1,
				next->vertex,
				next->vertex->x, next->vertex->y,
				next->before ? next->before->index : -1,
				next->after ? next->after->index : -1);
# endif

		if (cur->self_ref && !next->self_ref)
		{
			if (cur->before && next->before)
				cur->before = next->before;

			if (cur->after && next->after)
				cur->after = next->after;

			cur->self_ref = false;
		}

		if (!cur->before && next->before)
			cur->before = next->before;

		if (!cur->after && next->after)
			cur->after = next->after;

# if DEBUG_CUTLIST
		DebugPrintf("---> merged (%1.0f,%1.0f) [%d/%d] %s\n",
				cur->vertex->x, cur->vertex->y,
				cur->before ? cur->before->index : -1,
				cur->after ? cur->after->index : -1,
				cur->self_ref ? "SELFREF" : "");
# endif

		// free the unused cut

		cur->next = next->next;

		next->next = quick_alloc_cuts;
		quick_alloc_cuts = next;

		next = cur->next;
	}

	// STEP 2: find connections in the intersection list...

	for (cur = cut_list ; cur && cur->next ; cur = cur->next)
	{
		next = cur->next;

		if (!cur->after && !next->before)
			continue;

		// check for some nasty OPEN/CLOSED or CLOSED/OPEN cases
		if (cur->after && !next->before)
		{
			if (!cur->self_ref && !cur->after->warned_unclosed)
			{
				MinorIssue("Sector #%d is unclosed near (%1.1f,%1.1f)\n",
						cur->after->index,
						(cur->vertex->x + next->vertex->x) / 2.0,
						(cur->vertex->y + next->vertex->y) / 2.0);
				cur->after->warned_unclosed = 1;
			}
			continue;
		}
		else if (!cur->after && next->before)
		{
			if (!next->self_ref && !next->before->warned_unclosed)
			{
				MinorIssue("Sector #%d is unclosed near (%1.1f,%1.1f)\n",
						next->before->index,
						(cur->vertex->x + next->vertex->x) / 2.0,
						(cur->vertex->y + next->vertex->y) / 2.0);
				next->before->warned_unclosed = 1;
			}
			continue;
		}

		// righteo, here we have definite open space.
		// do a sanity check on the sectors (just for good measure).

		if (cur->after != next->before)
		{
			if (!cur->self_ref && !next->self_ref)
				MinorIssue("Sector mismatch: #%d (%1.1f,%1.1f) != #%d (%1.1f,%1.1f)\n",
						cur->after->index, cur->vertex->x, cur->vertex->y,
						next->before->index, next->vertex->x, next->vertex->y);

			// choose the non-self-referencing sector when we can
			if (cur->self_ref && !next->self_ref)
			{
				cur->after = next->before;
			}
		}

		// create the miniseg pair
		seg = NewSeg();
		buddy = NewSeg();

		seg->partner = buddy;
		buddy->partner = seg;

		seg->start = cur->vertex;
		seg->end   = next->vertex;

		buddy->start = next->vertex;
		buddy->end   = cur->vertex;

		// leave 'linedef' field as NULL.
		// leave 'side' as zero too (not needed for minisegs).

		seg->sector = buddy->sector = cur->after;

		seg->index = buddy->index = -1;

		seg->source_line = buddy->source_line = part->linedef;

		RecomputeSeg(seg);
		RecomputeSeg(buddy);

		// add the new segs to the appropriate lists
		AddSegToSuper(right_list, seg);
		AddSegToSuper(left_list, buddy);

#   if DEBUG_CUTLIST
		DebugPrintf("AddMiniseg: %p RIGHT  sector %d  (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n",
				seg, seg->sector ? seg->sector->index : -1,
				seg->start->x, seg->start->y, seg->end->x, seg->end->y);

		DebugPrintf("AddMiniseg: %p LEFT   sector %d  (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n",
				buddy, buddy->sector ? buddy->sector->index : -1,
				buddy->start->x, buddy->start->y, buddy->end->x, buddy->end->y);
#   endif
	}

	// free intersection structures into quick-alloc list
	while (cut_list)
	{
		cur = cut_list;
		cut_list = cur->next;

		cur->next = quick_alloc_cuts;
		quick_alloc_cuts = cur;
	}
}


//------------------------------------------------------------------------
// NODE : Recursively create nodes and return the pointers.
//------------------------------------------------------------------------


//
// Split a list of segs into two using the method described at bottom
// of the file, this was taken from OBJECTS.C in the DEU5beta source.
//
// This is done by scanning all of the segs and finding the one that
// does the least splitting and has the least difference in numbers of
// segs on either side.
//
// If the ones on the left side make a SSector, then create another SSector
// else put the segs into lefts list.
// If the ones on the right side make a SSector, then create another SSector
// else put the segs into rights list.
//
// Rewritten by Andrew Apted (-AJA-), 1999-2000.
//


#define DEBUG_BUILDER  0
#define DEBUG_SORTER   0
#define DEBUG_SUBSEC   0


static superblock_t *quick_alloc_supers = NULL;


//
// Returns -1 for left, +1 for right, or 0 for intersect.
//
static int PointOnLineSide(seg_t *part, double x, double y)
{
	double perp = UtilPerpDist(part, x, y);

	if (fabs(perp) <= DIST_EPSILON)
		return 0;

	return (perp < 0) ? -1 : +1;
}


int BoxOnLineSide(superblock_t *box, seg_t *part)
{
	double x1 = (double)box->x1 - IFFY_LEN * 1.5;
	double y1 = (double)box->y1 - IFFY_LEN * 1.5;
	double x2 = (double)box->x2 + IFFY_LEN * 1.5;
	double y2 = (double)box->y2 + IFFY_LEN * 1.5;

	int p1, p2;

	// handle simple cases (vertical & horizontal lines)
	if (part->pdx == 0)
	{
		p1 = (x1 > part->psx) ? +1 : -1;
		p2 = (x2 > part->psx) ? +1 : -1;

		if (part->pdy < 0)
		{
			p1 = -p1;
			p2 = -p2;
		}
	}
	else if (part->pdy == 0)
	{
		p1 = (y1 < part->psy) ? +1 : -1;
		p2 = (y2 < part->psy) ? +1 : -1;

		if (part->pdx < 0)
		{
			p1 = -p1;
			p2 = -p2;
		}
	}
	// now handle the cases of positive and negative slope
	else if (part->pdx * part->pdy > 0)
	{
		p1 = PointOnLineSide(part, x1, y2);
		p2 = PointOnLineSide(part, x2, y1);
	}
	else  // NEGATIVE
	{
		p1 = PointOnLineSide(part, x1, y1);
		p2 = PointOnLineSide(part, x2, y2);
	}

	if (p1 == p2)
		return p1;

	return 0;
}


/* ----- super block routines ------------------------------------ */

static superblock_t *NewSuperBlock(void)
{
	superblock_t *block;

	if (quick_alloc_supers == NULL)
		return (superblock_t *)UtilCalloc(sizeof(superblock_t));

	block = quick_alloc_supers;
	quick_alloc_supers = block->subs[0];

	// clear out any old rubbish
	memset(block, 0, sizeof(superblock_t));

	return block;
}


void FreeQuickAllocSupers(void)
{
	while (quick_alloc_supers)
	{
		superblock_t *block = quick_alloc_supers;
		quick_alloc_supers = block->subs[0];

		UtilFree(block);
	}
}


void FreeSuper(superblock_t *block)
{
	int num;

	// this only happens when node-building was cancelled by the GUI
	if (block->segs)
		block->segs = NULL;

	// recursively handle sub-blocks
	for (num=0 ; num < 2 ; num++)
	{
		if (block->subs[num])
			FreeSuper(block->subs[num]);
	}

	// add block to quick-alloc list.  Note that subs[0] is used for
	// linking the blocks together.

	block->subs[0] = quick_alloc_supers;
	quick_alloc_supers = block;
}


#if 0 // DEBUGGING CODE
static void TestSuperWorker(superblock_t *block, int *real, int *mini)
{
	seg_t *seg;
	int num;

	for (seg=block->segs ; seg ; seg=seg->next)
	{
		if (seg->linedef)
			(*real) += 1;
		else
			(*mini) += 1;
	}

	for (num=0 ; num < 2 ; num++)
	{
		if (block->subs[num])
			TestSuperWorker(block->subs[num], real, mini);
	}
}

void TestSuper(superblock_t *block)
{
	int real_num = 0;
	int mini_num = 0;

	TestSuperWorker(block, &real_num, &mini_num);

	if (real_num != block->real_num || mini_num != block->mini_num)
		BugError("TestSuper FAILED: block=%p %d/%d != %d/%d\n",
				block, block->real_num, block->mini_num, real_num, mini_num);
}
#endif


void AddSegToSuper(superblock_t *block, seg_t *seg)
{
	for (;;)
	{
		int p1, p2;
		int child;

		int x_mid = (block->x1 + block->x2) / 2;
		int y_mid = (block->y1 + block->y2) / 2;

		superblock_t *sub;

		// update seg counts
		if (seg->linedef)
			block->real_num++;
		else
			block->mini_num++;

		if (SUPER_IS_LEAF(block))
		{
			// block is a leaf -- no subdivision possible

			seg->next = block->segs;
			seg->block = block;

			block->segs = seg;
			return;
		}

		if (block->x2 - block->x1 >= block->y2 - block->y1)
		{
			// block is wider than it is high, or square

			p1 = seg->start->x >= x_mid;
			p2 = seg->end->x   >= x_mid;
		}
		else
		{
			// block is higher than it is wide

			p1 = seg->start->y >= y_mid;
			p2 = seg->end->y   >= y_mid;
		}

		if (p1 && p2)
			child = 1;
		else if (!p1 && !p2)
			child = 0;
		else
		{
			// line crosses midpoint -- link it in and return

			seg->next = block->segs;
			seg->block = block;

			block->segs = seg;
			return;
		}

		// OK, the seg lies in one half of this block.  Create the block
		// if it doesn't already exist, and loop back to add the seg.

		if (! block->subs[child])
		{
			block->subs[child] = sub = NewSuperBlock();
			sub->parent = block;

			if (block->x2 - block->x1 >= block->y2 - block->y1)
			{
				sub->x1 = child ? x_mid : block->x1;
				sub->y1 = block->y1;

				sub->x2 = child ? block->x2 : x_mid;
				sub->y2 = block->y2;
			}
			else
			{
				sub->x1 = block->x1;
				sub->y1 = child ? y_mid : block->y1;

				sub->x2 = block->x2;
				sub->y2 = child ? block->y2 : y_mid;
			}
		}

		block = block->subs[child];
	}
}


void SplitSegInSuper(superblock_t *block, seg_t *seg)
{
	do
	{
		// update seg counts
		if (seg->linedef)
			block->real_num++;
		else
			block->mini_num++;

		block = block->parent;
	}
	while (block != NULL);
}

static seg_t *CreateOneSeg(linedef_t *line, vertex_t *start, vertex_t *end,
		sidedef_t *side, int side_num)
{
	seg_t *seg = NewSeg();

	// check for bad sidedef
	if (! side->sector)
	{
		Warning("Bad sidedef on linedef #%d (Z_CheckHeap error)\n", line->index);
	}

	seg->start   = start;
	seg->end     = end;
	seg->linedef = line;
	seg->side    = side_num;
	seg->sector  = side->sector;
	seg->partner = NULL;

	seg->source_line = seg->linedef;
	seg->index = -1;

	RecomputeSeg(seg);

	return seg;
}


//
// Initially create all segs, one for each linedef.
// Must be called *after* InitBlockmap().
//
superblock_t *CreateSegs(void)
{
	int i;
	int bw, bh;

	seg_t *left, *right;
	superblock_t *block;

	block = NewSuperBlock();

	GetBlockmapBounds(&block->x1, &block->y1, &bw, &bh);

	block->x2 = block->x1 + 128 * RoundPOW2(bw);
	block->y2 = block->y1 + 128 * RoundPOW2(bh);

	// step through linedefs and get side numbers

	for (i=0 ; i < num_linedefs ; i++)
	{
		linedef_t *line = LookupLinedef(i);

		right = NULL;

		// ignore zero-length lines
		if (line->zero_len)
			continue;

		// ignore overlapping lines
		if (line->overlap)
			continue;

		// check for Humungously long lines
		if (ABS(line->start->x - line->end->x) >= 10000 ||
			ABS(line->start->y - line->end->y) >= 10000)
		{
			if (UtilComputeDist(line->start->x - line->end->x,
				line->start->y - line->end->y) >= 30000)
			{
				Warning("Linedef #%d is VERY long, it may cause problems\n", line->index);
			}
		}

		if (line->right)
		{
			right = CreateOneSeg(line, line->start, line->end, line->right, 0);
			AddSegToSuper(block, right);
		}
		else
			Warning("Linedef #%d has no right sidedef!\n", line->index);

		if (line->left)
		{
			left = CreateOneSeg(line, line->end, line->start, line->left, 1);
			AddSegToSuper(block, left);

			if (right)
			{
				// -AJA- Partner segs.  These always maintain a one-to-one
				//       correspondence, so if one of the gets split, the
				//       other one must be split too.

				left->partner = right;
				right->partner = left;
			}
		}
		else
		{
			if (line->two_sided)
			{
				Warning("Linedef #%d is 2s but has no left sidedef\n", line->index);
				line->two_sided = 0;
			}
		}
	}

	return block;
}


static void DetermineMiddle(subsec_t *sub)
{
	seg_t *seg;

	double mid_x=0, mid_y=0;
	int total=0;

	// compute middle coordinates
	for (seg=sub->seg_list ; seg ; seg=seg->next)
	{
		mid_x += seg->start->x + seg->end->x;
		mid_y += seg->start->y + seg->end->y;

		total += 2;
	}

	sub->mid_x = mid_x / total;
	sub->mid_y = mid_y / total;
}


//
// -AJA- Put the list of segs into clockwise order.
//       Uses the now famous "double bubble" sorter :).
//
static void ClockwiseOrder(subsec_t *sub)
{
	seg_t *seg;
	seg_t ** array;
	seg_t *seg_buffer[32];

	int i;
	int total = 0;

	int first = 0;
	int score = -1;

# if DEBUG_SUBSEC
	DebugPrintf("Subsec: Clockwising %d\n", sub->index);
# endif

	// count segs and create an array to manipulate them
	for (seg=sub->seg_list ; seg ; seg=seg->next)
		total++;

	// use local array if small enough
	if (total <= 32)
		array = seg_buffer;
	else
		array = (seg_t **) UtilCalloc(total * sizeof(seg_t *));

	for (seg=sub->seg_list, i=0 ; seg ; seg=seg->next, i++)
		array[i] = seg;

	if (i != total)
		BugError("ClockwiseOrder miscounted.\n");

	// sort segs by angle (from the middle point to the start vertex).
	// The desired order (clockwise) means descending angles.

	i = 0;

	while (i+1 < total)
	{
		seg_t *A = array[i];
		seg_t *B = array[i+1];

		angle_g angle1, angle2;

		angle1 = UtilComputeAngle(A->start->x - sub->mid_x, A->start->y - sub->mid_y);
		angle2 = UtilComputeAngle(B->start->x - sub->mid_x, B->start->y - sub->mid_y);

		if (angle1 + ANG_EPSILON < angle2)
		{
			// swap 'em
			array[i] = B;
			array[i+1] = A;

			// bubble down
			if (i > 0)
				i--;
		}
		else
		{
			// bubble up
			i++;
		}
	}

	// choose the seg that will be first (the game engine will typically use
	// that to determine the sector).  In particular, we don't like self
	// referencing linedefs (they are often used for deep-water effects).
	for (i=0 ; i < total ; i++)
	{
		int cur_score = 3;

		if (! array[i]->linedef)
			cur_score = 0;
		else if (array[i]->linedef->self_ref)
			cur_score = 2;

		if (cur_score > score)
		{
			first = i;
			score = cur_score;
		}
	}

	// transfer sorted array back into sub
	sub->seg_list = NULL;

	for (i=total-1 ; i >= 0 ; i--)
	{
		int j = (i + first) % total;

		array[j]->next = sub->seg_list;
		sub->seg_list  = array[j];
	}

	if (total > 32)
		UtilFree(array);

# if DEBUG_SORTER
	DebugPrintf("Sorted SEGS around (%1.1f,%1.1f)\n", sub->mid_x, sub->mid_y);

	for (seg=sub->seg_list ; seg ; seg=seg->next)
	{
		angle_g angle = UtilComputeAngle(seg->start->x - sub->mid_x,
				seg->start->y - sub->mid_y);

		DebugPrintf("  Seg %p: Angle %1.6f  (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n",
				seg, angle, seg->start->x, seg->start->y, seg->end->x, seg->end->y);
	}
# endif
}


static void SanityCheckClosed(subsec_t *sub)
{
	seg_t *seg, *next;
	int total=0, gaps=0;

	for (seg=sub->seg_list ; seg ; seg=seg->next)
	{
		next = seg->next ? seg->next : sub->seg_list;

		if (seg->end->x != next->start->x || seg->end->y != next->start->y)
			gaps++;

		total++;
	}

	if (gaps > 0)
	{
		MinorIssue("Subsector #%d near (%1.1f,%1.1f) is not closed "
				"(%d gaps, %d segs)\n", sub->index,
				sub->mid_x, sub->mid_y, gaps, total);

#   if DEBUG_SUBSEC
		for (seg=sub->seg_list ; seg ; seg=seg->next)
		{
			DebugPrintf("  SEG %p  (%1.1f,%1.1f) --> (%1.1f,%1.1f)\n", seg,
					seg->start->x, seg->start->y, seg->end->x, seg->end->y);
		}
#   endif
	}
}


static void SanityCheckSameSector(subsec_t *sub)
{
	seg_t *seg;
	seg_t *compare;

	// find a suitable seg for comparison
	for (compare=sub->seg_list ; compare ; compare=compare->next)
	{
		if (! compare->sector)
			continue;

		if (compare->sector->coalesce)
			continue;

		break;
	}

	if (! compare)
		return;

	for (seg=compare->next ; seg ; seg=seg->next)
	{
		if (! seg->sector)
			continue;

		if (seg->sector == compare->sector)
			continue;

		// All subsectors must come from same sector unless it's marked
		// "special" with sector tag >= 900. Original idea, Lee Killough
		if (seg->sector->coalesce)
			continue;

		// prevent excessive number of warnings
		if (compare->sector->warned_facing == seg->sector->index)
			continue;

		compare->sector->warned_facing = seg->sector->index;

		if (seg->linedef)
			MinorIssue("Sector #%d has sidedef facing #%d (line #%d) "
					"near (%1.0f,%1.0f).\n", compare->sector->index,
					seg->sector->index, seg->linedef->index,
					sub->mid_x, sub->mid_y);
		else
			MinorIssue("Sector #%d has sidedef facing #%d "
					"near (%1.0f,%1.0f).\n", compare->sector->index,
					seg->sector->index, sub->mid_x, sub->mid_y);
	}
}


static void SanityCheckHasRealSeg(subsec_t *sub)
{
	seg_t *seg;

	for (seg=sub->seg_list ; seg ; seg=seg->next)
	{
		if (seg->linedef)
			return;
	}

	BugError("Subsector #%d near (%1.1f,%1.1f) has no real seg!\n",
			sub->index, sub->mid_x, sub->mid_y);
}


static void RenumberSubsecSegs(subsec_t *sub)
{
	seg_t *seg;

# if DEBUG_SUBSEC
	DebugPrintf("Subsec: Renumbering %d\n", sub->index);
# endif

	sub->seg_count = 0;

	for (seg=sub->seg_list ; seg ; seg=seg->next)
	{
		seg->index = num_complete_seg;
		num_complete_seg++;

		sub->seg_count++;

#   if DEBUG_SUBSEC
		DebugPrintf("Subsec:   %d: Seg %p  Index %d\n", sub->seg_count,
				seg, seg->index);
#   endif
	}
}


static void CreateSubsecWorker(subsec_t *sub, superblock_t *block)
{
	int num;

	while (block->segs)
	{
		// unlink first seg from block
		seg_t *seg = block->segs;
		block->segs = seg->next;

		// link it into head of the subsector's list
		seg->next = sub->seg_list;
		seg->block = NULL;

		sub->seg_list = seg;
	}

	// recursively handle sub-blocks

	for (num=0 ; num < 2 ; num++)
	{
		superblock_t *A = block->subs[num];

		if (A)
		{
			CreateSubsecWorker(sub, A);

			if (A->real_num + A->mini_num > 0)
				BugError("CreateSubsec: child %d not empty!\n", num);

			FreeSuper(A);
			block->subs[num] = NULL;
		}
	}

	block->real_num = block->mini_num = 0;
}


//
// Create a subsector from a list of segs.
//
static subsec_t *CreateSubsec(superblock_t *seg_list)
{
	subsec_t *sub = NewSubsec();

	// compute subsector's index
	sub->index = num_subsecs - 1;

	// copy segs into subsector
	CreateSubsecWorker(sub, seg_list);

	DetermineMiddle(sub);

# if DEBUG_SUBSEC
	DebugPrintf("Subsec: Creating %d\n", sub->index);
# endif

	return sub;
}


int ComputeBspHeight(node_t *node)
{
	if (node)
	{
		int left, right;

		right = ComputeBspHeight(node->r.node);
		left  = ComputeBspHeight(node->l.node);

		return MAX(left, right) + 1;
	}

	return 1;
}


#if DEBUG_BUILDER

static void DebugShowSegs(superblock_t *seg_list)
{
	seg_t *seg;
	int num;

	for (seg=seg_list->segs ; seg ; seg=seg->next)
	{
		DebugPrintf("Build:   %sSEG %p  sector=%d  (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n",
				seg->linedef ? "" : "MINI", seg, seg->sector->index,
				seg->start->x, seg->start->y, seg->end->x, seg->end->y);
	}

	for (num=0 ; num < 2 ; num++)
	{
		if (seg_list->subs[num])
			DebugShowSegs(seg_list->subs[num]);
	}
}
#endif


build_result_e BuildNodes(superblock_t *seg_list,
						  node_t ** N, subsec_t ** S,
						  int depth, const bbox_t *bbox)
{
	node_t *node;
	seg_t *best;

	superblock_t *rights;
	superblock_t *lefts;

	intersection_t *cut_list;

	build_result_e ret;

	*N = NULL;
	*S = NULL;

	if (cur_info->cancelled)
		return BUILD_Cancelled;

# if DEBUG_BUILDER
	DebugPrintf("Build: BEGUN @ %d\n", depth);
	DebugShowSegs(seg_list);
# endif

	/* pick best node to use.  None indicates convexicity */
	best = PickNode(seg_list, depth, bbox);

	if (best == NULL)
	{
		if (cur_info->cancelled)
			return BUILD_Cancelled;

#   if DEBUG_BUILDER
		DebugPrintf("Build: CONVEX\n");
#   endif

		*S = CreateSubsec(seg_list);

		return BUILD_OK;
	}

# if DEBUG_BUILDER
	DebugPrintf("Build: PARTITION %p (%1.0f,%1.0f) -> (%1.0f,%1.0f)\n",
			best, best->start->x, best->start->y, best->end->x, best->end->y);
# endif

	/* create left and right super blocks */
	lefts  = (superblock_t *) NewSuperBlock();
	rights = (superblock_t *) NewSuperBlock();

	lefts->x1 = rights->x1 = seg_list->x1;
	lefts->y1 = rights->y1 = seg_list->y1;
	lefts->x2 = rights->x2 = seg_list->x2;
	lefts->y2 = rights->y2 = seg_list->y2;

	/* divide the segs into two lists: left & right */
	cut_list = NULL;

	SeparateSegs(seg_list, best, lefts, rights, &cut_list);

	/* sanity checks... */
	if (rights->real_num + rights->mini_num == 0)
		BugError("Separated seg-list has no RIGHT side\n");

	if (lefts->real_num + lefts->mini_num == 0)
		BugError("Separated seg-list has no LEFT side\n");

	AddMinisegs(best, lefts, rights, cut_list);

	*N = node = NewNode();

	SYS_ASSERT(best->linedef);

	if (best->side == 0)
	{
		node->x  = best->linedef->start->x;
		node->y  = best->linedef->start->y;
		node->dx = best->linedef->end->x - node->x;
		node->dy = best->linedef->end->y - node->y;
	}
	else  /* left side */
	{
		node->x  = best->linedef->end->x;
		node->y  = best->linedef->end->y;
		node->dx = best->linedef->start->x - node->x;
		node->dy = best->linedef->start->y - node->y;
	}

	/* check for really long partition (overflows dx,dy in NODES) */
	if (best->p_length >= 30000)
	{
		if (node->dx && node->dy && ((node->dx & 1) || (node->dy & 1)))
		{
			MinorIssue("Loss of accuracy on VERY long node: "
					"(%d,%d) -> (%d,%d)\n", node->x, node->y,
					node->x + node->dx, node->y + node->dy);
		}

		node->too_long = 1;
	}

	/* find limits of vertices */
	FindLimits(lefts,  &node->l.bounds);
	FindLimits(rights, &node->r.bounds);

# if DEBUG_BUILDER
	DebugPrintf("Build: Going LEFT\n");
# endif

	ret = BuildNodes(lefts,  &node->l.node, &node->l.subsec, depth+1,
			&node->l.bounds);
	FreeSuper(lefts);

	if (ret != BUILD_OK)
	{
		FreeSuper(rights);
		return ret;
	}

# if DEBUG_BUILDER
	DebugPrintf("Build: Going RIGHT\n");
# endif

	ret = BuildNodes(rights, &node->r.node, &node->r.subsec, depth+1,
			&node->r.bounds);
	FreeSuper(rights);

# if DEBUG_BUILDER
	DebugPrintf("Build: DONE\n");
# endif

	return ret;
}


void ClockwiseBspTree()
{
	num_complete_seg = 0;

	for (int i=0 ; i < num_subsecs ; i++)
	{
		subsec_t *sub = LookupSubsec(i);

		ClockwiseOrder(sub);
		RenumberSubsecSegs(sub);

		// do some sanity checks
		SanityCheckClosed(sub);
		SanityCheckSameSector(sub);
		SanityCheckHasRealSeg(sub);
	}
}

static void NormaliseSubsector(subsec_t *sub)
{
	seg_t *new_head = NULL;
	seg_t *new_tail = NULL;

# if DEBUG_SUBSEC
	DebugPrintf("Subsec: Normalising %d\n", sub->index);
# endif

	while (sub->seg_list)
	{
		// remove head
		seg_t *seg = sub->seg_list;
		sub->seg_list = seg->next;

		// only add non-minisegs to new list
		if (seg->linedef)
		{
			seg->next = NULL;

			if (new_tail)
				new_tail->next = seg;
			else
				new_head = seg;

			new_tail = seg;

			// this updated later
			seg->index = -1;
		}
		else
		{
#     if DEBUG_SUBSEC
			DebugPrintf("Subsec: Removing miniseg %p\n", seg);
#     endif

			// set index to a really high value, so that SortSegs() will
			// move all the minisegs to the top of the seg array.
			seg->index = 1<<24;
		}
	}

	if (new_head == NULL)
		BugError("Subsector %d normalised to being EMPTY\n", sub->index);

	sub->seg_list = new_head;
}


void NormaliseBspTree()
{
	// unlinks all minisegs from each subsector

	num_complete_seg = 0;

	for (int i=0 ; i < num_subsecs ; i++)
	{
		subsec_t *sub = LookupSubsec(i);

		NormaliseSubsector(sub);
		RenumberSubsecSegs(sub);
	}
}


static void RoundOffVertices()
{
	for (int i = 0 ; i < num_vertices ; i++)
	{
		vertex_t *vert = LookupVertex(i);

		if (vert->is_new)
		{
			vert->is_new = 0;

			vert->index = num_old_vert;
			num_old_vert++;
		}
	}
}


static void RoundOffSubsector(subsec_t *sub)
{
	seg_t *new_head = NULL;
	seg_t *new_tail = NULL;

	seg_t *seg;
	seg_t *last_real_degen = NULL;

	int real_total  = 0;
	int degen_total = 0;

# if DEBUG_SUBSEC
	DebugPrintf("Subsec: Rounding off %d\n", sub->index);
# endif

	// do an initial pass, just counting the degenerates
	for (seg=sub->seg_list ; seg ; seg=seg->next)
	{
		// is the seg degenerate ?
		if (I_ROUND(seg->start->x) == I_ROUND(seg->end->x) &&
			I_ROUND(seg->start->y) == I_ROUND(seg->end->y))
		{
			seg->is_degenerate = 1;

			if (seg->linedef)
				last_real_degen = seg;

			degen_total++;
			continue;
		}

		if (seg->linedef)
			real_total++;
	}

# if DEBUG_SUBSEC
	DebugPrintf("Subsec: degen=%d real=%d\n", degen_total, real_total);
# endif

	// handle the (hopefully rare) case where all of the real segs
	// became degenerate.
	if (real_total == 0)
	{
		if (last_real_degen == NULL)
			BugError("Subsector %d rounded off with NO real segs\n",
					sub->index);

#   if DEBUG_SUBSEC
		DebugPrintf("Degenerate before: (%1.2f,%1.2f) -> (%1.2f,%1.2f)\n",
				last_real_degen->start->x, last_real_degen->start->y,
				last_real_degen->end->x, last_real_degen->end->y);
#   endif

		// create a new vertex for this baby
		last_real_degen->end = NewVertexDegenerate(
				last_real_degen->start, last_real_degen->end);

#   if DEBUG_SUBSEC
		DebugPrintf("Degenerate after:  (%d,%d) -> (%d,%d)\n",
				I_ROUND(last_real_degen->start->x),
				I_ROUND(last_real_degen->start->y),
				I_ROUND(last_real_degen->end->x),
				I_ROUND(last_real_degen->end->y));
#   endif

		last_real_degen->is_degenerate = 0;
	}

	// second pass, remove the blighters...
	while (sub->seg_list)
	{
		// remove head
		seg = sub->seg_list;
		sub->seg_list = seg->next;

		if (! seg->is_degenerate)
		{
			seg->next = NULL;

			if (new_tail)
				new_tail->next = seg;
			else
				new_head = seg;

			new_tail = seg;

			// this updated later
			seg->index = -1;
		}
		else
		{
#     if DEBUG_SUBSEC
			DebugPrintf("Subsec: Removing degenerate %p\n", seg);
#     endif

			// set index to a really high value, so that SortSegs() will
			// move all the minisegs to the top of the seg array.
			seg->index = 1<<24;
		}
	}

	if (new_head == NULL)
		BugError("Subsector %d rounded off to being EMPTY\n", sub->index);

	sub->seg_list = new_head;
}


void RoundOffBspTree()
{
	num_complete_seg = 0;

	RoundOffVertices();

	for (int i=0 ; i < num_subsecs ; i++)
	{
		subsec_t *sub = LookupSubsec(i);

		RoundOffSubsector(sub);
		RenumberSubsecSegs(sub);
	}
}


}  // namespace ajbsp

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
