//------------------------------------------------------------------------
// NODE : Recursively create nodes and return the pointers.
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


#define DEBUG_BUILDER  0
#define DEBUG_SORTER   0
#define DEBUG_SUBSEC   0

sector_t * build_sector;


//
// PointOnLineSide
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

//
// BoxOnLineSide
//
int BoxOnLineSide(seg_t *part, double x1, double y1, double x2, double y2)
{
  x1 -= IFFY_LEN * 1.5;
  y1 -= IFFY_LEN * 1.5;
  x2 += IFFY_LEN * 1.5;
  y2 += IFFY_LEN * 1.5;

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


//
// AddSegToList
//
void AddSegToList(seg_t ** list_ptr, seg_t *seg)
{
  seg->next  = *list_ptr;

  (*list_ptr) = seg;
}


static seg_t *CreateOneSeg(linedef_t *line, vertex_t *start, vertex_t *end,
    sidedef_t *side, int side_num)
{
  seg_t *seg = NewSeg();

  seg->start   = start;
  seg->end     = end;
  seg->linedef = line;
  seg->side    = side_num;
  seg->sector  = side ? side->sector : void_sector;
  seg->partner = NULL;

  seg->source_line = seg->linedef;
  seg->index = -1;

  RecomputeSeg(seg);

  // add the seg to the sector's list
  AddSegToList(&seg->sector->seg_list, seg);

  return seg;
}

//
// CreateSegs
//
// Initially create all segs, two for each linedef (usually).
//
void CreateSegs(void)
{
  int i;

  seg_t *left, *right;

  PrintVerbose("Creating Segs...\n");

  // step through linedefs and get side numbers

  DisplayTicker();

  for (i=0; i < num_linedefs; i++)
  {
    linedef_t *line = LookupLinedef(i);

    // check for Humungously long lines
    if (ABS(line->start->x - line->end->x) >= 10000 ||
        ABS(line->start->y - line->end->y) >= 10000)
    {
      if (UtilComputeDist(line->start->x - line->end->x,
          line->start->y - line->end->y) >= 30000)
      {
        PrintWarn("Linedef #%d is VERY long, it may cause problems\n",
            line->index);
      }
    }
    

    right = CreateOneSeg(line, line->start, line->end, line->right, 0);

    if (line->is_border)
      left = NULL;
    else
    {
      left = CreateOneSeg(line, line->end, line->start, line->left, 1);
    }

    if (left && right)
    {
        // -AJA- Partner segs.  These always maintain a one-to-one
        //       correspondence, so if one of the gets split, the
        //       other one must be split too.

        left->partner = right;
        right->partner = left;
    }
  }
}

//
// DetermineMiddle
//
static void DetermineMiddle(subsec_t *sub)
{
  seg_t *cur;

  double mid_x=0, mid_y=0;
  int total=0;

  // compute middle coordinates
  for (cur=sub->seg_list; cur; cur=cur->next)
  {
    mid_x += cur->start->x + cur->end->x;
    mid_y += cur->start->y + cur->end->y;

    total += 2;
  }

  sub->mid_x = mid_x / total;
  sub->mid_y = mid_y / total;
}

//
// ClockwiseOrder
//
// -AJA- Put the list of segs into clockwise order.
//       Uses the now famous "double bubble" sorter :).
//
static void ClockwiseOrder(subsec_t *sub)
{
  seg_t *cur;
  seg_t ** array;
  seg_t *seg_buffer[32];

  int i;
  int total = 0;

  int first = 0;
  int score = -1;

# if DEBUG_SUBSEC
  PrintDebug("Subsec: Clockwising %d (sector #%d)\n", sub->index, sub->sector->index);
# endif

  // count segs and create an array to manipulate them
  for (cur=sub->seg_list; cur; cur=cur->next)
    total++;

  // use local array if small enough
  if (total <= 32)
    array = seg_buffer;
  else
    array = UtilCalloc(total * sizeof(seg_t *));

  for (cur=sub->seg_list, i=0; cur; cur=cur->next, i++)
    array[i] = cur;

  if (i != total)
    InternalError("ClockwiseOrder miscounted.");

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
  for (i=0; i < total; i++)
  {
    int cur_score = 3;

    if (! array[i]->linedef)
      cur_score = 0;

    if (cur_score > score)
    {
      first = i;
      score = cur_score;
    }
  }

  // transfer sorted array back into sub
  sub->seg_list = NULL;

  for (i=total-1; i >= 0; i--)
  {
    int j = (i + first) % total;

    array[j]->next = sub->seg_list;
    sub->seg_list  = array[j];
  }
 
  if (total > 32)
    UtilFree(array);

# if DEBUG_SORTER
  PrintDebug("Sorted SEGS around (%1.1f,%1.1f)\n", sub->mid_x, sub->mid_y);

  for (cur=sub->seg_list; cur; cur=cur->next)
  {
    angle_g angle = UtilComputeAngle(cur->start->x - sub->mid_x,
        cur->start->y - sub->mid_y);
    
    PrintDebug("  Seg %p: Angle %1.6f  (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n",
      cur, angle, cur->start->x, cur->start->y, cur->end->x, cur->end->y);
  }
# endif
}

//
// SanityCheckClosed
//
static void SanityCheckClosed(subsec_t *sub)
{
  seg_t *cur, *next;
  int total=0, gaps=0;

  for (cur=sub->seg_list; cur; cur=cur->next)
  {
    next = cur->next ? cur->next : sub->seg_list;

    if (cur->end->x != next->start->x || cur->end->y != next->start->y)
      gaps++;

    total++;
  }

  if (gaps > 0)
  {
    PrintMiniWarn("Subsector #%d (sec #%d) near (%1.1f,%1.1f) is not closed "
        "(%d gaps, %d segs)\n", sub->index, sub->sector->index,
        sub->mid_x, sub->mid_y, gaps, total);

#   if DEBUG_SUBSEC
    for (cur=sub->seg_list; cur; cur=cur->next)
    {
      PrintDebug("  SEG %p  (%1.1f,%1.1f) --> (%1.1f,%1.1f)\n", cur,
          cur->start->x, cur->start->y, cur->end->x, cur->end->y);
    }
#   endif
  }
}

//
// SanityCheckSameSector
//
static void SanityCheckSameSector(subsec_t *sub)
{
  seg_t *cur;
  seg_t *compare;

  // find a suitable seg for comparison
  for (compare=sub->seg_list; compare; compare=compare->next)
    if (compare->sector)
      break;

  if (! compare)
  {
    FatalError("Subsector %p got no sector!!\n", sub);
    return;
  }

  sub->sector = compare->sector;

  for (cur=compare->next; cur; cur=cur->next)
  {
    if (! cur->sector)
      continue;

    if (cur->sector == compare->sector)
      continue;
 
    // prevent excessive number of warnings
    if (compare->sector->warned_facing == cur->sector->index)
      continue;

    compare->sector->warned_facing = cur->sector->index;

    if (cur->linedef)
      PrintMiniWarn("Sector #%d has sidedef facing #%d (line #%d) "
          "near (%1.0f,%1.0f).\n", compare->sector->index,
          cur->sector->index, cur->linedef->index,
          sub->mid_x, sub->mid_y);
    else
      PrintMiniWarn("Sector #%d has sidedef facing #%d "
          "near (%1.0f,%1.0f).\n", compare->sector->index,
          cur->sector->index, sub->mid_x, sub->mid_y);
  }
}

//
// SanityCheckHasRealSeg
//
static void SanityCheckHasRealSeg(subsec_t *sub)
{
  seg_t *cur;

  for (cur=sub->seg_list; cur; cur=cur->next)
  {
    if (cur->linedef)
      return;
  }

  InternalError("Subsector #%d near (%1.1f,%1.1f) has no real seg !",
      sub->index, sub->mid_x, sub->mid_y);
}

//
// RenumberSubsecSegs
//
static void RenumberSubsecSegs(subsec_t *sub)
{
  seg_t *cur;

# if DEBUG_SUBSEC
  PrintDebug("Subsec: Renumbering %d\n", sub->index);
# endif

  sub->seg_count = 0;

  for (cur=sub->seg_list; cur; cur=cur->next)
  {
    cur->index = num_complete_seg;
    num_complete_seg++;

    sub->seg_count++;

#   if DEBUG_SUBSEC
    PrintDebug("Subsec:   %d: Seg %p  Index %d\n", sub->seg_count,
        cur, cur->index);
#   endif
  }
}


static void CreateSubsecWorker(subsec_t *sub, seg_t *block)
{
  while (block)
  {
    // unlink first seg from block
    seg_t *cur = block;
    block = block->next;

    AddSegToList(&sub->seg_list, cur);
  }
}

//
// CreateSubsec
//
// Create a subsector from a list of segs.
//
static subsec_t *CreateSubsec(seg_t *seg_list)
{
  subsec_t *sub = NewSubsec();

  // compute subsector's index
  sub->index = num_subsecs - 1;

  // copy segs into subsector
  CreateSubsecWorker(sub, seg_list);

  DetermineMiddle(sub);

# if DEBUG_SUBSEC
  PrintDebug("Subsec: Creating %d\n", sub->index);
# endif

  return sub;
}


#if DEBUG_BUILDER

static void DebugShowSegs(seg_t *seg_list)
{
  seg_t *cur;

  for (cur = seg_list ; cur ; cur = cur->next)
  {
    PrintDebug("Build:   %sSEG %p  sector=%d  (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n",
        cur->linedef ? "" : "MINI", cur, cur->sector->index,
        cur->start->x, cur->start->y, cur->end->x, cur->end->y);
  }
}
#endif

//
// BuildSubsectors
//
glbsp_ret_e BuildSubsectors(seg_t *seg_list, int depth)
{
  seg_t *best;

  seg_t * rights;
  seg_t * lefts;

  intersection_t *cut_list;

  glbsp_ret_e ret;

  if (cur_comms->cancelled)
    return GLBSP_E_Cancelled;

# if DEBUG_BUILDER
  PrintDebug("Build: BEGUN @ %d\n", depth);
  DebugShowSegs(seg_list);
# endif

  /* pick best node to use.  None indicates convexicity */
  best = PickNode(seg_list, depth);

  if (best == NULL)
  {
    if (cur_comms->cancelled)
      return GLBSP_E_Cancelled;

#   if DEBUG_BUILDER
    PrintDebug("Build: CONVEX\n");
#   endif

    CreateSubsec(seg_list);
    return GLBSP_E_OK;
  }

# if DEBUG_BUILDER
  PrintDebug("Build: PARTITION %p (%1.0f,%1.0f) -> (%1.0f,%1.0f)\n",
      best, best->start->x, best->start->y, best->end->x, best->end->y);
# endif

  /* divide the segs into two lists: left & right */
  lefts  = NULL;
  rights = NULL;
  cut_list = NULL;

  SeparateSegs(seg_list, best, &lefts, &rights, &cut_list);

  /* sanity checks... */
  if (! rights)
    InternalError("Separated seg-list has no RIGHT side");

  if (! lefts)
    InternalError("Separated seg-list has no LEFT side");

  DisplayTicker();

  AddMinisegs(best, &lefts, &rights, cut_list);

  assert(best->linedef);

# if DEBUG_BUILDER
  PrintDebug("Build: Going LEFT\n");
# endif

  ret = BuildSubsectors(lefts, depth+1);

  if (ret != GLBSP_E_OK)
  {
    return ret;
  }

# if DEBUG_BUILDER
  PrintDebug("Build: Going RIGHT\n");
# endif

  ret = BuildSubsectors(rights, depth+1);

# if DEBUG_BUILDER
  PrintDebug("Build: DONE\n");
# endif

  return ret;
}

//
// BuildEverything
//
glbsp_ret_e BuildEverything(void)
{
  int i;

  glbsp_ret_e ret;

  // this automatically includes the dummy 'void_sector'

  for (i = 0 ; i < num_sectors ; i++)
  {
    sector_t *sec = LookupSector(i);

    // skip unused sectors
    if (! sec->seg_list)
      continue;

    PrintDebug("-------------------------------\n");
    PrintDebug("Processing Sector #%d\n", i);
    PrintDebug("-------------------------------\n");

    build_sector = sec;

    ret = BuildSubsectors(sec->seg_list, 0);

    if (ret != GLBSP_E_OK)
      return ret;
  }

  return GLBSP_E_OK;
}

//
// ClockwiseSubsectors
//
void ClockwiseSubsectors(void)
{
  int i;

  for (i = 0 ; i < num_subsecs ; i++)
  {
    subsec_t *sub = LookupSubsec(i);

    // this determines 'sector' field
    SanityCheckSameSector(sub);

    ClockwiseOrder(sub);
    RenumberSubsecSegs(sub);

    // do some sanity checks
    SanityCheckClosed(sub);
    SanityCheckHasRealSeg(sub);
  }
}

