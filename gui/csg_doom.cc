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

// #include "g_lua.h"
#include "main.h"
#include "lib_util.h"


static int total_sectors;
static int total_lines;

static void CreateSectors(void)
{
  total_sectors = 0;

  for (int i = 0; i < (int)all_merges.size(); i++)
  {
    merged_area_c *M = all_merges[i];

    SYS_ASSERT(M);

    if (M->sector_index < 0)
    {
      M->sector_index = total_sectors;
      total_sectors++;

      // FIXME: propagate step:
      //   (1) clear the 'process' list, add in current area
      //   (2) iterate over process list
      //   (3) if neighbour area has no sector AND matches this area,
      //       propagate the sector index into it,
      //       THEN add all the new neighbours into new process list.
      //   (4) when done, old list := new list
      //   (5) if new list not empty, goto 2
    }
  }
}

static void CreateLinedefs(void)
{
  total_lines = 0;

  for (int i = 0; i < (int)all_merges.size(); i++)
  {
    merged_area_c *M = all_merges[i];

    SYS_ASSERT(M->polys.size() > 0);

    int num_vert = (int)M->polys[0]->verts.size();

    for (int j1 = 0; j1 < num_vert; j1++)
    {
      int j2 = (j1 + 1) % num_vert;

      area_vert_c *v1 = M->polys[0]->verts[j1];
      area_vert_c *v2 = M->polys[0]->verts[j2];

      SYS_ASSERT(v1 && v2);

      // FIXME !!!
    }
  }
}

void CSG2_WriteDoom(void)
{
  // converts the Merged list into the sectors, linedefs (etc)
  // required for a DOOM level.
  
  CSG2_MergeAreas();

  CreateSectors();

  CreateLinedefs();

  // FIXME: things !!!!
}

void CSG2_TestDoom(void)
{
  // for debugging only: each area_poly_c becomes a single sector
  // on the map.
 
  std::vector<area_poly_c *>::iterator PLI;

#if 1
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


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
