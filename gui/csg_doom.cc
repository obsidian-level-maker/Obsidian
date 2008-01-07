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


class sector_info_c 
{
public:
  int f_h;
  int c_h;

  std::string f_tex;
  std::string c_tex;
  
  int light; int special;
  int tag; int mark;

  int index;
  
public:
  sector_info_c() : f_h(0), c_h(0), f_tex(), c_tex(),
                    light(255), special(0), tag(0), mark(0),
                    index(-1)
  { }

  ~sector_info_c()
  { }

  bool Match(const sector_info_c *other) const
  {
    return false; // FIXME sector_info_c::Match
  }
};


static int total_verts;
static int total_sides;
static int total_sectors;


static std::vector<sector_info_c *> dm_sectors;


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
  dm_sectors.clear();

  dm_sectors.push_back(new sector_info_c);

  for (unsigned int i = 0; i < mug_regions.size(); i++)
  {
    merge_region_c *R = mug_regions[i];

    // if only one brush, area must be solid
    // (FIXME: be more lenient of contains a player/teleport thing)
    if (R->areas.size() <= 1)
    {
      R->index = 0;
      continue;
    }

    // FIXME: proper analysis !!!!!
    int B = 0;
    int T = (int)R->areas.size() - 1;

    area_poly_c *bottom = R->areas[B];
    area_poly_c *top    = R->areas[T];

    if (bottom->info->z1 > top->info->z2)
    {
      area_poly_c *TMP = top; top = bottom; bottom = TMP;
    }
    
    R->index = (int)dm_sectors.size();

    sector_info_c *sec = new sector_info_c;

    sec->f_h   = I_ROUND(bottom->info->z2);
    sec->c_h   = I_ROUND(top->info->z1);

    sec->f_tex = bottom->info->t_tex;
    sec->c_tex = top->info->b_tex;

    // FIXME ETC...

    dm_sectors.push_back(sec);
  }
}


static void CoalesceSectors(void)
{
  for (int loop=0; loop < 99; loop++)
  {
    int changes = 0;

    for (unsigned int i = 0; i < mug_segments.size(); i++)
    {
      merge_segment_c *S = mug_segments[i];

      if (! S->front || ! S->back)
        continue;

      if (S->front->index <= 0 || S->back->index <= 0)
        continue;
      
      // already merged?
      if (S->front->index == S->back->index)
        continue;

      sector_info_c *F = dm_sectors[S->front->index];
      sector_info_c *B = dm_sectors[S->back ->index];

      if (F->Match(B))
      {
        S->front->index = MIN(S->front->index, S->back->index);
        S->back ->index = S->front->index;

        changes++;
      }
    }

    if (changes == 0)
      return;
  }
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

static int WriteSector(sector_info_c *S)
{
  if (S->index < 0)
  {
    S->index = total_sectors;
    total_sectors++;

    wad::add_sector(S->f_h, S->f_tex.c_str(),
                    S->c_h, S->c_tex.c_str(),
                    S->light, S->special, S->tag);
  }

  return S->index;
}
 
static int WriteSidedef( XXX )
{
  const char *tex = "STARTAN3";

  wad::add_sidedef(WriteSector(ZZZ), tex, "-", tex, 0, 0);

  return total_sides-1;
}

static void WriteLinedefs(void)
{
  total_verts = 0;
  total_sides = 0;

  // TODO: optimise maps by merging two contiguous segments
  //       sitting on a area_poly line where possible.

  for (unsigned int i = 0; i < mug_segments.size(); i++)
  {
    merge_segment_c *S = mug_segments[i];

    SYS_ASSERT(S);
    SYS_ASSERT(S->start);
    SYS_ASSERT(S->front);

    int front_idx = -1;
    int back_idx  = -1;

    if (S->front)
      front_idx = WriteSidedef( ); //!!!!

    if (S->back)
      back_idx = WriteSidedef( );

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
  // 1) reserve sector #0 to represent VOID space (removed later)
  // 2) create a sector for each region
  // 3) coalesce neighbouring sectors with same properties
  //    - mark border segments as unused
  //    - mark vertices with all unused segs as unused
  // 4) profit!
 
  CSG2_MergeAreas();

  CreateSectors();
  CoalesceSectors();

  WriteLinedefs();

  // FIXME: things !!!!

  // FIXME: Free everything
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
