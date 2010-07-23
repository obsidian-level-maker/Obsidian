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

fprintf(stderr, "SpreadEquivID  changes:%d sames:%d diffs:%d\n", changes, sames, diffs);

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


void CSG_SwallowBrushes()
{
  // check each region_c for redundant brushes, ones which are
  // completely surrounded by another brush (on the Z axis)

}


//------------------------------------------------------------------------

void snag_c::QuantizeCoords(double grid)
{
  q_x1 = I_ROUND(x1 / grid);
  q_y1 = I_ROUND(y1 / grid);
  q_x2 = I_ROUND(x2 / grid);
  q_y2 = I_ROUND(y2 / grid);
}

#if 0
bool snag_c::isLeftOf(const snag_c *other)
{
  return MIN(q_x1, q_x2) < MIN(other->q_x1, other->q_x2);
}

bool snag_c::isRightOf(const snag_c *other)
{
  return MAX(q_x1, q_x2) > MAX(other->q_x1, other->q_x2);
}
#endif


static bool OnSameLine(double ax1,double ay1, double ax2,double ay2,
                       double bx1,double by1, double bx2,double by2)
{
  double DIST = QUANTIZE_GRID / 1.7;

  double d1 = PerpDist(bx1,by1, ax1,ay1,ax2,ay2);

  if (fabs(d1) > DIST) return false;

  double d2 = PerpDist(bx2,by2, ax1,ay1,ax2,ay2);

  if (fabs(d2) > DIST) return false;

  return true;
}


static bool RegionHasFlattened(region_c *R, snag_c *longest)
{
  // check if all quantized coords in the region are sitting
  // on the same line.

  double ax1 = longest->q_x1 * QUANTIZE_GRID;
  double ay1 = longest->q_y1 * QUANTIZE_GRID;
  double ax2 = longest->q_x2 * QUANTIZE_GRID;
  double ay2 = longest->q_y2 * QUANTIZE_GRID;

  for (unsigned int k = 0 ; k < R->snags.size() ; k++)
  {
    snag_c *S = R->snags[k];

    if (S->isDegen())
      continue;

    if (S == longest)
      continue;

    double bx1 = S->q_x1 * QUANTIZE_GRID;
    double by1 = S->q_y1 * QUANTIZE_GRID;
    double bx2 = S->q_x2 * QUANTIZE_GRID;
    double by2 = S->q_y2 * QUANTIZE_GRID;

    if (! OnSameLine(ax1,ay1,ax2,ay2, bx1,by1,bx2,by2))
      return false;
  }

  return true;
}


static void CheckRegionDegenerate(region_c *R)
{
  if (R->brushes.empty())
    return;

  int valid_snags = 0;

  int min_qx =  (1 << 30);
  int min_qy =  (1 << 30);
  int max_qx = -(1 << 30);
  int max_qy = -(1 << 30);

  snag_c *longest = NULL;

  for (unsigned int k = 0 ; k < R->snags.size() ; k++)
  {
    snag_c *S = R->snags[k];

    if (S->isDegen())
      continue;

    valid_snags += 1;

    if (! longest || S->Length() > longest->Length())
      longest = S;

    min_qx = MIN(min_qx, MIN(S->q_x1, S->q_x2));
    min_qy = MIN(min_qy, MIN(S->q_y1, S->q_y2));

    max_qx = MAX(max_qx, MAX(S->q_x1, S->q_x2));
    max_qy = MAX(max_qy, MAX(S->q_y1, S->q_y2));
  }

  if (valid_snags < 3  ||
      min_qx == max_qx || min_qy == max_qy ||
      RegionHasFlattened(R, longest))
  {
    R->MarkDegen();

fprintf(stderr, "Region %p near (%1.0f %1.0f) is degenerate (valid:%d/%u)\n",
        R,
        longest ? longest->x1 : 0,
        longest ? longest->y1 : 0,
        valid_snags, R->snags.size());
  }
}


#if (1 == 0)
void OLD_CSG_Quantize(double grid)
{
  // mark segments and regions which become zero size as "degenerate".

  // a segment with a degenerate region on one side (after marking all
  // degenerates) needs to discover the new region, e.g. point test.

  QUANTIZE_GRID = grid;

int degens  = 0;
int normals = 0;

  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c *R = all_regions[i];

    for (unsigned int k = 0 ; k < R->snags.size() ; k++)
    {
      snag_c *S = R->snags[k];

      S->QuantizeCoords(grid);

if (S->isDegen()) degens++; else normals++;
    }
  }

fprintf(stderr, "Degenerate snags: %d  normal: %d\n", degens, normals);

  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c *R = all_regions[i];

    CheckRegionDegenerate(R);
  }
}
#endif


//------------------------------------------------------------------------

void CSG_FindGaps()
{
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
