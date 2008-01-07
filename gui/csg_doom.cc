//------------------------------------------------------------------------
//  2.5D CSG : DOOM output
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006,2007 Andrew Apted
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

#include "csg_poly.h"
#include "csg_doom.h"

#include "g_doom.h"
#include "main.h"
#include "lib_util.h"


#define VOID_INDEX  -2

static int total_verts;
static int total_sides;
static int total_sectors;


void CSG2_TestDoom_Areas(void)
{
  // for debugging only: each area_poly_c becomes a single sector
  // on the map.
 
  std::vector<area_poly_c *>::iterator PLI;

#if 0
  CSG2_MergeAreas();

  for (int r = 0; r < (int)all_merges.size(); r++)
  if ( (PLI = all_merges[r]->polys.begin()), true )
#else
  for (PLI = all_polys.begin(); PLI != all_polys.end(); PLI++)
#endif
  {
    area_poly_c *P = *PLI;
    area_info_c *A = P->info;
    
    int sec_idx = wad::num_sectors();

    wad::add_sector(I_ROUND(A->z1), A->b_tex.c_str(),
                    I_ROUND(A->z2), A->t_tex.c_str(),
                    192, 0, 0);

    int side_idx = wad::num_sidedefs();

    wad::add_sidedef(sec_idx, "-", A->w_tex.c_str(), "-", 0, 0);

    int vert_base = wad::num_vertexes();

    for (int j1 = 0; j1 < (int)P->verts.size(); j1++)
    {
      int j2 = (j1 + 1) % (int)P->verts.size();

      area_vert_c *v1 = P->verts[j1];
      area_vert_c *v2 = P->verts[j2];

      wad::add_vertex(I_ROUND(v1->x), I_ROUND(v1->y));

      wad::add_linedef(vert_base+j1, vert_base+j2, side_idx, -1,
                       0, 1 /*impassible*/, 0, NULL /* args */);
    }
  }
}

void CSG2_TestDoom_Segments(void)
{
  // for debugging only: each merge_region becomes a single
  // sector on the map.

  unsigned int i;

  for (i = 0; i < mug_vertices.size(); i++)
  {
    merge_vertex_c *V = mug_vertices[i];
    
    V->index = (int)i;

    wad::add_vertex(I_ROUND(V->x), I_ROUND(V->y));
  }


  for (i = 0; i < mug_regions.size(); i++)
  {
    merge_region_c *R = mug_regions[i];

    R->index = (int)i;

    const char *flat = "FLAT1";
 
    wad::add_sector(0,flat, 144,flat, 255,0,0);

    const char *tex = R->faces_out ? "COMPBLUE" : "STARTAN3";

    wad::add_sidedef(R->index, tex, "-", tex, 0, 0);
  }


  for (i = 0; i < mug_segments.size(); i++)
  {
    merge_segment_c *S = mug_segments[i];

    SYS_ASSERT(S);
    SYS_ASSERT(S->start);

    wad::add_linedef(S->start->index, S->end->index,
                     S->front ? S->front->index : -1,
                     S->back  ? S->back->index  : -1,
                     0, 1 /*impassible*/, 0,
                     NULL /* args */);
  }
}


static void CreateSectors(void)
{

  for (unsigned int i = 0; i < mug_regions.size(); i++)
  {
    merge_region_c *R = mug_regions[i];

    R->index = (int)i;

    const char *flat = "FLAT10";
 
    wad::add_sector(0,flat, 144,flat, 255,0,0);
  }
}


static void CoalesceSectors(void)
{
  // TODO: CoalesceSectors
}


static int WriteVertex(merge_vertex_c *V)
{
  if (V->index < 0)
  {
    V->index = total_verts;
    total_verts++;

    wad::add_vertex(I_ROUND(V->x), I_ROUND(V->y));
  }

  return V->index;
}

static int WriteSector( XXX )
{
  if (S->index < 0)
  {
    S->index = total_sectors;
    total_sectors++;

    wad::add_sector( ZZZ );
  }

  return S->index;
}
 
static int WriteSidedef( XXX )
{
  const char *tex = "STARTAN3";

  wad::add_sidedef(WriteSector(R), tex, "-", tex, 0, 0);

  return total_sides-1;
}

static void WriteLinedefs(void)
{
  total_verts = 0;
  total_sides = 0;

  for (unsigned int i = 0; i < mug_segments.size(); i++)
  {
    merge_segment_c *S = mug_segments[i];

    SYS_ASSERT(S);
    SYS_ASSERT(S->start);
    SYS_ASSERT(S->front);

    int front_idx = -1;
    int back_idx  = -1;

    if (S->front)
      front_idx = WriteSidedef( XXX );

    if (S->back)
      back_idx = WriteSidedef( XXX );

    int flags = 0;
    if (back_idx < 0)
      flags = 1; /* impassible */

    wad::add_linedef(WriteVertex(S->start),
                     WriteVertex(S->end),
                     front_idx, back_idx,
                     0 /* type */, flags,
                     0 /* tag */, NULL /* args */);
  }

  SYS_ASSERT(total_verts > 0);
}


void CSG2_WriteDoom(void)
{
  // converts the Merged list into the sectors, linedefs (etc)
  // required for a DOOM level.
  //
  // Algorithm:
  //
  // 1) create a sector for each region (use VOID_INDEX for solids)
  // 2) coalesce same sectors:
  //    - mark border segments as unused
  //    - mark vertices with all unused segs as unused
  // 3) ???
 
  CSG2_MergeAreas();

  CreateSectors();

  WriteLinedefs();

  // FIXME: things !!!!
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
