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

void CSG_Quantize(double grid)
{
  // mark segments and regions which become zero size as "degenerate".

  // a segment with a degenerate region on one side (after marking all
  // degenerates) needs to discover the new region, e.g. point test.
}


//------------------------------------------------------------------------

void CSG_FindGaps()
{
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
