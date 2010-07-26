//------------------------------------------------------------------------
//  CSG : DUKE NUKEM output
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
#include "hdr_ui.h"  // ui_build.h

#include <algorithm>

#include "lib_file.h"
#include "lib_util.h"
#include "main.h"

#include "ui_chooser.h"

#include "csg_main.h"
#include "csg_local.h"

#include "nk_level.h"
#include "nk_structs.h"


// Properties


#define NK_WALL_MUL      10
#define NK_HEIGHT_MUL  -200


#define VOID_INDEX  -2


#define SEC_IS_SKY       (0x1 << 16)
#define SEC_PRIMARY_LIT  (0x2 << 16)
#define SEC_SHADOW       (0x4 << 16)


double light_dist_factor = 800.0;


class nukem_sector_c;


class nukem_wall_c
{
public:
  int x1, y1;
  int x2, y2;

  snag_c *snag;

  nukem_wall_c *partner;

  nukem_sector_c *sector;

  // !!!!  FIXME textures and stuff

  int index;

public:
  nukem_wall_c(int _x1, int _y1, int _x2, int _y2) :
      x1(_x1), y1(_y1), x2(_x2), y2(_y2),
      snag(NULL), partner(NULL),
      index(-1)
  { }

  ~nukem_wall_c() {}

  int GetX() const
  {
    return (side == 0) ? line->start->x : line->end->x;
  }

  int GetY() const
  {
    return (side == 0) ? line->start->y : line->end->y;
  }

  int SectorIndex() const
  {
    return (side == 0) ? line->front->sector->index : line->back->sector->index;
  }

  void Write();
};


class nukem_plane_c
{
public:
  int h;
  int tex;
  int flags;

public:
  nukem_plane_c() : h(0), tex(0), flags(0)
  { }

  ~nukem_plane_c()
  { }
};


class nukem_sector_c 
{
public:
  nukem_plane_c floor;
  nukem_plane_c ceil;

  region_c *region;

  std::vector<nukem_wall_c *> walls;

  std::vector<entity_info_c *> entities;

  int mark;
  int index;

// double mid_x, mid_y;

public:
  nukem_sector_c() :
      floor(), ceil(),
      region(NULL), walls(), entities(),
      mark(0), index(-1)
  { }

  ~nukem_sector_c()
  { }

  void AddWall(nukem_wall_c *W)
  {
    W->sector = this;

    walls.push_back(W);
  }

  void AddEntity(entity_info_c *E)
  {
    entities.push_back(E);
  }

#if 0
  bool Match(const nukem_sector_c *other) const
  {
    // deliberately absent: misc_flags

    return (f_h == other->f_h) &&
           (c_h == other->c_h) &&
           (light == other->light) &&
           (special == other->special) &&
           (tag  == other->tag)  &&
           (mark == other->mark) &&
           (strcmp(f_tex.c_str(), other->f_tex.c_str()) == 0) &&
           (strcmp(c_tex.c_str(), other->c_tex.c_str()) == 0)
  }
#endif

  void CalcMiddle()
  {
    mid_x = 0;
    mid_y = 0;

    int count = (int)region->segs.size();

    for (int i = 0; i < count; i++)
    {
      merge_segment_c *G = region->segs[i];

      // tally both start and end, as segs may face either way
      mid_x = mid_x + G->start->x + G->end->x;
      mid_y = mid_y + G->start->y + G->end->y;
    }

    if (count > 0)
    {
      mid_x /= (double)(count * 2);
      mid_y /= (double)(count * 2);
    }
  }

  nukem_wall_c *FindSnagWall(snag_c *snag)
  {
    for (unsigned int i = 0 ; i < walls.size() ; i++)
    {
      nukem_wall_c *W = walls[i];

      if (W->snag == snag)
        return W;
    }

    return NULL;
  }

  void AssignWallIndices(int *first, int *count);

  void Write();
  void WriteSprites();
  void WriteWalls();
};


class OLD_linedef_info_c 
{
public:
  vertex_info_c *start;  // NULL means "unused linedef"
  vertex_info_c *end;

  sidedef_info_c *front;
  sidedef_info_c *back;

  int flags;
  int type;   // 'special' in Hexen format
  int tag;

  u8_t args[5];

  double length;

  // similar linedef touching our start (end) vertex, or NULL if none.
  // only takes front sidedefs into account.
  // used for texture aligning.
  linedef_info_c *sim_prev;
  linedef_info_c *sim_next;

public:
  linedef_info_c() : start(NULL), end(NULL),
                     front(NULL), back(NULL),
                     flags(0), type(0), tag(0), length(0),
                     sim_prev(NULL), sim_next(NULL),
                     nk_front(NULL), nk_back(NULL)
  {
    args[0] = args[1] = args[2] = args[3] = args[4] = 0;
  }

  ~linedef_info_c()
  { }

  void CalcLength()
  {
    length = ComputeDist(start->x, start->y, end->x, end->y);
  }

  inline vertex_info_c *OtherVertex(const vertex_info_c *V) const
  {
    if (start == V)
      return end;

    SYS_ASSERT(end == V);
    return start;
  }

  inline bool Valid() const
  {
    return (start != NULL);
  }

  void Kill()
  {
    start = end = NULL;
  }

  void Flip()
  {
    std::swap(start, end);
    std::swap(front, back);
  }

  inline bool ShouldFlip() const
  {
    if (! front)
      return true;

    if (! back)
      return false;

    nukem_sector_c *F = front->sector;
    nukem_sector_c *B = back->sector;

    if (F->f_h != B->f_h) return (F->f_h > B->f_h);
    if (F->c_h != B->c_h) return (F->c_h < B->c_h);

    return false;
  }

  void Write();

  inline bool CanMergeSides(const sidedef_info_c *A, const sidedef_info_c *B) const
  {
    if (! A || ! B)
      return (!A && !B);

    if (A->sector != B->sector)
      return false;

    // X offsets not done here

    if (A->y_offset != B->y_offset &&
        A->y_offset != IVAL_NONE   &&
        B->y_offset != IVAL_NONE)
      return false;

    return A->SameTex(B);
  }

  bool ColinearWith(const linedef_info_c *B) const
  {
    int adx = end->x - start->x;
    int ady = end->y - start->y;

    int bdx = B->end->x - B->start->x;
    int bdy = B->end->y - B->start->y;

    return (adx * bdy == bdx * ady);
  }

  bool CanMerge(const linedef_info_c *B) const
  {
    if (! ColinearWith(B))
      return false;

    // test sidedefs
    sidedef_info_c *B_front = B->front;
    sidedef_info_c *B_back  = B->back;

///---  if ((V == end) == (V == B->end))
///---    std::swap(B_front, B_back);

    if (! CanMergeSides(back,  B_back) ||
        ! CanMergeSides(front, B_front))
      return false;

    if (  front->x_offset == IVAL_NONE ||
        B_front->x_offset == IVAL_NONE)
      return true;

    int diff = B_front->x_offset - (front->x_offset + I_ROUND(length));

    // the < 4 accounts for precision loss after multiple merges
    return abs(diff) < 4; 
  }

  void Merge(linedef_info_c *B)
  {
    SYS_ASSERT(B->start == end);

    end = B->end;

    B->end->ReplaceLine(B, this);

    // fix X offset on back sidedef
    if (back && back->x_offset != IVAL_NONE)
      back->x_offset += I_ROUND(B->length);

    B->Kill();

    CalcLength();
  }

  bool isFrontSimilar(const linedef_info_c *P) const
  {
    if (! back && ! P->back)
      return (strcmp(front->mid.c_str(), P->front->mid.c_str()) == 0);

    if (back && P->back)
      return front->SameTex(P->front);

    const linedef_info_c *L = this;

    if (back)
      std::swap(L, P);

    // now L is single sided and P is double sided.

///---  if (P->mid[0] != '-')
///---    return false;

    // allow either upper or lower to match
    return (strcmp(L->front->mid.c_str(), P->front->lower.c_str()) == 0) ||
           (strcmp(L->front->mid.c_str(), P->front->upper.c_str()) == 0);
  }

  // here "greedy" means that from one side, both the upper and the lower
  // will be visible at the same time.
  inline bool isGreedy() const
  {
    if (! back)
      return false;

    int f1_h = front->sector->f_h;
    int f2_h = back ->sector->f_h;

    int c1_h = front->sector->c_h;
    int c2_h = back ->sector->c_h;

    return (f1_h < f2_h && c2_h < c1_h) ||
           (f1_h > f2_h && c2_h > c1_h);
  }
};


static std::vector<nukem_wall_c *>   nk_all_walls;
static std::vector<nukem_sector_c *> nk_all_sectors;

static int nk_current_wall;


//------------------------------------------------------------------------

void NK_FreeStuff()
{
  unsigned int i;

  for (i = 0 ; i < nk_all_walls.size()   ; i++) delete nk_all_walls[i];
  for (i=  0 ; i < nk_all_sectors.size() ; i++) delete nk_all_sectors[i];

  nk_all_walls.clear();
  nk_all_sectors.clear();
}


static void NK_MakeWall(nukem_sector_c *S, snag_c *snag)
{
  int x1 = I_ROUND(snag->x1 * NK_WALL_MUL);
  int y1 = I_ROUND(snag->y1 * NK_WALL_MUL);

  int x2 = I_ROUND(snag->x2 * NK_WALL_MUL);
  int y2 = I_ROUND(snag->y2 * NK_WALL_MUL);

  if (x1 == x2 && y1 == y2)
  {
    fprintf(stderr, "WARNING: degenerate wall @ (%d %d)\n", x1, y1);
    return;
  }

  nukem_wall_c *W = new nukem_wall_c(x1, y1, x2, y2);

  // FIXME: MORE STUFF !!!!!!

  S->AddWall(W);
}


static void NK_GetPlaneInfo(nukem_plane_c *P, csg_property_set_c *face)
{
  P->tex = atoi(face->getStr("tex", dummy_plane_tex.c_str()));

  // FIXME: other floor / ceiling stuff

}


static void NK_DoLightingBrush(...)
{
#if 0
  for (unsigned int i = 0; i < R->brushes.size(); i++)
  {
    csg_brush_c *B = R->brushes[i];

    if (B->bkind != BKIND_Light)
      continue;

    if (B->t.z < S->f_h+1 || B->b.z > S->c_h-1)
      continue;

    csg_property_set_c *t_face = &B->t.face;
    csg_property_set_c *b_face = &B->b.face;

    double raw = b_face->getInt("light", t_face->getInt("light"));
    int light = I_ROUND(raw * 256);

    if (light < 0)
    {
      // don't put shadow in closed doors
      if (S->f_h < S->c_h)
        S->misc_flags |= SEC_SHADOW;
      continue;
    }

    if (light > S->light)
    {
      S->light = light;
      S->misc_flags |= SEC_PRIMARY_LIT;
    }
  }
#endif
}


static void NK_MakeSector(region_c *R)
{
  unsigned int i;

  // completely solid (no gaps) ?
  if (R->gaps.size() == 0)
  {
    R->index = -1;
    return;
  }


  nukem_sector_c *S = new nukem_sector_c;

  S->region = R;

  R->index = (int)nk_all_sectors.size();

  nk_all_sectors.push_back(S);


  csg_brush_c *B = R->gaps.front()->bottom;
  csg_brush_c *T = R->gaps.back() ->top;

  csg_property_set_c *f_face = &B->t.face;
  csg_property_set_c *c_face = &T->b.face;


///???  S->CalcMiddle();


  // determine floor and ceiling heights
  double f_delta = f_face->getDouble("delta_z");
  double c_delta = c_face->getDouble("delta_z");

  dpuble f_h = B->t.z + f_delta;
  dpuble c_h = T->b.z + c_delta;

  S->f_h = I_ROUND(f_h * NK_HEIGHT_MUL);
  S->c_h = I_ROUND(c_h * NK_HEIGHT_MUL);

  if (S->c_h < S->f_h)
      S->c_h = S->f_h;


  NK_GetPlaneInfo(&S->floor, f_face);
  NK_GetPlaneInfo(&S->ceil,  c_face);


  int f_mark = f_face->getInt("mark");
  int c_mark = c_face->getInt("mark");

  S->mark = f_mark ? f_mark : c_mark;



  if (T->bkind == BKIND_Sky)
  {
    S->c_flags |= SECTOR_F_PARALLAX;
  }


  // handle Lighting brushes

  NK_DoLightingBrush(S);


  // create walls

  for (i = 0 ; i < R->snags.size() ; i++)
  {
    NK_MakeWall(S, R->snags[i]);
  }


  // grab entities

  for (i = 0 ; i < R->entities.size() ; i++)
    S->AddEntity(R->entities[i]);
}


static void NK_PartnerWalls()
{
  for (unsigned int i = 0 ; i < nk_all_sectors.size() ; i++)
  {
    nukem_sector_c *S = nk_all_sectors[i];

    for (unsigned int k = 0 ; k < S->walls.size() ; k++)
    {
      nukem_wall_c *W = S->walls[k];

      region_c *N = W->snag->partner ? W->snag->partner->where : NULL;

      if (N && N->index >= 0)
      {
        nukem_sector_c *T = nk_all_sectors[N->index];

        W->partner = T->FindSnagWall(W->snag->partner);
    }
  }
}


static void NK_CreateSectors()
{
  for (unsigned int i = 0 ; i < regions.size() ; i++)
  {
    NK_MakeSector(all_regions[i]);
  }
}


#if 0
static void LightingFloodFill(void)
{
  int i;
  std::vector<nukem_sector_c *> active;

  int valid_count = 1;

  for (i = 1; i < (int)dm_sectors.size(); i++)
  {
    nukem_sector_c *S = dm_sectors[i];

    if (S->misc_flags & SEC_PRIMARY_LIT)
    {
      active.push_back(dm_sectors[i]);
      S->valid_count = valid_count;
    }
  }

  while (! active.empty())
  {
    valid_count++;

//fprintf(stderr, "LightingFloodFill: active=%d\n", active.size());

    std::vector<nukem_sector_c *> changed;

    for (i = 0; i < (int)active.size(); i++)
    {
      nukem_sector_c *S = active[i];

      for (int k = 0; k < (int)S->region->segs.size(); k++)
      {
        merge_segment_c *G = S->region->segs[k];

        if (! G->front || ! G->back)
          continue;

        if (G->front->index <= 0 || G->back->index <= 0)
          continue;

        nukem_sector_c *F = dm_sectors[G->front->index];
        nukem_sector_c *B = dm_sectors[G->back ->index];

        if (! (F==S || B==S))
          continue;

        if (B == S)
          std::swap(F, B);

        if (B->misc_flags & SEC_PRIMARY_LIT)
          continue;

        int light = MIN(F->light, 176);

        SYS_ASSERT(B != F);

        double dist = ComputeDist(F->mid_x,F->mid_y, B->mid_x,B->mid_y);

        double A = log(light) / log(2);
        double L2 = pow(2, A - dist / light_dist_factor);

        light = (int)L2;

        // less light through closed doors
        if (F->f_h >= B->c_h || B->f_h >= F->c_h)
          light -= 32;

        if (B->light >= light)
          continue;

        // spread brighter light into back sector
          
        B->light = light;

        if (B->valid_count != valid_count)
        {
          B->valid_count = valid_count;
          changed.push_back(B);
        }
      }
    }

    std::swap(active, changed);
  }

//fprintf(stderr, "LightingFloodFill EMPTY\n");

  for (i = 0; i < (int)dm_sectors.size(); i++)
  {
    nukem_sector_c *S = dm_sectors[i];

    if (smoother_lighting)
      S->light = ((S->light + 1) / 8) * 8;
    else
      S->light = ((S->light + 3) / 16) * 16;

    if ((S->misc_flags & SEC_SHADOW))
      S->light -= (S->light > 168) ? 48 : 32;

    if (S->light <= 64)
      S->light = 96;
    else if (S->light < 112)
      S->light = 112;
    else if (S->light > 255)
      S->light = 255;
  }
}
#endif


#if 0
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

      nukem_sector_c *F = dm_sectors[S->front->index];
      nukem_sector_c *B = dm_sectors[S->back ->index];

      if (F->Match(B))
      {
        S->front->index = MIN(S->front->index, S->back->index);
        S->back ->index = S->front->index;

        changes++;
      }
    }

// fprintf(stderr, "CoalesceSectors: changes = %d\n", changes);

    if (changes == 0)
      return;
  }
}
#endif



//------------------------------------------------------------------------


static int NaturalXOffset(linedef_info_c *G, int side)
{
  double along;
  
  if (side == 0)
    along = AlongDist(0, 0,  G->start->x, G->start->y, G->end->x, G->end->y);
  else
    along = AlongDist(0, 0,  G->end->x, G->end->y, G->start->x, G->start->y);

  return I_ROUND(- along);
}

static int CalcXOffset(merge_segment_c *G, int side, brush_vert_c *V, double x_offset) 
{
  double along = 0;
  
  if (V)
  {
    if (side == 0)
      along = ComputeDist(V->x, V->y, G->start->x, G->start->y);
    else
      along = ComputeDist(V->x, V->y, G->end->x, G->end->y);
  }

  return (int)(along + x_offset);
}

static int CalcRailYOffset(brush_vert_c *rail, int base_h)
{
  int y_offset = I_ROUND(rail->parent->b.z) - base_h;

  return y_offset;   ///--- MAX(0, y_offset);
}


static sidedef_info_c * MakeSidedef(merge_segment_c *G, int side,
                       merge_region_c *F, merge_region_c *B,
                       brush_vert_c *rail,
                       bool *l_peg, bool *u_peg)
{
  if (! (F && F->index > 0))
    return NULL;

///  int index = (int)dm_sidedefs.size();

  sidedef_info_c *SD = new sidedef_info_c;

  dm_sidedefs.push_back(SD);

  nukem_sector_c *S = dm_sectors[F->index];

  SD->sector = S;

  // the 'natural' X/Y offsets
  SD->x_offset = IVAL_NONE;  //--- NaturalXOffset(G, side);
  SD->y_offset = - S->c_h;

  if (B && B->index > 0)
  {
    nukem_sector_c *BS = dm_sectors[B->index];

    csg_brush_c *l_brush = B->gaps.front()->b_brush;
    csg_brush_c *u_brush = B->gaps.back() ->t_brush;

    SYS_ASSERT(l_brush && u_brush);

    brush_vert_c *l_vert = G->FindSide(l_brush);
    brush_vert_c *u_vert = G->FindSide(u_brush);

    if (! l_vert) l_vert = l_brush->verts[0];
    if (! u_vert) u_vert = u_brush->verts[0];

    SYS_ASSERT(l_vert && u_vert);

    csg_property_set_c *lower_W = &l_vert->face;
    csg_property_set_c *upper_W = &u_vert->face;

    SD->lower = lower_W->getStr("tex", dummy_wall_tex.c_str());
    SD->upper = upper_W->getStr("tex", dummy_wall_tex.c_str());

    if (lower_W->getInt("peg")) *l_peg = true;
    if (upper_W->getInt("peg")) *u_peg = true;

    csg_property_set_c *rail_W = rail ? &rail->face : NULL;

    if (rail_W)
    {
      SD->mid = rail_W->getStr("tex", "-");

      *l_peg = false;
    }

    int r_ox = IVAL_NONE;
    if (rail_W) r_ox = rail_W->getInt("x_offset", r_ox);

    int l_ox = lower_W->getInt("x_offset", IVAL_NONE);
    int l_oy = lower_W->getInt("y_offset", IVAL_NONE);

    int u_ox = upper_W->getInt("x_offset", IVAL_NONE);
    int u_oy = upper_W->getInt("y_offset", IVAL_NONE);

    if (r_ox != IVAL_NONE)
      SD->x_offset = CalcXOffset(G, side, rail, r_ox);
    else if (l_ox != IVAL_NONE)
      SD->x_offset = CalcXOffset(G, side, l_vert, l_ox);
    else if (u_ox != IVAL_NONE)
      SD->x_offset = CalcXOffset(G, side, u_vert, u_ox);

    if (rail_W)
      SD->y_offset = CalcRailYOffset(rail, MAX(S->f_h, BS->f_h));
    else if (l_oy != IVAL_NONE)
      SD->y_offset = l_oy;
    else if (u_oy != IVAL_NONE)
      SD->y_offset = u_oy;
  }
  else  // one-sided line
  {
    double mz = (S->f_h + S->c_h) / 2.0;

    brush_vert_c *m_vert = CSG2_FindSideVertex(G, mz, side == 1, true);

    brush_vert_c *m_side = CSG2_FindSideFace(G, mz, side == 1, m_vert);

    if (! m_side)
    {
      SD->mid = dummy_wall_tex.c_str();
    }
    else
    {
      csg_property_set_c *mid_W = &m_side->face;

      SD->mid = mid_W->getStr("tex", dummy_wall_tex.c_str());

      if (mid_W->getInt("peg")) *l_peg = true;

      int ox = mid_W->getInt("x_offset", IVAL_NONE);
      int oy = mid_W->getInt("y_offset", IVAL_NONE);

      if (ox != IVAL_NONE)
        SD->x_offset = CalcXOffset(G, side, m_vert, ox);

      if (oy != IVAL_NONE)
        SD->y_offset = oy;
    }
  }

  return SD;
}



//----------------------------------------------------------------------

void nukem_wall_c::Write()
{
  int pic;
  int flags = 0;

  if (! back)
  {
    pic = atoi(line->front->mid.c_str());
  }
  else if (line->isGreedy())
  {
    int f1_h = line->front->sector->f_h;
    int f2_h = line->back ->sector->f_h;

    bool use_upper = ((side==0) == (f1_h < f2_h));

    const sidedef_info_c *SD = (f1_h < f2_h) ? line->front : line->back;

    pic = atoi(use_upper ? SD->upper.c_str() : SD->lower.c_str());

    flags |= WALL_F_SWAP_LOWER;
  }
  else
  {
    int c1_h = line->front->sector->c_h;
    int c2_h = line->back ->sector->c_h;

    bool use_upper = (side==0) ? (c2_h < c1_h) : (c1_h < c2_h);

    const sidedef_info_c *SD = (side==0) ? line->front : line->back;

    pic = atoi(use_upper ? SD->upper.c_str() : SD->lower.c_str());
  }

  if (back)
    flags |= WALL_F_PEGGED;

  int xscale = 1 + (int)line->length / 16;
  if (xscale > 255)
    xscale = 255;

  int lo_tag = (side==0) ? line->type : 0;
  int hi_tag = (side==0) ? line->tag  : 0;


  NK_AddWall(GetX() * NK_FACTOR, -GetY() * NK_FACTOR, right->index,
             back ? back->index : -1, back ? back->SectorIndex() : -1,
             flags, pic, 0,
             xscale, 8, 0, 0,
             lo_tag, hi_tag);
}


void nukem_sector_c::WriteSprites()
{
  for (unsigned int j = 0; j < S->entities.size(); j++)
  {
    entity_info_c *E = S->entities[j];

    int x = I_ROUND( E->x * NK_WALL_MUL)
    int y = I_ROUND(-E->y * NK_WALL_MUL)
    int z = I_ROUND( E->z * NK_HEIGHT_MUL)

    int type = atoi(E->name.c_str());

    // parse entity properties
    int angle  = 0;
    int lo_tag = 0;
    int hi_tag = 0;

    std::map<std::string, std::string>::iterator MI;
    for (MI = E->props.begin(); MI != E->props.end(); MI++)
    {
      const char *name  = MI->first.c_str();
      const char *value = MI->second.c_str();

      if (StringCaseCmp(name, "angle") == 0)
        angle = atoi(value);
      else if (StringCaseCmp(name, "lo_tag") == 0)
        lo_tag = atoi(value);
      else if (StringCaseCmp(name, "hi_tag") == 0)
        hi_tag = atoi(value);
    }

    // convert angle to 0-2047 range
    angle = ((405 - angle) * 256 / 45) & 2047;

    NK_AddSprite(x, y, z, type, angle, index, lo_tag, hi_tag);
  }
}


void nukem_sector_c::AssignWallIndices(int *first, int *count)
{
  *first = nk_current_wall;
  *count = (int) S->walls.size();

  for (unsigned int i = 0 ; i < S->walls.size() ; i++)
  {
    S->walls[i]->index = nk_current_wall;

    nk_current_wall++;
  }
}


void nukem_sector_c::WriteWalls()
{
  for (unsigned int k = 0 ; k < walls.size() ; k++)
  {
    walls[k]->Write();
  }
}


void nukem_sector_c::Write()
{
  int first_wall, num_walls;

  NK_AssignWallIndices(S->walls, &first_wall, &num_walls);

  int c_flags = 0;
  int visibility = 1;

  NK_AddSector(first_wall, num_walls, visibility,
               floor.h, floor.tex,
               ceil.h,  ceil.tex,  ceil.flags,
               0, 0);
}


static void NK_WriteSectors()
{
  nk_current_wall = 0;

  for (unsigned int i = 0 ; i < nk_all_sectors.size() ; i++)
  {
    nukem_sector_c *S = nk_all_sectors[i];

    if (! S->used)
      continue;

    S->index = (int)i;

    S->Write();
    S->WriteSprites();
  }
}


static void NK_WriteWalls()
{
  for (unsigned int i = 0 ; i < nk_all_sectors.size() ; i++)
  {
    nukem_sector_c *S = nk_all_sectors[i];

    if (! S->used)
      continue;

    S->WriteWalls();
  }
}


//------------------------------------------------------------------------

void CSG_NUKEM_Write()
{
  nk_all_sectors.clear();
  nk_all_walls.clear();

  CSG_BSP(1.0);

  CSG_SwallowBrushes();
  CSG_DiscoverGaps();

  NK_CreateSectors();
  NK_PartnerWalls();

//  NK_MakeLinedefs();
//  NK_MergeColinearLines();

  NK_WriteSectors();
  NK_WriteWalls();

  NK_FreeStuff();
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
