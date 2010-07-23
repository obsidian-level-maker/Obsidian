//------------------------------------------------------------------------
//  2.5D Constructive Solid Geometry
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2010 Andrew Apted
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

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"

#include <algorithm>

#include "lib_util.h"
#include "main.h"

#include "csg_main.h"
#include "csg_local.h"
#include "g_lua.h"
#include "ui_dialog.h"


#define Z_EPSILON  0.001


gap_c::gap_c(csg_brush_c *B, csg_brush_c *T) :
    bottom(B), top(T), reachable(false)
{ }

gap_c::~gap_c()
{ }


//------------------------------------------------------------------------

static int SpreadEquivID()
{
  int changes = 0;

int sames = 0;
int diffs = 0;

  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c *R = all_regions[i];
    SYS_ASSERT(R);

    for (unsigned int k = 0 ; k < R->snags.size() ; k++)
    {
      snag_c *S = R->snags[k];
      SYS_ASSERT(S);

      region_c *N = S->partner ? S->partner->where : NULL;

      // use '>' so that we only check the relationship once
      if (N && N->equiv_id > R->equiv_id && N->HasSameBrushes(R))
      {
        N->equiv_id = R->equiv_id;
        changes++;
      }

if (N) {
if (N->equiv_id == R->equiv_id) sames++; else diffs++; }

    }
  }

// fprintf(stderr, "SpreadEquivID  changes:%d sames:%d diffs:%d\n", changes, sames, diffs);

  return changes;
}


void CSG_SimpleCoalesce()
{
  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c *R = all_regions[i];

    R->equiv_id = 1 + (int)i;

    R->SortBrushes();
  }

  while (SpreadEquivID() > 0)
  { }

  // TODO: coalesce if only one snag shared
}


static bool CanSwallowBrush(region_c *R, int i, int k)
{
  csg_brush_c *A = R->brushes[i];
  csg_brush_c *B = R->brushes[k];

  if (A->bkind != BKIND_Solid && A->bkind != BKIND_Sky)
    return false;

  return (B->b.z > A->b.z - Z_EPSILON) &&
         (B->t.z < A->t.z + Z_EPSILON);
}


void CSG_SwallowBrushes()
{
  // check each region_c for redundant brushes, ones which are
  // completely surrounded by another brush (on the Z axis)

int count=0;
int total=0;

  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c *R = all_regions[i];

    total += (int)R->brushes.size();

    for (int i = 0   ; i < (int)R->brushes.size() ; i++)
    for (int k = i+1 ; k < (int)R->brushes.size() ; k++)
    {
      if (CanSwallowBrush(R, i, k))
      { count++;
        R->RemoveBrush(k);
      }
    }
  }

fprintf(stderr, "Swallowed brushes: %d (of %d)\n", count, total);
}


//------------------------------------------------------------------------

static gap_c *GapForEntity(const region_c *R, const entity_info_c *E)
{
  for (unsigned int i = 0; i < R->gaps.size(); i++)
  {
    gap_c *G = R->gaps[i];

    // allow some leeway
    double z1 = (G->bottom->b.z + G->bottom->t.z) / 2.0;
    double z2 = (G->   top->b.z + G->   top->t.z) / 2.0;

    if (z1 < E->z && E->z < z2)
      return G;
  }

  return NULL; // not found
}


static void MarkGapsWithEntities()
{
  for (unsigned int i = 0; i < all_regions.size(); i++)
  {
    region_c *R = all_regions[i];

    for (unsigned int k = 0 ; k < R->entities.size() ; k++)
    {
      entity_info_c *E = R->entities[k];

      gap_c *gap = GapForEntity(R, E);

      if (! gap)
      {
        LogPrintf("WARNING: entity '%s' is inside solid @ (%1.0f,%1.0f,%1.0f)\n",
                  E->name.c_str(), E->x, E->y, E->z);
        continue;
      }

      gap->reachable = true;
    }
  }
}


static void BuildNeighborMap(...)
{
  // TODO BuildNeighborMap
}


static void SpreadReachability(void)
{
  // Algorithm: spread the 'reachable' flag from each gap to
  //            every neighbour, until it cannot spread any
  //            further.  Then all gaps without the flag are
  //            unreachable and should be filled.

  // TODO: a lua mechanism to force the reachable flag
  int changes;

  do
  {
    changes = 0;

    for (unsigned int i = 0; i < mug_regions.size(); i++)
    {
      merge_region_c *R = mug_regions[i];

      for (unsigned int k = 0; k < R->gaps.size(); k++)
      {
        merge_gap_c *G = R->gaps[k];

        if (! G->reachable)
          continue;

        for (unsigned int n = 0; n < G->neighbors.size(); n++)
        {
          merge_gap_c *H = G->neighbors[n];

          if (! H->reachable)
          {
            H->reachable = true;
            changes++;
          }
        }
      }
    }
  } while (changes > 0);
}


static void RemoveUnusedGaps()
{
  // statistics
  int gap_total  = 0;
  int gap_filled = 0;

  for (unsigned int i = 0; i < mug_regions.size(); i++)
  {
    merge_region_c *R = mug_regions[i];

    for (unsigned int k = 0; k < R->gaps.size(); k++)
    {
      merge_gap_c *G = R->gaps[k];

      gap_total++;

      if (G->reachable)
        continue;

      gap_filled++;

      delete G;
      R->gaps[k] = NULL;
    }

    // remove the NULL pointers
    std::vector<merge_gap_c *>::iterator ENDP =
         std::remove(R->gaps.begin(), R->gaps.end(), (merge_gap_c*)NULL);
    R->gaps.erase(ENDP, R->gaps.end());
  }

  if (gap_filled == gap_total)
  {
    Main_FatalError("CSG2: all gaps were unreachable (no entities?)\n");
  }

  LogPrintf("CSG2: filled %d gaps (of %d total)\n", gap_filled, gap_total);
}


struct csg_brush_bz_Compare
{
  inline bool operator() (const csg_brush_c *A, const csg_brush_c *B) const
  {
    return A->b.z < B->b.z;
  }
};


static void DiscoverThemGaps()
{
  // Algorithm:
  // 
  // sort the brushes by ascending z1 values.
  // Hence any gap must occur between two adjacent entries.
  // We also must check the gap is not covered by a previous
  // brush, done by maintaining a ref to the brush with the
  // currently highest z2 value.

  for (unsigned int i = 0; i < all_regions.size(); i++)
  {
    region_c *R = all_regions[i];

    if (R->brushes.size() <= 1)
      continue;

    std::sort(R->brushes.begin(), R->brushes.end(), csg_brush_bz_Compare());

    csg_brush_c *high = R->brushes[0];

    for (unsigned int k = 1; k < R->brushes.size(); k++)
    {
      csg_brush_c *A = R->brushes[k];

      // skip the "ephemeral" brushes
      if (high->bkind == BKIND_Liquid || high->bkind == BKIND_Rail ||
          high->bkind == BKIND_Light)
      {
        high = A;
        continue;
      }
      else if (A->bkind == BKIND_Liquid || A->bkind == BKIND_Rail ||
               A->bkind == BKIND_Light)
      {
        continue;
      }

      if (A->b.z > high->t.z + Z_EPSILON)
      {
        // found a gap
        gap_c *gap = new gap_c(high, A);

        R->AddGap(gap);

        high = A;
        continue;
      }

      // no gap implies that these two brushes touch/overlap,
      // hence update the highest one.
      
      if (A->t.z > high->t.z)
        high = A;
    }
  }
}


void CSG_DiscoverGaps()
{
  DiscoverThemGaps();

  MarkGapsWithEntities();

  BuildNeighborMap();

  SpreadReachability();

  RemoveUnusedGaps();
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
