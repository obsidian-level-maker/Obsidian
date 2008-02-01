//------------------------------------------------------------------------
//  2.5D CSG : DOOM output
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2008 Andrew Apted
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


static int extrafloor_tag;
static int extrafloor_slot;


class sector_info_c 
{
public:
  int f_h;
  int c_h;

  std::string f_tex;
  std::string c_tex;
  
  int light;
  int special;
  int tag;
  int mark;

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
    return (f_h == other->f_h) &&
           (c_h == other->c_h) &&
           (light == other->light) &&
           (special == other->special) &&
           (tag  == other->tag)  &&
           (mark == other->mark) &&
           (strcmp(f_tex.c_str(), other->f_tex.c_str()) == 0) &&
           (strcmp(c_tex.c_str(), other->c_tex.c_str()) == 0);
  }
};

static std::vector<sector_info_c *> dm_sectors;


class open_space_c
{
public:
  double z1, z2;
 
public:
  open_space_c()
  { }

  ~open_space_c()
  { }
};


void CSG2_TestDoom_Areas(void)
{
  // for debugging only: each area_poly_c becomes a single sector
  // on the map.
 
  for (unsigned int k = 0; k < all_polys.size(); k++)
  {
    area_poly_c *P = all_polys[k];
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
   // area_vert_c *v2 = P->verts[j2];

      wad::add_vertex(I_ROUND(v1->x), I_ROUND(v1->y));

      wad::add_linedef(vert_base+j1, vert_base+j2, side_idx, -1,
                       0, 1 /*impassible*/, 0, NULL /* args */);
    }
  }
}

void CSG2_TestDoom_Regions(void)
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



static area_poly_c * FindExtraFloor(merge_region_c *R, double z1, double z2)
{
  area_poly_c *best = NULL;

  for (unsigned int k=0; k < R->areas.size(); k++)
  {
    area_poly_c *E = R->areas[k];

    if (! (E->info->z1 > z1 && E->info->z2 < z2))
      continue;

    // we prefer the one closest to the top (because when the engine
    // adds an extrafloor, the upper region stays the same and the
    // lower regions gets the lighting/special from the extrafloor).

    if (! best || E->info->z2 > best->info->z2) 
    {
      best = E;
    }
  }

  return best;
}


static double MakeExtraFloor(merge_region_c *R, sector_info_c *sec,
                             area_poly_c *T)
{
  // T is the top-most brush.  Find the bottom-most brush
  // which is connected to T (via intersecting brushes).
  area_poly_c *B = T;

  for (;;)
  {
    bool changed = false;

    for (unsigned int k=0; k < R->areas.size(); k++)
    {
      area_poly_c *A = R->areas[k];

      if (A->info->z1 < B->info->z1 - EPSILON &&
          A->info->z2 > B->info->z1 - EPSILON)
///       A->info->z2 < T->info->z2 + EPSILON)
      {
        B = A; changed = true;
      }
    }

    if (! changed)
      break;
  }


  // find the brush which we will use for the side texture
  area_poly_c *MID = NULL;
  double best_h = 0;

  for (unsigned int j = 0; j < R->areas.size(); j++)
  {
    area_poly_c *A = R->areas[j];

    if (A->info->z1 > B->info->z1 - EPSILON &&
        A->info->z2 < T->info->z2 + EPSILON)
    {
      double h = A->info->z2 - A->info->z1;

      // TODO: priorities

//      if (MID && fabs(h - best_h) < EPSILON)
//      { /* same height, prioritise */ }

      if (h > best_h)
      {
        best_h = h;
        MID = A;
      }
    }
  }

  SYS_ASSERT(MID);


  extrafloor_slot++;

  if (sec->tag <= 0)
    sec->tag = extrafloor_tag++;


  // FIXME !!! find extent of map, use "map_min_y - 128"

  int x1 =    0 + (extrafloor_slot & 31) * 64;
  int y1 = -160 - (extrafloor_slot / 32) * 64;

  if (extrafloor_slot & 1024) x1 += 2200;
  if (extrafloor_slot & 2048) y1 -= 2200;

  if (extrafloor_slot & 4096)
    Main_FatalError("Too many extrafloors! (over %d)%d\n", extrafloor_slot);

  int x2 = x1 + 32;
  int y2 = y1 + 32;


  int vert_ref = wad::num_vertexes();

  wad::add_vertex(x1, y1);
  wad::add_vertex(x1, y2);
  wad::add_vertex(x2, y2);
  wad::add_vertex(x2, y1);

 
  int sec_ref = wad::num_sectors();

  int f_h = I_ROUND(B->info->z1);
  int c_h = I_ROUND(T->info->z2);

  wad::add_sector(f_h, B->info->b_tex.c_str(),
                  c_h, T->info->t_tex.c_str(),
                  144, 0, 0); // FIXME !!!! light, special


  int side_ref = wad::num_sidedefs();

  wad::add_sidedef(sec_ref, "-", MID->info->w_tex.c_str(), "-", 0, 0);


  // FIXME: 400 is EDGE extrafloor (don't hard-code it)

  wad::add_linedef(vert_ref+0, vert_ref+1, side_ref, -1,
                   400 /* EDGE !! */, 1 /* impassible */,
                   sec->tag, NULL /* args */);

  wad::add_linedef(vert_ref+1, vert_ref+2, side_ref, -1, 0,1,0, NULL);
  wad::add_linedef(vert_ref+2, vert_ref+3, side_ref, -1, 0,1,0, NULL);
  wad::add_linedef(vert_ref+3, vert_ref+0, side_ref, -1, 0,1,0, NULL);

  return B->info->z1;
}


static void CreateOneSector(merge_region_c *R)
{
  // completely solid (no gaps) ?
  if (R->gaps.size() == 0)
  {
    R->index = 0;
    return;
  }

#if 0  // OLD CODE
  double min_z = +999999;
  double max_z = -999999;

  unsigned int k;
  
  for (k=0; k < R->areas.size(); k++)
  {
    area_poly_c *A = R->areas[k];

    min_z = MIN(min_z, A->info->z1);
    max_z = MAX(max_z, A->info->z2);
  }

  // look for a completely "void" brush
  for (k=0; k < R->areas.size(); k++)
  {
    area_poly_c *A = R->areas[k];

    if (A->info->z1 < min_z + EPSILON &&
        A->info->z2 > max_z - EPSILON)
    {
      R->index = 0;
      return;
    }
  }

  // OK, we will have a sector

  // find bottom most (B) and top most (T) brushes
  area_poly_c *B = NULL;
  area_poly_c *T = NULL;

  for (k=0; k < R->areas.size(); k++)
  {
    area_poly_c *A = R->areas[k];
    
    if (A->info->z1 < min_z + EPSILON)
    {
      if (! B || (A->info->z2 > B->info->z2 + EPSILON) )
      {
        B = A;
      }
    }

    if (A->info->z2 > max_z - EPSILON)
    {
      if (! T || (A->info->z1 < T->info->z1 - EPSILON) )
      {
        T = A;
      }
    }
  }

  SYS_ASSERT(B && T);

  // upgrade brushes if another solid intersects

  // FIXME: prioritise when heights are the same

  for (;;)
  {
    bool changed = false;

    for (k=0; k < R->areas.size(); k++)
    {
      area_poly_c *A = R->areas[k];

      if (A->info->z2 > B->info->z2 + EPSILON &&
          A->info->z1 < B->info->z2 + EPSILON &&
          A->info->z2 < T->info->z1 + EPSILON)
      {
        B = A; changed = true; /// break;
      }

      if (A->info->z1 < T->info->z1 - EPSILON &&
          A->info->z2 > T->info->z1 - EPSILON &&
          A->info->z1 > B->info->z2 - EPSILON)
      {
        T = A; changed = true; /// break;
      }
    }

    if (! changed)
      break;
  }

DebugPrintf("SECTOR #%d:\n", (int) dm_sectors.size());
DebugPrintf("{\n");
for (unsigned jk=0; jk < R->gaps.size(); jk++)
{
  DebugPrintf("GAP: %1.0f..%1.0f to %1.0f..%1.0f\n",
    R->gaps[jk]->bottom->info->z1, R->gaps[jk]->bottom->info->z2,
    R->gaps[jk]->top->info->z1, R->gaps[jk]->top->info->z2);
}
DebugPrintf("}\n");
  
#endif


  area_poly_c *B = R->gaps[0]->bottom;
  area_poly_c *T = R->gaps[R->gaps.size()-1]->top;

  sector_info_c *sec = new sector_info_c;

  sec->f_h = I_ROUND(B->info->z2);
  sec->c_h = I_ROUND(T->info->z1);

  if (sec->c_h < sec->f_h)
      sec->c_h = sec->f_h;

  sec->f_tex = B->info->t_tex;
  sec->c_tex = T->info->b_tex;

  sec->light = MAX(B->info->t_light, T->info->b_light);
  sec->mark  = MAX(B->info->mark,    T->info->mark);

  if (B->info->sec_kind > 0)
  {
    sec->special = B->info->sec_kind;
    sec->tag     = B->info->sec_tag;
  }
  else if (T->info->sec_kind > 0)
  {
    sec->special = T->info->sec_kind;
    sec->tag     = T->info->sec_tag;
  }
  else
  {
    sec->special = 0;
    sec->tag     = 0;
  }


  R->index = (int)dm_sectors.size();

  dm_sectors.push_back(sec);


  // find brushes floating in-between --> make extrafloors

#if 0
  double exfloor_z1 = B->info->z2 + 1;
  double exfloor_z2 = T->info->z1 - 1;

  for (;;)
  {
    area_poly_c *EF = FindExtraFloor(R, exfloor_z1, exfloor_z2);

    if (! EF)
      break;

    exfloor_z2 = MakeExtraFloor(R, sec, EF) - 1;
  }
#endif
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

static void CreateSectors(void)
{
  dm_sectors.clear();

  // #0 represents VOID (removed later)
  dm_sectors.push_back(new sector_info_c);

  for (unsigned int i = 0; i < mug_regions.size(); i++)
  {
    merge_region_c *R = mug_regions[i];

    CreateOneSector(R);
  }

  CoalesceSectors();
}


static int WriteVertex(merge_vertex_c *V)
{
  if (V->index < 0)
  {
    V->index = wad::num_vertexes();

    wad::add_vertex(I_ROUND(V->x), I_ROUND(V->y));
  }

  return V->index;
}


static int WriteSector(sector_info_c *S)
{
  if (S->index < 0)
  {
    S->index = wad::num_sectors();

    wad::add_sector(S->f_h, S->f_tex.c_str(),
                    S->c_h, S->c_tex.c_str(),
                    S->light, S->special, S->tag);
  }

  return S->index;
}


static std::string FindSideTexture(double z, merge_segment_c *G,
                                   merge_region_c *F, merge_region_c *B)
{
  if (! B)
    return std::string("FIREBLU1");  // FIXME: ERROR_TEX

  // TODO: find texture in line loops using segment 'G'

  // TODO: check for multiple matches, prioritise

  unsigned int k;

  // examine *back* region
  for (k = 0; k < B->areas.size(); k++)
  {
    area_poly_c *A = B->areas[k];

    if ((z > A->info->z1 - EPSILON) && (z < A->info->z2 + EPSILON))
      return A->info->w_tex;
  }

  // none found ???  FIXME use closest area
  return std::string("CRACKLE2");
}

static int WriteSidedef(merge_segment_c *G, merge_region_c *F, merge_region_c *B)
{
  if (! (F && F->index > 0))
    return -1;

  sector_info_c *S = dm_sectors[F->index];

  int sec_num = WriteSector(S);

  int side_ref = wad::num_sidedefs();

  if (B && B->index > 0)
  {
    sector_info_c *BS = dm_sectors[B->index];

    double fz = (S->f_h + BS->f_h) / 2.0;
    double cz = (S->c_h + BS->c_h) / 2.0;

    std::string lower = FindSideTexture(fz, G, F, B);
    std::string upper = FindSideTexture(cz, G, F, B);

    std::string rail = "-"; // TODO = FindRailTexture( xxx )

    wad::add_sidedef(sec_num, lower.c_str(), rail.c_str(), upper.c_str(), 0, 0);
  }
  else
  {
    double z = (S->f_h + S->c_h) / 2.0;

    std::string wall = FindSideTexture(z, G, F, B);

    wad::add_sidedef(sec_num, "-", wall.c_str(), "-", 0, 0);
  }

  return side_ref;
}


static void WriteLinedefs(void)
{
  for (unsigned int i = 0; i < mug_segments.size(); i++)
  {
    merge_segment_c *G = mug_segments[i];

    SYS_ASSERT(G);
    SYS_ASSERT(G->start);

    if (! G->front && ! G->back)
      continue;

    // if same sector on both sides, skip the line, unless
    // we have a rail texture or a special line.
    if (G->front && G->back && G->front->index == G->back->index)
    {
      // FIXME: check for a rail texture (on any line)

      // FIXME: check for a special line-type (on any line)
      continue;
    }

    int front_idx = WriteSidedef(G, G->front, G->back);
    int back_idx  = WriteSidedef(G, G->back, G->front);

    if (front_idx < 0 && back_idx < 0)
      continue;

    int v1 = WriteVertex(G->start);
    int v2 = WriteVertex(G->end);

    if (front_idx < 0)
    {
      front_idx = back_idx;
      back_idx  = -1;

      int TMP = v1; v1 = v2; v2 = TMP;
    }

    int flags = 0;
    if (back_idx < 0)
      flags = 1; /* impassible */

    wad::add_linedef(v1, v2, front_idx, back_idx,
                     0 /* type */, flags,
                     0 /* tag */, NULL /* args */);
  }

  SYS_ASSERT(wad::num_vertexes() > 0);
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

//!!!
// CSG2_TestDoom_Areas();
// return;
 
  extrafloor_tag  = 9000;
  extrafloor_slot = 0;

  CreateSectors();

  WriteLinedefs();

  // FIXME: things !!!!

  // FIXME: Free everything
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
