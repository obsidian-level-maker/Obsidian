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


class nukem_wall_c;


class nukem_sector_c 
{
public:
  int f_h;
  int c_h;

  std::string f_tex;
  std::string c_tex;

  region_c *region;

  int f_flags;
  int c_flags;

  int mark;

int light;
int special;
int tag;

  int index;

double mid_x, mid_y;  // invalid after CoalesceSectors

int misc_flags;
int valid_count;

public:
  nukem_sector_c() : f_h(0), c_h(0), f_tex(), c_tex(),
                    light(64), special(0), tag(0), mark(0),
                    exfloors(), index(-1),
                    region(NULL), misc_flags(0), valid_count(0)
  { }

  ~nukem_sector_c()
  { }

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

  int Write()
  {
    if (index < 0)
    {
      index = DM_NumSectors();

      DM_AddSector(f_h, f_tex.c_str(),
                   c_h, c_tex.c_str(),
                   light, special, tag);
    }

    return index;
  }
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


class nukem_wall_c
{
public:
  int x1, y1;
  int x2, y2;

  //....  FIXME

  snag_c *snag;

  nukem_wall_c *partner;

  nukem_sector_c *sector;

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

  void Write()
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
};


static std::vector<nukem_wall_c *>   nk_all_walls;
static std::vector<nukem_sector_c *> nk_all_sectors;


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

  S->AddWall(W);
}


static void NK_MakeSector(region_c *R)
{
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


  S->f_tex = f_face->getStr("tex", dummy_plane_tex.c_str());
  S->c_tex = c_face->getStr("tex", dummy_plane_tex.c_str());

  int f_mark = f_face->getInt("mark");
  int c_mark = c_face->getInt("mark");

  S->mark = f_mark ? f_mark : c_mark;


  // FIXME: other floor / ceiling stuff


  if (T->bkind == BKIND_Sky)
  {
    S->c_flags |= SECTOR_F_PARALLAX;
  }


  // handle Lighting brushes

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


  // make walls

  for (unsigned int k = 0 ; k < R->snags.size() ; k++)
  {
    NK_MakeWall(S, R->snags[k]);
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


static void NK_CreateSectors(void)
{
  for (unsigned int i = 0 ; i < regions.size() ; i++)
  {
    NK_MakeSector(all_regions[i]);
  }
}


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


static void MakeLinedefs(void)
{
  for (unsigned int i = 0; i < mug_segments.size(); i++)
  {
    merge_segment_c *G = mug_segments[i];

    SYS_ASSERT(G);
    SYS_ASSERT(G->start);

    if (! (G->front && G->front->index > 0) &&
        ! (G->back  && G-> back->index > 0))
      continue;

    // skip segments which would become zero length linedefs
    if (I_ROUND(G->start->x) == I_ROUND(G->end->x) &&
        I_ROUND(G->start->y) == I_ROUND(G->end->y))
      continue;

    brush_vert_c *spec = FindSpecialVert(G);
    brush_vert_c *rail = FindRailVert(G);

    // if same sector on both sides, skip the line, unless
    // we have a rail texture or a special line.
    if (! rail && ! spec && G->front && G->back && G->front->index == G->back->index)
    {
      continue;
    }


    linedef_info_c *L = new linedef_info_c;

    dm_linedefs.push_back(L);

    L->start = MakeVertex(G->start);
    L->end   = MakeVertex(G->end);

    L->start->AddLine(L);
    L->end  ->AddLine(L);

    L->CalcLength();


    bool l_peg = false;
    bool u_peg = false;

    L->front = MakeSidedef(G, 0, G->front, G->back, rail, &l_peg, &u_peg);
    L->back  = MakeSidedef(G, 1, G->back, G->front, rail, &l_peg, &u_peg);

    SYS_ASSERT(L->front || L->back);

    // TODO: a way to ensure a certain orientation (two-sided lines only)
    if (L->ShouldFlip())
      L->Flip();


    if (! L->back)
      L->flags |= MLF_BlockAll;
    else
      L->flags |= MLF_TwoSided | MLF_LowerUnpeg | MLF_UpperUnpeg;

    if (l_peg) L->flags ^= MLF_LowerUnpeg;
    if (u_peg) L->flags ^= MLF_UpperUnpeg;


    if (rail)
    {
      L->flags |= rail->face.getInt("flags");

      if (! spec && rail->face.getStr("kind"))
        spec = rail;
    }

    if (spec)
    {
      L->flags |= spec->face.getInt("flags");

      L->type = spec->face.getInt("kind");
      L->tag  = spec->face.getInt("tag");

      spec->face.getHexenArgs("args", L->args);
    }
  }
}


//----------------------------------------------------------------------


static void NK_Chain(int start, nk_wall_list_c& prelim, nk_wall_list_c *circle,
                     int *wall_id)
{
// fprintf(stderr, "starting at %d\n", start);

  int last = start;

  nukem_wall_c *start_W = prelim[start];

  for (;;)
  {
    nukem_wall_c *cur = prelim[last];  SYS_ASSERT(cur);
    prelim[last] = NULL;

// fprintf(stderr, "  adding %d @ wall_id:%d\n", last, *wall_id);

    cur->index = *wall_id;  (*wall_id) += 1;
    circle->push_back(cur);

    last = -1;

    for (int k = 0; k < (int)prelim.size(); k++)
    {
      nukem_wall_c *W2 = prelim[k];
      if (! W2)
        continue;
       
      if ( (cur->side == 0 && cur->line->end  ->HasLine(W2->line)) ||
           (cur->side == 1 && cur->line->start->HasLine(W2->line)) )
      {
        cur->right = W2;
        last = k;
        break;
      }
    }
// fprintf(stderr, "Found right %p (%d)\n", cur->right, last);

    if (! cur->right)
    {
      SYS_ASSERT(start_W != cur);

      cur->right = start_W;
// fprintf(stderr, "End of loop, using %p\n", cur->right);
      return;
    }
  }
}


static void NK_CollectWalls(nukem_sector_c *S, int *wall_id, nk_wall_list_c *circle)
{
  int i;

  std::vector<nukem_wall_c *> prelim;

// fprintf(stderr, "\nWall list @ sec:%d\n", S->index);
  for (i = 0; i < (int)dm_linedefs.size(); i++)
  {
    linedef_info_c *L = dm_linedefs[i];
    if (! L->Valid())
      continue;

    if (! (L->front->sector == S || (L->back && L->back->sector == S)))
      continue;

    // HMMM
    if (L->front->sector == S && L->back && L->back->sector == S)
      continue;

    nukem_wall_c *W = new nukem_wall_c(L, (L->front->sector == S) ? 0 : 1);

    if (W->side == 0)
      L->nk_front = W;
    else
      L->nk_back = W;

//fprintf(stderr, "  %i=%p line:%p side:%d (%d %d) --> (%d %d)\n",
//(int)prelim.size(), W, W->line, W->side,
//W->line->start->x, W->line->start->y,
//W->line->end->x, W->line->end->y);

    prelim.push_back(W);
  }

//fprintf(stderr, "\n");

  // group into wall loops

  int total = (int)prelim.size();

  SYS_ASSERT(total >= 2);

  for (i = 0; i < total; i++)
  {
    if (prelim[i])
      NK_Chain(i, prelim, circle, wall_id);
  }
}


static void NK_WriteWalls()
{
  int i;

  // mark all visible sectors
  for (i = 0; i < (int)dm_sectors.size(); i++)
    dm_sectors[i]->index = -1;

  for (i = 0; i < (int)dm_linedefs.size(); i++)
  {
    linedef_info_c *L = dm_linedefs[i];
    if (! L->Valid())
      continue;

    if (L->front->sector->index < 0)
    {
      L->front->sector->index = -2;
    }

    if (L->back && L->back->sector->index < 0)
    {
      L->back->sector->index = -2;
    }
  }

  int sec_id = 0;

  for (i = 0; i < (int)dm_sectors.size(); i++)
  {
    nukem_sector_c * S = dm_sectors[i];

    if (S->index == -2)
    {
      S->index = sec_id;  sec_id += 1;
    }
  }


  // find the walls of each sector

  std::vector<nk_wall_list_c *> sec_walls;

  for (int k = 0; k < sec_id; k++)
    sec_walls.push_back(new nk_wall_list_c);


  int wall_id = 0;

  for (i = 0; i < (int)dm_sectors.size(); i++)
  {
    nukem_sector_c *S = dm_sectors[i];
    if (S->index < 0)
      continue;

    NK_CollectWalls(S, &wall_id, sec_walls[S->index]);
  }


  // CONNECT FRONT AND BACK
  for (i = 0; i < (int)dm_linedefs.size(); i++)
  {
    linedef_info_c *L = dm_linedefs[i];
    if (! L->Valid())
      continue;

    if (L->nk_front && L->nk_back)
    {
      L->nk_front->back = L->nk_back;
      L->nk_back ->back = L->nk_front;
    }
  }


  // create the sectors
  for (i = 0; i < (int)dm_sectors.size(); i++)
  {
    nukem_sector_c *S = dm_sectors[i];
    if (S->index < 0)
      continue;

    int first =      sec_walls[S->index]->at(0)->index; 
    int count = (int)sec_walls[S->index]->size();

    int c_flags = 0;
    int visibility = 1;

    if (S->misc_flags & SEC_IS_SKY)
    {
      c_flags |= SECTOR_F_PARALLAX;
    }




    // WRITE THE WALL LOOP

    for (int k = 0; k < count; k++)
    {
      sec_walls[S->index]->at(k)->Write();
    }
  }


  // free stuff

  for (i = 0; i < (int)dm_sectors.size(); i++)
  {
    nukem_sector_c *S = dm_sectors[i];
    if (S->index < 0)
      continue;

    int count = (int)sec_walls[S->index]->size();

    for (int k = 0; k < count; k++)
    {
      delete sec_walls[S->index]->at(k);
    }

    delete sec_walls[S->index];
  }
}


static void NK_WriteSprites(void)
{
  for (unsigned int j = 0; j < all_entities.size(); j++)
  {
    entity_info_c *E = all_entities[j];

    int type = atoi(E->name.c_str());

    // parse entity properties
    int angle = 0;
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


    int sec = 0;

    merge_region_c *REG = CSG2_FindRegionForPoint(E->x, E->y);
    if (REG && REG->index >= 0)
    {
      nukem_sector_c *S = dm_sectors[REG->index];
      if (S->index >= 0)
      {
        sec = S->index;
      }
    }


    NK_AddSprite(I_ROUND( E->x * NK_WALL_MUL),
                 I_ROUND(-E->y * NK_WALL_MUL),
                 I_ROUND( E->z * NK_HEIGHT_MUL),
                 type, angle, sec,
                 lo_tag, hi_tag);
  }
}


static void NK_WriteSectors()
{
  for (unsigned int i = 0 ; i < nk_all_sectors.size() ; i++)
  {
    nukem_sector_c *S = nk_all_sectors[i];

    if (! S->used)
      continue;

    S->index = (int)i;

    NK_WriteSprites(S);

    int first_wall = NK_MarkWalls(S->walls);
    int num_walls  = (int)S->walls.size();

    int c_flags = 0;
    int visibility = 1;

    NK_AddSector(first_wall, num_walls, visibility,
                 S->f_h, atoi(S->f_tex.c_str()),
                 S->c_h, atoi(S->c_tex.c_str()), c_flags,
                 S->special, S->tag);
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

//  NK_MakeLinedefs();
//  NK_MergeColinearLines();

  NK_WriteSectors();
  NK_WriteWalls();
  NK_WriteSprites();

  NK_FreeStuff();
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
