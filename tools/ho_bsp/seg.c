//------------------------------------------------------------------------
// SEG : Choose the best Seg to use for a node line.
//------------------------------------------------------------------------
//
//  GL-Friendly Node Builder (C) 2000-2007 Andrew Apted
//
//  Based on 'BSP 2.3' by Colin Reed, Lee Killough and others.
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

#include "system.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <ctype.h>
#include <math.h>
#include <limits.h>
#include <assert.h>

#include "analyze.h"
#include "level.h"
#include "node.h"
#include "seg.h"
#include "structs.h"
#include "util.h"
#include "wad.h"


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


//
// NewIntersection
//
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
    cut = UtilCalloc(sizeof(intersection_t));
  }

  return cut;
}

//
// FreeQuickAllocCuts
//
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
// RecomputeSeg
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
  seg->p_angle  = UtilComputeAngle(seg->pdx, seg->pdy);

  if (seg->p_length <= 0)
    InternalError("Seg %p has zero p_length.", seg);

  seg->p_perp =  seg->psy * seg->pdx - seg->psx * seg->pdy;
  seg->p_para = -seg->psx * seg->pdx - seg->psy * seg->pdy;
}


//
// SplitSeg
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
static seg_t *SplitSeg(seg_t *old_seg, double x, double y)
{
  seg_t *new_seg;
  vertex_t *new_vert;

# if DEBUG_SPLIT
  if (old_seg->linedef)
    PrintDebug("Splitting Linedef %d (%p) at (%1.1f,%1.1f)\n",
        old_seg->linedef->index, old_seg, x, y);
  else
    PrintDebug("Splitting Miniseg %p at (%1.1f,%1.1f)\n", old_seg, x, y);
# endif

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
  PrintDebug("Splitting Vertex is %04X at (%1.1f,%1.1f)\n",
      new_vert->index, new_vert->x, new_vert->y);
# endif

  // handle partners

  if (old_seg->partner)
  {
#   if DEBUG_SPLIT
    PrintDebug("Splitting Partner %p\n", old_seg->partner);
#   endif

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
// ComputeIntersection
//
// -AJA- In the quest for slime-trail annihilation :->, this routine
//       calculates the intersection location between the current seg
//       and the partitioning seg, and takes advantage of some common
//       situations like horizontal/vertical lines.
//
static INLINE_G void ComputeIntersection(seg_t *cur, seg_t *part,
  double perp_c, double perp_d, double *x, double *y)
{
  double ds;

  // horizontal partition against vertical seg
  if (part->pdy == 0 && cur->pdx == 0)
  {
    *x = cur->psx;
    *y = part->psy;
    return;
  }
  
  // vertical partition against horizontal seg
  if (part->pdx == 0 && cur->pdy == 0)
  {
    *x = part->psx;
    *y = cur->psy;
    return;
  }
  
  // 0 = start, 1 = end
  ds = perp_c / (perp_c - perp_d);

  if (cur->pdx == 0)
    *x = cur->psx;
  else
    *x = cur->psx + (cur->pdx * ds);

  if (cur->pdy == 0)
    *y = cur->psy;
  else
    *y = cur->psy + (cur->pdy * ds);
}


//
// AddIntersection
//
static void AddIntersection(intersection_t ** cut_list,
    vertex_t *vert, seg_t *part)
{
  intersection_t *cut;
  intersection_t *next;

  /* check if vertex already present */
  for (cut=(*cut_list); cut; cut=cut->next)
  {
    if (vert == cut->vertex)
      return;
  }

  /* create new intersection */
  cut = NewIntersection();

  cut->vertex = vert;
  cut->along_dist = UtilParallelDist(part, vert->x, vert->y);
 
  sector_t * before = VertexCheckOpen(vert, -part->pdx, -part->pdy);
  sector_t * after  = VertexCheckOpen(vert,  part->pdx,  part->pdy);

  /* HO-BSP : only the currently processed sector is "open" */

  cut->before = (before == build_sector) ? 1 : 0;
  cut->after  = (after  == build_sector) ? 1 : 0;
 
  /* enqueue the new intersection into the list */

  for (next=(*cut_list); next && next->next; next=next->next)
  { }

  while (next && cut->along_dist < next->along_dist) 
    next = next->prev;
  
  /* link it in */
  cut->next = next ? next->next : (*cut_list);
  cut->prev = next;

  if (next)
  {
    if (next->next)
      next->next->prev = cut;
    
    next->next = cut;
  }
  else
  {
    if (*cut_list)
      (*cut_list)->prev = cut;
    
    (*cut_list) = cut;
  }
}


//
// EvalPartitionWorker
//
// Returns TRUE if a "bad seg" was found early.
//
static int EvalPartitionWorker(seg_t *seg_list, seg_t *part, 
    int best_cost, eval_info_t *info)
{
  seg_t *check;

  double qnty;
  double a, b, fa, fb;

  int factor = cur_info->factor;

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

  for (check = seg_list ; check ; check = check->next)
  { 
    // This is the heart of my pruning idea - it catches
    // bad segs early on. Killough

    if (info->cost > best_cost)
      return TRUE;

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

  /* no "bad seg" was found */
  return FALSE;
}

//
// EvalPartition
//
// -AJA- Evaluate a partition seg & determine the cost, taking into
//       account the number of splits, difference between left &
//       right, and linedefs that are tagged 'precious'.
//
// Returns the computed cost, or a negative value if the seg should be
// skipped altogether.
//
static int EvalPartition(seg_t *seg_list, seg_t *part, 
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
    PrintDebug("Eval : No real segs on %s%sside\n", 
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
  PrintDebug("Eval %p: splits=%d iffy=%d near=%d left=%d+%d right=%d+%d "
      "cost=%d.%02d\n", part, info.splits, info.iffy, info.near_miss, 
      info.real_left, info.mini_left, info.real_right, info.mini_right, 
      info.cost / 100, info.cost % 100);
# endif
 
  return info.cost;
}


/* returns FALSE if cancelled */
static int PickNodeWorker(seg_t *part_list, 
    seg_t *seg_list, seg_t ** best, int *best_cost,
    int *progress, int prog_step)
{
  seg_t *part;

  int cost;

  /* use each Seg as partition */
  for (part = part_list ; part ; part = part->next)
  {
    if (cur_comms->cancelled)
      return FALSE;

#   if DEBUG_PICKNODE
    PrintDebug("PickNode:   %sSEG %p  sector=%d  (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n",
      part->linedef ? "" : "MINI", part, 
      part->sector ? part->sector->index : -1,
      part->start->x, part->start->y, part->end->x, part->end->y);
#   endif

    /* something for the user to look at */
    (*progress) += 1;

    if ((*progress % prog_step) == 0)
    {
      cur_comms->build_pos++;
      DisplaySetBar(1, cur_comms->build_pos);
      DisplaySetBar(2, cur_comms->file_pos + cur_comms->build_pos / 100);
    }

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

  DisplayTicker();

  return TRUE;
}

//
// PickNode
//
// Find the best seg in the seg_list to use as a partition line.
//
seg_t *PickNode(seg_t *seg_list, int depth)
{
  seg_t *best=NULL;

  int best_cost=INT_MAX;

  int progress=0;
  int prog_step=1<<24;
  int build_step=0;

# if DEBUG_PICKNODE
  PrintDebug("PickNode: BEGUN (depth %d)\n", depth);
# endif

  /* compute info for showing progress */

/*
  if (depth <= 6)
  {
    static int depth_counts[7] = { 248, 100, 30, 10, 6, 4, 2 };
    
    int total = seg_list->real_num + seg_list->mini_num;

    build_step = depth_counts[depth];
    prog_step = 1 + ((total - 1) / build_step);

    if (total / prog_step < build_step)
    {
      cur_comms->build_pos += build_step - total / prog_step;
      build_step = total / prog_step;

      DisplaySetBar(1, cur_comms->build_pos);
      DisplaySetBar(2, cur_comms->file_pos + cur_comms->build_pos / 100);
    }
  }
*/
  DisplayTicker();

  if (FALSE == PickNodeWorker(seg_list, seg_list, &best, &best_cost, 
      &progress, prog_step))
  {
    /* hack here : BuildNodes will detect the cancellation */
    return NULL;
  }

# if DEBUG_PICKNODE
  if (! best)
  {
    PrintDebug("PickNode: NO BEST FOUND !\n");
  }
  else
  {
    PrintDebug("PickNode: Best has score %d.%02d  (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n", 
      best_cost / 100, best_cost % 100, best->start->x, best->start->y,
      best->end->x, best->end->y);
  }
# endif

  /* all finished, return best Seg */
  return best;
}


//
// DivideOneSeg
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
void DivideOneSeg(seg_t *cur, seg_t *part, 
    seg_t ** left_list, seg_t ** right_list,
    intersection_t ** cut_list)
{
  seg_t *new_seg;

  double x, y;

  /* get state of lines' relation to each other */
  double a = UtilPerpDist(part, cur->psx, cur->psy);
  double b = UtilPerpDist(part, cur->pex, cur->pey);

  if (cur->source_line == part->source_line)
    a = b = 0;

  /* check for being on the same line */
  if (fabs(a) <= DIST_EPSILON && fabs(b) <= DIST_EPSILON)
  {
    AddIntersection(cut_list, cur->start, part);
    AddIntersection(cut_list, cur->end,   part);

    // this seg runs along the same line as the partition.  check
    // whether it goes in the same direction or the opposite.

    if (cur->pdx*part->pdx + cur->pdy*part->pdy < 0)
    {
      AddSegToList(left_list, cur);
    }
    else
    {
      AddSegToList(right_list, cur);
    }

    return;
  }

  /* check for right side */
  if (a > -DIST_EPSILON && b > -DIST_EPSILON)
  {
    if (a < DIST_EPSILON)
      AddIntersection(cut_list, cur->start, part);
    else if (b < DIST_EPSILON)
      AddIntersection(cut_list, cur->end, part);

    AddSegToList(right_list, cur);
    return;
  }
 
  /* check for left side */
  if (a < DIST_EPSILON && b < DIST_EPSILON)
  {
    if (a > -DIST_EPSILON)
      AddIntersection(cut_list, cur->start, part);
    else if (b > -DIST_EPSILON)
      AddIntersection(cut_list, cur->end, part);

    AddSegToList(left_list, cur);
    return;
  }
 
  // when we reach here, we have a and b non-zero and opposite sign,
  // hence this seg will be split by the partition line.
  
  ComputeIntersection(cur, part, a, b, &x, &y);

  new_seg = SplitSeg(cur, x, y);

  AddIntersection(cut_list, cur->end, part);

  if (a < 0)
  {
    AddSegToList(left_list,  cur);
    AddSegToList(right_list, new_seg);
  }
  else
  {
    AddSegToList(right_list, cur);
    AddSegToList(left_list,  new_seg);
  }
}

//
// SeparateSegs
//
void SeparateSegs(seg_t *seg_list, seg_t *part,
    seg_t ** left_list, seg_t ** right_list,
    intersection_t ** cut_list)
{
  while (seg_list)
  {
    seg_t *cur = seg_list;
    seg_list   = seg_list->next;

    DivideOneSeg(cur, part, left_list, right_list, cut_list);
  }
}


//
// AddMinisegs
//
void AddMinisegs(seg_t *part, 
    seg_t ** left_list, seg_t ** right_list, 
    intersection_t *cut_list)
{
  intersection_t *cur, *next;
  seg_t *seg, *buddy;

  if (! cut_list)
    return;

# if DEBUG_CUTLIST
  PrintDebug("CUT LIST:\n");
  PrintDebug("PARTITION: (%1.1f,%1.1f) += (%1.1f,%1.1f)\n",
      part->psx, part->psy, part->pdx, part->pdy);

  for (cur=cut_list ; cur ; cur=cur->next)
  {
    PrintDebug("  Vertex %8X (%1.1f,%1.1f)  Along %1.2f  [%d/%d]\n", 
        cur->vertex->index, cur->vertex->x, cur->vertex->y,
        cur->along_dist,
        cur->before, cur->after);
  }
# endif

  // STEP 1: fix problems the intersection list...

  cur  = cut_list;
  next = cur->next;

  while (cur && next)
  {
    double len = next->along_dist - cur->along_dist;

    if (len < -0.1)
      InternalError("Bad order in intersect list: %1.3f > %1.3f",
          cur->along_dist, next->along_dist);

    if (len > 0.2)
    {
      cur  = next;
      next = cur->next;
      continue;
    }

    if (len > DIST_EPSILON)
    {
      PrintMiniWarn("Skipping very short seg (len=%1.3f) near (%1.1f,%1.1f)\n",
          len, cur->vertex->x, cur->vertex->y);
    }

    // merge the two intersections into one

# if DEBUG_CUTLIST
    PrintDebug("Merging cut (%1.0f,%1.0f) [%d/%d] with %p (%1.0f,%1.0f) [%d/%d]\n",
        cur->vertex->x, cur->vertex->y,
        cur->before, cur->after,
        next->vertex,
        next->vertex->x, next->vertex->y,
        next->before, next->after);
# endif

    if (!cur->before && next->before)
      cur->before = next->before;

    if (!cur->after && next->after)
      cur->after = next->after;

# if DEBUG_CUTLIST
    PrintDebug("---> merged (%1.0f,%1.0f) [%d/%d]\n",
        cur->vertex->x, cur->vertex->y,
        cur->before, cur->after);
# endif

    // free the unused cut

    cur->next = next->next;

    next->next = quick_alloc_cuts;
    quick_alloc_cuts = next;

    next = cur->next;
  }

  // STEP 2: find connections in the intersection list...

  for (cur = cut_list; cur && cur->next; cur = cur->next)
  {
    next = cur->next;
    
    if (!cur->after && !next->before)
      continue;
 
    // check for some nasty OPEN/CLOSED or CLOSED/OPEN cases
    if ((cur->after && !next->before) ||
        (!cur->after && next->before))
    {
      PrintMiniWarn("Unclosed sector near (%1.1f,%1.1f)\n",
          (cur->vertex->x + next->vertex->x) / 2.0,
          (cur->vertex->y + next->vertex->y) / 2.0);
      continue;
    }

    /* Righteo, here we have definite open space */

    // create the miniseg pair
    seg   = NewSeg();
    buddy = NewSeg();

    seg->partner = buddy;
    buddy->partner = seg;

    seg->start = cur->vertex;
    seg->end   = next->vertex;

    buddy->start = next->vertex;
    buddy->end   = cur->vertex;

    // leave 'linedef' field as NULL.
    // leave 'side' as zero too (not needed for minisegs).

    seg->sector = buddy->sector = build_sector;

    seg->index = buddy->index = -1;

    seg->source_line = buddy->source_line = part->linedef;

    RecomputeSeg(seg);
    RecomputeSeg(buddy);

    // add the new segs to the appropriate lists
    AddSegToList(right_list, seg);
    AddSegToList(left_list, buddy);

#   if DEBUG_CUTLIST
    PrintDebug("AddMiniseg: %p RIGHT  sector %d  (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n",
        seg, seg->sector ? seg->sector->index : -1, 
        seg->start->x, seg->start->y, seg->end->x, seg->end->y);

    PrintDebug("AddMiniseg: %p LEFT   sector %d  (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n",
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

