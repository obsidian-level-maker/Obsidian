//------------------------------------------------------------------------
//  QUAKE 1 CLIPPING HULLS
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
#include "hdr_ui.h"

#include "lib_file.h"
#include "lib_util.h"

#include "main.h"
#include "m_lua.h"

#include "q_common.h"
#include "q_light.h"
#include "q1_structs.h"

#include "csg_main.h"
#include "csg_local.h"
#include "csg_quake.h"


#define CLIP_EPSILON  0.01


extern qLump_c *q1_clip;

extern int q1_total_clip;


static double hull_sizes[3][3] =
{
  { 16, 24, 32 },  // player
  { 32, 24, 64 },  // monsters
  { 16, 24,  0 },  // crouching (Half-Life only)
};

static double h2_hull_sizes[5][3] =
{
   { 16, 24, 32 },  // player
   { 24, 20, 20 },  // scorpion
   { 16, 12, 16 },  // crouch
   {  8,  8,  8 },  // pentacles
   { 28, 40, 40 },  // yak
};


class cpSide_c
{
public:
  snag_c *snag;

  bool on_node;

  double x1, y1;
  double x2, y2;

public:
  cpSide_c(snag_c *S) :
      snag(S), on_node(false),
      x1(S->x1), y1(S->y1), x2(S->x2), y2(S->y2)
  { }

  cpSide_c(const cpSide_c *other) :
      snag(other->snag), on_node(other->on_node),
      x1(other->x1), y1(other->y1), x2(other->x2), y2(other->y2)
  { }

  ~cpSide_c()
  { }

public:
  double Length() const
  {
    return ComputeDist(x1,y1, x2,y2);
  }

  bool TwoSided() const
  {
    if (! snag->partner)
      return false;

    if (! snag->partner->region)
      return false;

    if (snag->partner->region->index == 0)
      return false;

    return true;
  }
};


class cpFlat_c
{
public:
  gap_c *gap;

  double z, dz;

public:
  cpFlat_c(gap_c *G, bool _ceil) : gap(G)
  {
    z  = _ceil ? gap->top->b.z : gap->bottom->t.z;
    dz = _ceil ? -1 : 1;
  }

  ~cpFlat_c()
  { }
};


typedef enum
{
  PKIND_INVALID = 0,

  PKIND_SIDE = 1,
  PKIND_FLAT = 2
}
clip_partition_kind_e;


class cpPartition_c
{
public:
  int kind;

  double x1, y1;
  double x2, y2;

  double z, dz;

public:
  cpPartition_c() : kind(PKIND_INVALID)
  { }

  cpPartition_c(const cpSide_c * S) :
      kind(PKIND_SIDE),
      x1(S->x1), y1(S->y1), x2(S->x2), y2(S->y2),
      z(), dz()
  { }

  cpPartition_c(const cpFlat_c * F) :
      kind(PKIND_FLAT),
      x1(), y1(), x2(), y2(),
      z(F->z), dz(F->dz)
  { }

  cpPartition_c(const gap_c * G, bool is_ceil) :
      kind(PKIND_FLAT),
      x1(), y1(), x2(), y2()
  {
    z  = is_ceil ? G->top->b.z : G->bottom->t.z;
    dz = is_ceil ? -1 : 1;
  }

  cpPartition_c(const cpPartition_c *other) :
      kind(other->kind),
      x1(other->x1), y1(other->y1),
      x2(other->x2), y2(other->y2),
      z(other->z), dz(other->dz)
  { }

  ~cpPartition_c()
  { }

  void Set(const cpSide_c * S)
  {
    kind = PKIND_SIDE;

    x1 = S->x1; y1 = S->y1;
    x2 = S->x2; y2 = S->y2;
  }

  void Set(const cpFlat_c * F)
  {
    kind = PKIND_FLAT;

    z  = F->z;
    dz = F->dz;
  }

  void Set(const cpPartition_c *other)
  {
    kind = other->kind;

    x1 = other->x1; y1 = other->y1;
    x2 = other->x2; y2 = other->y2;

    z  = other->z;  dz = other->dz;
  }
};


class cpGroup_c
{
public:
  std::vector<cpSide_c *> sides;

public:
  cpGroup_c() : sides()
  { }

  ~cpGroup_c()
  { }

  void AddSide(cpSide_c *S)
  {
    sides.push_back(S);
  }

  bool IsEmpty() const
  {
    return sides.empty();
  }
};


class cpNode_c
{
public:
  /* LEAF STUFF */

#define CONTENT__NODE  12345

  int contents;

  std::vector<cpSide_c *> sides;
  std::vector<cpFlat_c *> flats;

  region_c *region;  // only set by CheckSameRegion()


  /* NODE STUFF */

  cpPartition_c part;

  cpNode_c *front;  // front space
  cpNode_c *back;   // back space

  int index;

public:
  // LEAF
  cpNode_c(int _contents = CONTENTS_EMPTY) :
        contents(_contents),
        sides(), flats(), region(NULL),
        part(), front(NULL), back(NULL), index(-1)
  { }

  cpNode_c(const cpPartition_c& _part) :
        contents(CONTENT__NODE),
        sides(), flats(), region(NULL),
        part(_part), front(NULL), back(NULL), index(-1)
  { }

  cpNode_c(const gap_c *G, bool is_ceil) :
        contents(CONTENT__NODE),
        sides(), flats(), region(NULL),
        part(G, is_ceil), front(NULL), back(NULL), index(-1)
  { }

  ~cpNode_c()
  {
    if (front) delete front;
    if (back)  delete back;
  }

  inline bool IsNode()  const { return contents == CONTENT__NODE; }
  inline bool IsLeaf()  const { return contents != CONTENT__NODE; }
  inline bool IsSolid() const { return contents == CONTENTS_SOLID; }

  inline bool HasFlat() const { return ! flats.empty(); }

  bool HasSide() const
  {
    for (unsigned int i = 0 ; i < sides.size() ; i++)
      if (! sides[i]->on_node)
        return true;

    return false;
  }

  bool IsEmpty() const
  {
    return ! HasFlat() && ! HasSide();
  }

  void AddSide(cpSide_c *S)
  {
    sides.push_back(S);
  }

  void NewSide(snag_c *S)
  {
    AddSide(new cpSide_c(S));
  }

  void CopySides(cpNode_c *other)
  {
    for (unsigned int i = 0 ; i < other->sides.size() ; i++)
      AddSide(other->sides[i]);
  }

  void MakeNode(const cpPartition_c *_part)
  {
    contents = CONTENT__NODE;

    part.Set(_part);

    sides.clear();
    flats.clear();
  }

  void CheckValid() const
  {
    SYS_ASSERT(index >= 0);
  }

  void CalcBounds(double *lx, double *ly, double *w, double *h) const
  {
    SYS_ASSERT(contents != CONTENT__NODE);

    double hx = -99999; *lx = +99999;
    double hy = -99999; *ly = +99999;

    for (unsigned int i = 0; i < sides.size(); i++)
    {
      cpSide_c *S = sides[i];

      double x1 = MIN(S->x1, S->x2);
      double y1 = MIN(S->y1, S->y2);
      double x2 = MAX(S->x1, S->x2);
      double y2 = MAX(S->y1, S->y2);

      if (x1 < *lx) *lx = x1;
      if (y1 < *ly) *ly = y1;
      if (x2 >  hx)  hx = x2;
      if (y2 >  hy)  hy = y2;
    }

    *w = (*lx > hx) ? 0 : (hx - *lx);
    *h = (*ly > hy) ? 0 : (hy - *ly);
  }

  void AddFlat(cpFlat_c *F)
  {
    flats.push_back(F);
  }

  void CopyFlats(cpNode_c *other)
  {
    for (unsigned int i = 0 ; i < other->flats.size() ; i++)
      AddFlat(other->flats[i]);
  }

  void CreateFlats()
  {
    SYS_ASSERT(region->gaps.size() > 0);

    for (unsigned int i = 0 ; i < region->gaps.size() ; i++)
    {
      gap_c *G = region->gaps[i];

      AddFlat(new cpFlat_c(G, false));
      AddFlat(new cpFlat_c(G, true));
    }
  }

};



static std::vector<csg_brush_c *> saved_all_brushes;

static std::vector<cpSide_c *> all_clip_sides;


//------------------------------------------------------------------------

static void SaveBrushes(void)
{
  saved_all_brushes.clear();

  std::swap(all_brushes, saved_all_brushes);
}


static void RestoreBrushes(void)
{
  // free our modified ones
  for (unsigned int i = 0; i < all_brushes.size(); i++)
    delete all_brushes[i];

  all_brushes.clear();

  std::swap(all_brushes, saved_all_brushes);
}


static void CalcNormal(double x1, double y1, double x2, double y2,
                       double *nx, double *ny)
{
  *nx = (y2 - y1);
  *ny = (x1 - x2);

  double n_len = ComputeDist(x1, y1, x2, y2);
  SYS_ASSERT(n_len > 0.0001);

  *nx /= n_len;
  *ny /= n_len;
}

static double CalcIntersect_Y(double nx1, double ny1, double nx2, double ny2,
                              double x)
{
    double a = nx1 - x;
    double b = nx2 - x;

    // BIG ASSUMPTION: lines are not parallel or colinear
    SYS_ASSERT(fabs(a - b) > CLIP_EPSILON);

    // determine the intersection point
    double along = a / (a - b);

    return ny1 + along * (ny2 - ny1);
}

static double CalcIntersect_X(double nx1, double ny1, double nx2, double ny2,
                              double y)
{
    double a = ny1 - y;
    double b = ny2 - y;

    // BIG ASSUMPTION: lines are not parallel or colinear
    SYS_ASSERT(fabs(a - b) > CLIP_EPSILON);

    // determine the intersection point
    double along = a / (a - b);

    return nx1 + along * (nx2 - nx1);
}


static void FattenVertex3(const csg_brush_c *P, unsigned int k,
                          csg_brush_c *P2, double pad)
{
  unsigned int total = P->verts.size();

  brush_vert_c *kv = P->verts[k];

  brush_vert_c *pv = P->verts[(k + total - 1) % total];
  brush_vert_c *nv = P->verts[(k + 1        ) % total];

  // if the two lines are co-linear (or near enough), then we
  // can skip this vertex altogether.

  if (fabs(PerpDist(kv->x, kv->y, pv->x, pv->y, nv->x, nv->y)) < 4.0*CLIP_EPSILON)
    return;

  double pdx = kv->x - pv->x;
  double pdy = kv->y - pv->y;

  double ndx = kv->x - nv->x;
  double ndy = kv->y - nv->y;

  double factor = 1000.0;

  // determine what side of axis the other vertices are on
  int px_side = 0, py_side = 0;
  int nx_side = 0, ny_side = 0;

  if (fabs(pdx) * factor > fabs(pdy))
  {
    if (pv->x < kv->x) px_side = -1;
    if (pv->x > kv->x) px_side = +1;
  }
  if (fabs(pdy) * factor > fabs(pdx))
  {
    if (pv->y < kv->y) py_side = -1;
    if (pv->y > kv->y) py_side = +1;
  }

  if (fabs(ndx) * factor > fabs(ndy))
  {
    if (nv->x < kv->x) nx_side = -1;
    if (nv->x > kv->x) nx_side = +1;
  }
  if (fabs(ndy) * factor > fabs(ndx))
  {
    if (nv->y < kv->y) ny_side = -1;
    if (nv->y > kv->y) ny_side = +1;
  }


  // NOTE: these normals face OUTWARDS (anti-normals?)
  double p_nx, p_ny;
  double n_nx, n_ny;

  CalcNormal(pv->x, pv->y, kv->x, kv->y, &p_nx, &p_ny);
  CalcNormal(kv->x, kv->y, nv->x, nv->y, &n_nx, &n_ny);


  // see whether BOTH vertices are on the same side
  int x_side = (px_side == nx_side) ? px_side : 0;
  int y_side = (py_side == ny_side) ? py_side : 0;

  double ix, iy;

  if (x_side) ix = kv->x - x_side * pad;
  if (y_side) iy = kv->y - y_side * pad;

  if (x_side && y_side)
  {
    // When both vertices are in the same quadrant,
    // then it's pretty easy: we get three new vertices
    // which form a small box.  Only interesting part is
    // what order to add them.
    
    if (x_side == y_side)
    {
      P2->verts.push_back(new brush_vert_c(P2, ix,    kv->y));
      P2->verts.push_back(new brush_vert_c(P2, ix,    iy));
      P2->verts.push_back(new brush_vert_c(P2, kv->x, iy));
    }
    else
    {
      P2->verts.push_back(new brush_vert_c(P2, kv->x, iy));
      P2->verts.push_back(new brush_vert_c(P2, ix,    iy));
      P2->verts.push_back(new brush_vert_c(P2, ix,    kv->y));
    }
  }
  else if (x_side)
  {
    // Lines form a < or > shape, and we need to clip the
    // fattened vertex along a vertical line.
    double py = CalcIntersect_Y(pv->x + pad * p_nx, pv->y + pad * p_ny,
                                kv->x + pad * p_nx, kv->y + pad * p_ny,
                                ix);
    
    double ny = CalcIntersect_Y(nv->x + pad * n_nx, nv->y + pad * n_ny,
                                kv->x + pad * n_nx, kv->y + pad * n_ny,
                                ix);

    P2->verts.push_back(new brush_vert_c(P2, ix, py));
    P2->verts.push_back(new brush_vert_c(P2, ix, ny));
  }
  else if (y_side)
  {
    // Lines form an ^ or v shape, and we need to clip the
    // fattened vertex along a horizontal line.
    double px = CalcIntersect_X(pv->x + pad * p_nx, pv->y + pad * p_ny,
                                kv->x + pad * p_nx, kv->y + pad * p_ny,
                                iy);
    
    double nx = CalcIntersect_X(nv->x + pad * n_nx, nv->y + pad * n_ny,
                                kv->x + pad * n_nx, kv->y + pad * n_ny,
                                iy);

    P2->verts.push_back(new brush_vert_c(P2, px, iy));
    P2->verts.push_back(new brush_vert_c(P2, nx, iy));
  }
  else
  {
    // Lines must go between diagonally opposite quadrants
    // or one or both of them are purely horizontal or
    // vertical.  A simple intersection is all we need.
    CalcIntersection(pv->x + pad * p_nx, pv->y + pad * p_ny,
                     kv->x + pad * p_nx, kv->y + pad * p_ny,
                     nv->x + pad * n_nx, nv->y + pad * n_ny,
                     kv->x + pad * n_nx, kv->y + pad * n_ny,
                     &ix, &iy);

    P2->verts.push_back(new brush_vert_c(P2, ix, iy));
  }
}


static void AddFatBrush(csg_brush_c *P2)
{
  P2->ComputeBBox();
  P2->Validate();

  all_brushes.push_back(P2);
}


static void AdjustSlope(slope_info_c *slope, double pad_w, bool is_ceil)
{
  double dx = slope->ex - slope->sx;
  double dy = slope->ey - slope->sy;

  double len = sqrt(dx*dx + dy*dy);

  dx = dx * pad_w / len;
  dy = dy * pad_w / len;

  // floor slopes have negative dz, ceilings have positive dz.
  // hence move coordinates BACK by pad_w distance.

  slope->sx -= dx;
  slope->sy -= dy;

  slope->ex -= dx;
  slope->ey -= dy;

  slope->dz *= len / (pad_w + len);
}


static void FattenBrushes(double pad_w, double pad_t, double pad_b)
{
  for (unsigned int i = 0; i < saved_all_brushes.size(); i++)
  {
    csg_brush_c *P = saved_all_brushes[i];

    if (! (P->bkind == BKIND_Solid ||
           P->bkind == BKIND_Clip  ||
           P->bkind == BKIND_Sky))
      continue;

    // clone it, except vertices or slopes
    csg_brush_c *P2 = new csg_brush_c(P);

    P2->bkind = BKIND_Solid;

    P2->b.z -= pad_b;
    P2->t.z += pad_t;

    for (unsigned int k = 0; k < P->verts.size(); k++)
    {
      FattenVertex3(P, k, P2, pad_w);
    }

    // !!!! FIXME: if floor is sloped, split this poly into two halves
    //             at the point where the (slope + fh) exceeds (z2 + fh)
    if (P->t.slope)
    {
      P2->t.slope = new slope_info_c(P->t.slope);

      AdjustSlope(P2->t.slope, pad_w, false);
    }

    // if ceiling is sloped, merely adjust slope to keep it in new bbox
    if (P->b.slope)
    {
      P2->b.slope = new slope_info_c(P->b.slope);

      AdjustSlope(P2->b.slope, pad_w, true);
    }

    AddFatBrush(P2);
  }
}


//------------------------------------------------------------------------

static bool ClipSameGaps(region_c *R, region_c *N)
{
  if (R->gaps.size() != N->gaps.size())
    return false;

  for (unsigned int i = 0 ; i < R->gaps.size() ; i++)
  {
    gap_c *A = R->gaps[i];
    gap_c *B = N->gaps[i];

    if (A->bottom != B->bottom)
    {
      // slopes are deal breakers
      if (A->bottom->t.slope)
        return false;

      if (fabs(A->bottom->t.z - B->bottom->t.z) > 0.01)
        return false;
    }

    if (A->top != B->top)
    {
      if (A->top->b.slope)
        return false;

      if (fabs(A->top->b.z - B->top->b.z) > 0.01)
        return false;
    }
  }

  // for clipping, these two regions are equivalent
  return true;
}


static int SpreadClipEquiv()
{
  int changes = 0;

int sames = 0;
int diffs = 0;

  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c *R = all_regions[i];

    if (R->index == 0)
      continue;

    for (unsigned int k = 0 ; k < R->snags.size() ; k++)
    {
      snag_c *S = R->snags[k];

      region_c *N = S->partner ? S->partner->region : NULL;

      if (! N || N->index == 0)
        continue;

      // use '>' so that we only check the relationship once
      if (N->index > R->index && ClipSameGaps(R, N))
      {
        N->index = R->index;
        changes++;
      }

if (N) {
if (N->index == R->index) sames++; else diffs++; }

    }
  }

// fprintf(stderr, "SpreadClipEquiv:  changes:%d sames:%d diffs:%d\n", changes, sames, diffs);

  return changes;
}


static void CoalesceClipRegions()
{
  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c *R = all_regions[i];

    if (R->gaps.empty())
      R->index = 0;   // all solid regions become ZERO
    else
      R->index = 1 + (int)i;
  }

  while (SpreadClipEquiv() > 0)
  { }
}


static cpSide_c * SplitSideAt(cpSide_c *S, double new_x, double new_y)
{
  cpSide_c *T = new cpSide_c(S);

  S->x2 = T->x1 = new_x;
  S->y2 = T->y1 = new_y;

  return T;
}


#if 0
static double EvaluatePartition(cpNode_c * LEAF,
                                double px1, double py1, double px2, double py2)
{
  double pdx = px2 - px1;
  double pdy = py2 - py1;

  int back   = 0;
  int front  = 0;
  int splits = 0;

  std::vector<cpSide_c *>::iterator SI;

  for (SI = LEAF->sides.begin(); SI != LEAF->sides.end(); SI++)
  {
    cpSide_c *S = *SI;

    // get state of lines' relation to each other
    double a = PerpDist(S->x1, S->y1, px1, py1, px2, py2);
    double b = PerpDist(S->x2, S->y2, px1, py1, px2, py2);

    int a_side = (a < -CLIP_EPSILON) ? -1 : (a > CLIP_EPSILON) ? +1 : 0;
    int b_side = (b < -CLIP_EPSILON) ? -1 : (b > CLIP_EPSILON) ? +1 : 0;

    if (a_side == 0 && b_side == 0)
    {
      // lines are colinear

      double sdx = S->x2 - S->x1;
      double sdy = S->y2 - S->y1;

      if (pdx * sdx + pdy * sdy < 0.0)
        back++;
      else
        front++;

      continue;
    }

    if (a_side >= 0 && b_side >= 0)
    {
      front++;
      continue;
    }

    if (a_side <= 0 && b_side <= 0)
    {
      back++;
      continue;
    }

    // the partition line will split it

    splits++;

    back++;
    front++;
  }


  // always prefer axis-aligned planes
  // (this helps prevent the "sticky doorways" bug)
  bool aligned = (fabs(pdx) < 0.0001 || fabs(pdy) < 0.0001);

  if (front == 0 && back == 0)
    return aligned ? 1e24 : 1e26;

  if (splits > 1000)
    splits = 1000;

  double cost = splits * (splits+1) * 3.65;

  cost += ABS(front - back);
  cost /=    (front + back);

  if (! aligned)
    cost += 1e12;

  return cost;
}
#endif


static void Split_XY(cpGroup_c & group, const cpPartition_c *part,
                     cpGroup_c & front, cpGroup_c & back)
{
  std::vector<cpSide_c *> local_sides;

  local_sides.swap(group.sides);


  for (unsigned int k = 0 ; k < local_sides.size() ; k++)
  {
    cpSide_c *S = local_sides[k];

    // get relationship of this side to the partition line
    double a = PerpDist(S->x1, S->y1,
                        part->x1,part->y1, part->x2,part->y2);

    double b = PerpDist(S->x2, S->y2,
                        part->x1,part->y1, part->x2,part->y2);

    int a_side = (a < -CLIP_EPSILON) ? -1 : (a > CLIP_EPSILON) ? +1 : 0;
    int b_side = (b < -CLIP_EPSILON) ? -1 : (b > CLIP_EPSILON) ? +1 : 0;

    if (a_side == 0 && b_side == 0)
    {
      // side sits on the partition
      S->on_node = true;

      if (VectorSameDir(part->x2 - part->x1, part->y2 - part->y1,
                        S->x2 - S->x1, S->y2 - S->y1))
      {
        front.AddSide(S);
      }
      else
      {
        back.AddSide(S);
      }
      continue;
    }

    if (a_side >= 0 && b_side >= 0)
    {
      front.AddSide(S);
      continue;
    }

    if (a_side <= 0 && b_side <= 0)
    {
      back.AddSide(S);
      continue;
    }

    /* need to split it */

    // determine the intersection point
    double along = a / (a - b);

    double ix = S->x1 + along * (S->x2 - S->x1);
    double iy = S->y1 + along * (S->y2 - S->y1);

    cpSide_c *T = SplitSideAt(S, ix, iy);

    front.AddSide((a > 0) ? S : T);
     back.AddSide((a > 0) ? T : S);
  }
}


static bool FindPartition_XY(cpGroup_c & group, cpPartition_c *part)
{
  cpSide_c *poss = NULL;
  cpSide_c *best = NULL;

  for (unsigned int i = 0 ; i < group.sides.size() ; i++)
  {
    cpSide_c *S = group.sides[i];

    if (S->on_node)
      continue;

    poss = S;

    // MUST choose 2-sided snag BEFORE any 1-sided snag

    if (S->TwoSided())
    {
      best = S; break;  // !!!!! FIXME: decide properly
    }
  }

  if (! poss)
    return false;

  part->Set(best ? best : poss);

  return true;
}


static cpNode_c * Partition_Z(region_c *R)
{
  SYS_ASSERT(R->gaps.size() > 0);

  cpNode_c *node = new cpNode_c(CONTENTS_EMPTY);
  
  for (int surf = (int)R->gaps.size() * 2 - 1 ; surf >= 0 ; surf--)
  {
    gap_c *G = R->gaps[surf / 2];

    bool is_ceil = (surf & 1) ? true : false;

    cpNode_c *last_node = node;

    node = new cpNode_c(G, is_ceil);

    node->front = last_node;
    node->back  = new cpNode_c(CONTENTS_SOLID);

///---  if (is_ceil)
///---    std::swap(node->front, node->back);
  }

  return node;
}


static cpNode_c * PartitionGroup(cpGroup_c & group)
{
  SYS_ASSERT(! group.sides.empty());

  cpPartition_c part;

  if (FindPartition_XY(group, &part))
  {
    // divide the group
    cpGroup_c front;
    cpGroup_c back;

    Split_XY(group, &part, front, back);

    cpNode_c * node = new cpNode_c(part);

    // the front should never be empty
    node->front = PartitionGroup(front);

    if (back.sides.empty())
      node->back = new cpNode_c(CONTENTS_SOLID);
    else
      node->back = PartitionGroup(back);

    // input group has been consumed now 

    return node;
  }
  else
  {
    region_c *region = group.sides[0]->snag->region;

    SYS_ASSERT(region);

    return Partition_Z(region);
  }
}


//------------------------------------------------------------------------

static void AssignIndexes(cpNode_c *node, int *cur_index)
{
  if (! node->IsNode())
    return;

  node->index = *cur_index;

  (*cur_index) += 1;

  AssignIndexes(node->front, cur_index);
  AssignIndexes(node->back,  cur_index);
}


static void DoWriteClip(dclipnode_t & raw_clip, bool flip)
{
  if (flip)
  {
    std::swap(raw_clip.children[0], raw_clip.children[1]);
  }

  // fix endianness
  raw_clip.planenum    = LE_S32(raw_clip.planenum);
  raw_clip.children[0] = LE_U16(raw_clip.children[0]);
  raw_clip.children[1] = LE_U16(raw_clip.children[1]);

  q1_clip->Append(&raw_clip, sizeof(raw_clip));

  q1_total_clip += 1;
}


static void WriteClipNodes(cpNode_c *node)
{
  if (! node->IsNode())
    return;


  dclipnode_t raw_clip;

  bool flipped;

  if (node->part.kind == PKIND_FLAT)
  {
    // !!!! FIXME: support slopes

    raw_clip.planenum = BSP_AddPlane(0, 0, node->part.z,
                                 0, 0, node->part.dz,
                                 &flipped);
  }
  else
  {
    raw_clip.planenum = BSP_AddPlane(node->part.x1, node->part.y1, 0,
                                 node->part.y2 - node->part.y1,
                                 node->part.x1 - node->part.x2, 0,
                                 &flipped);
  }

  node->CheckValid();

  if (node->front->IsNode())
    raw_clip.children[0] = (u16_t) node->front->index;
  else
    raw_clip.children[0] = (u16_t) node->front->contents;

  if (node->back->IsNode())
    raw_clip.children[1] = (u16_t) node->back->index;
  else
    raw_clip.children[1] = (u16_t) node->back->contents;

  
  DoWriteClip(raw_clip, flipped);


  // recurse now, AFTER adding the current node

  WriteClipNodes(node->front);
  WriteClipNodes(node->back);
}


static void CreateClipSides(cpGroup_c & group)
{
  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c *R = all_regions[i];

    if (R->index == 0)
      continue;

    for (unsigned int k = 0 ; k < R->snags.size() ; k++)
    {
      snag_c *S = R->snags[k];

      region_c *N = S->partner ? S->partner->region : NULL;

      if (N && N->index == R->index)
        continue;

      cpSide_c *CS = new cpSide_c(S);

      group.AddSide(CS);
#if 0
fprintf(stderr, "New Side: %p %s (%1.0f %1.0f) .. (%1.0f %1.0f)\n",
        CS, CS->TwoSided() ? "2S" : "1S",
        CS->x1, CS->y1, CS->x2, CS->y2);
#endif
    }
  }
}



static void Q1_ClipWorld(int hull, double *pads)
{
  qk_world_model->nodes[hull] = q1_total_clip;


  SaveBrushes();

  FattenBrushes(pads[0], pads[1], pads[2]);

  CSG_BSP(0.5);

  CoalesceClipRegions();

  
  cpGroup_c GROUP;

  CreateClipSides(GROUP);

  cpNode_c * ROOT = PartitionGroup(GROUP);


  int cur_index = q1_total_clip;

  AssignIndexes(ROOT, &cur_index);

  WriteClipNodes(ROOT);

  // this deletes the entire BSP tree (nodes and leafs)
  delete ROOT;


  RestoreBrushes();
}


static void Q1_ClipMapModel(quake_mapmodel_c *model, int hull,
                            double pad_w, double pad_t, double pad_b)
{
  model->nodes[hull] = q1_total_clip;

  int base = q1_total_clip;

  for (int face = 0 ; face < 6 ; face++)
  {
    dclipnode_t raw_clip;

    double v;
    double dir;
    bool flipped;

    if (face < 2)  // PLANE_X
    {
      v = (face==0) ? (model->x1 - pad_w) : (model->x2 + pad_w);
      dir = (face==0) ? -1 : 1;
      raw_clip.planenum = BSP_AddPlane(v,0,0, dir,0,0, &flipped);
    }
    else if (face < 4)  // PLANE_Y
    {
      v = (face==2) ? (model->y1 - pad_w) : (model->y2 + pad_w);
      dir = (face==2) ? -1 : 1;
      raw_clip.planenum = BSP_AddPlane(0,v,0, 0,dir,0, &flipped);
    }
    else  // PLANE_Z
    {
      v = (face==5) ? (model->z1 - pad_b) : (model->z2 + pad_t);
      dir = (face==5) ? -1 : 1;
      raw_clip.planenum = BSP_AddPlane(0,0,v, 0,0,dir, &flipped);
    }

    raw_clip.children[0] = (u16_t) CONTENTS_EMPTY;
    raw_clip.children[1] = (face == 5) ? CONTENTS_SOLID : base + face + 1;

    DoWriteClip(raw_clip, flipped);
  }
}


void Q1_ClippingHull(int hull)
{
  int clip_hulls = 2;

  if (qk_sub_format == SUBFMT_HalfLife) clip_hulls = 3;
  if (qk_sub_format == SUBFMT_Hexen2)   clip_hulls = 5;

  SYS_ASSERT(hull >= 1);

  if (hull > clip_hulls)
    return;


  DebugPrintf("Q1_ClippingHull %d\n", hull);

  if (main_win)
  {
    char hull_name[32];
    sprintf(hull_name, "Hull %d", hull);
    main_win->build_box->Prog_Step(hull_name);
  }

///???  cpSideFactory_c::FreeAll();


  double *pads;

  if (qk_sub_format == SUBFMT_Hexen2)
    pads = h2_hull_sizes[hull-1];
  else
    pads = hull_sizes[hull-1];


  // first clip the world, then the map-models

  Q1_ClipWorld(hull, pads);

  for (unsigned int m = 0 ; m < qk_all_mapmodels.size() ; m++)
  {
    Q1_ClipMapModel(qk_all_mapmodels[m], hull,
                    pads[0], pads[1], pads[2]);
  }

  if (q1_total_clip >= MAX_MAP_CLIPNODES)
    Main_FatalError("Quake build failure: exceeded limit of %d CLIPNODES\n",
                    MAX_MAP_CLIPNODES);
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
