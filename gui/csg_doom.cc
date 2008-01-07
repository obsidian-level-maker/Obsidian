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


///-- static int total_vertices;
///-- static int total_sectors;
///-- static int total_lines;


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

static void CreateVertexes(void)
{
  for (unsigned int i = 0; i < mug_vertices.size(); i++)
  {
    merge_vertex_c *V = mug_vertices[i];
    
    V->index = (int)i;

    wad::add_vertex(I_ROUND(V->x), I_ROUND(V->y));
  }
}
 
void CSG2_TestDoom_Segments(void)
{
  // for debugging only: each merge_region becomes a single
  // sector on the map.

  unsigned int i;

  CreateVertexes();


  for (i = 0; i < mug_regions.size(); i++)
  {
    merge_region_c *R = mug_regions[i];

    R->index = (int)i;

    const char *flat = "FLAT1";
 
#if 0 // QUICK TEST CRAP
for (unsigned int p = 0; p < all_polys.size(); p++)
{  area_poly_c *P = all_polys[p];
for (unsigned int q = 0; q < P->regions.size(); q++)
{  merge_region_c *Q = P->regions[q];
if (Q == R) { flat = P->info->t_tex.c_str();
DebugPrintf("Region %d has poly %p (%1.0f..%1.0f %s:%s)\n",
R->index, P, P->info->z1, P->info->z2,
P->info->b_tex.c_str(), P->info->t_tex.c_str());
  }
}}
#endif
 
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


static void CreateSidedefs(void)
{
  for (unsigned int i = 0; i < mug_regions.size(); i++)
  {
    merge_region_c *R = mug_regions[i];

    const char *tex = "STARTAN3";

    wad::add_sidedef(R->index, "-", tex, "-", 0, 0);
    wad::add_sidedef(R->index, tex, "-", tex, 0, 0);
  }
}


static void CoalesceSectors(void)
{
  // TODO: CoalesceSectors
}


static void CreateLinedefs(void)
{
  for (unsigned int i = 0; i < mug_segments.size(); i++)
  {
    merge_segment_c *S = mug_segments[i];

    SYS_ASSERT(S);
    SYS_ASSERT(S->start);
    SYS_ASSERT(S->front);

    int flags = 0;

    if (! S->back)
      flags = 1; /* impassible */

    wad::add_linedef(S->start->index, S->end->index,
                     S->front ? (2*S->front->index+1-flags) : -1,
                     S->back  ? (2*S->back->index+1-flags)  : -1,
                     0 /* type */, flags,
                     0 /* tag */, NULL /* args */);
  }
}


void CSG2_WriteDoom(void)
{
  // converts the Merged list into the sectors, linedefs (etc)
  // required for a DOOM level.
  
  CSG2_MergeAreas();

  CreateSectors();
  CoalesceSectors();

  CreateSidedefs();
  CreateLinedefs();

  // FIXME: things !!!!
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
