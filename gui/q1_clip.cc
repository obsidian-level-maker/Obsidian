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

#include "csg_main.h"
#include "csg_local.h"

#include "g_lua.h"

#include "q_bsp.h"
#include "q1_main.h"
#include "q1_structs.h"


#define CLIP_EPSILON  0.01


extern void  Q1_MapModel_Clip(qLump_c *L, s32_t base,
                      q1MapModel_c *model, int which,
                      double pad_w, double pad_t, double pad_b);

extern void CSG2_Doom_TestBrushes(void);
extern void CSG2_Doom_TestClip(void);


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
      snag(other->snag), on_node(false),
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

    if (! snag->partner->where)
      return false;

    if (snag->partner->where->equiv_id == 0)
      return false;

    return true;
  }
};


class cpFlat_c
{
public:
  gap_c *gap;

  bool on_node;

  double z, dz;

public:
  cpFlat_c(gap_c *G, bool _ceil) : gap(G), on_node(false),
  {
    z  = _ceil ? gap->top->b.z : gap->bottom->t.z;
    dz = _ceil ? -1 : 1;
  }

  ~cpFlat_c()
  { }
};


typedef enum
{
  PKIND_SIDE = 0,
  PKIND_FLAT = 1
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


#if 0
class cpSideFactory_c
{
  static std::list<cpSide_c> all_sides;

  static cpSide_c *RawNew(merge_segment_c *seg)
  {
    all_sides.push_back(cpSide_c(seg));
    return &all_sides.back();
  }

public:
  static cpSide_c *NewSide(merge_segment_c *seg)
  {
    cpSide_c *S = RawNew(seg);

    S->x1 = seg->start->x;  S->x2 = seg->end->x;
    S->y1 = seg->start->y;  S->y2 = seg->end->y;

    return S;
  }


  static cpSide_c *FakePartition(double x, double y, double dx, double dy)
  {
    cpSide_c * S = RawNew(NULL);

    S->x1 = x;  S->x2 = x+dx;
    S->y1 = y;  S->y2 = y+dy;

    return S;
  }

  static void FreeAll()
  {
    all_sides.clear();
  }
};
#endif


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

//--  cpNode_c(bool _Zsplit) :
//--        contents(CONTENT__NODE), sides(), region(NULL),
//--        z_splitter(_Zsplit), z(0),
//--        x(0), y(0), dx(0), dy(0),
//--        front(NULL), back(NULL),
//--        index(-1)
//--  { }

  ~cpNode_c()
  {
    if (front) delete front;
    if (back)  delete back;
  }

  inline bool IsNode()  const { return contents == CONTENT__NODE; }
  inline bool IsLeaf()  const { return contents != CONTENT__NODE; }
  inline bool IsSolid() const { return contents == CONTENTS_SOLID; }

  bool IsEmpty() const
  {
    return sides.empty() && flats.empty();
  }

  void AddSide(cpSide_c *S)
  {
    sides.push_back(S);

    region = S->snag->where;
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

  void MakeNode(const cpPartition_c *part)
  {
    contents = CONTENT__NODE;

    part.Set(part);

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

  void CheckSameRegion()
  {
    if (region)
      return;

    SYS_ASSERT(sides.size() > 0);

    region_c *reg = sides[0]->snag->where;
    SYS_ASSERT(reg);

    for (unsigned int i = 1 ; i < sides.size() ; i++)
    {
      cpSide_c *S = sides[i];

      if (S->snag->where != reg)
        return;  // nope
    }

    // yes!

    region = reg;

    CreateFlats();
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

#if 0
  if ((slope->dz > 0) == is_ceil)
  {
    slope->sx -= dx;
    slope->sy -= dy;
  }
  else
  {
    slope->ex += dx;
    slope->ey += dy;
  }
#else
  slope->sx -= dx / 1;
  slope->sy -= dy / 1;

  slope->ex += dx / 1;
  slope->ey += dy / 1;
#endif
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


static void SpreadClipEquiv()
{
  int changes = 0;

int sames = 0;
int diffs = 0;

  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c *R = all_regions[i];

    if (R->equiv_id == 0)
      continue;

    for (unsigned int k = 0 ; k < R->snags.size() ; k++)
    {
      snag_c *S = R->snags[k];

      region_c *N = S->partner ? S->partner->where : NULL;

      if (! N || N->equiv_id == 0)
        continue;

      // use '>' so that we only check the relationship once
      if (N->equiv_id > R->equiv_id && ClipSameGaps(R, N))
      {
        N->equiv_id = R->equiv_id;
        changes++;
      }

if (N) {
if (N->equiv_id == R->equiv_id) sames++; else diffs++; }

    }
  }

fprintf(stderr, "SpreadClipEquiv:  changes:%d sames:%d diffs:%d\n", changes, sames, diffs);

  return changes;
}


static void CoalesceClipRegions()
{
  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c *R = all_regions[i];

    if (R->gaps.empty())
      R->equiv_id = 0;   // all solid regions become ZERO
    else
      R->equiv_id = 1 + (int)i;
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


static void Split_XY(cpNode_c *leaf, const cpPartition_c *part,
                     cpNode_c *front, cpNode_c *back)
{
  std::vector<cpSide_c *> local_sides;

  local_sides.swap(leaf->sides);


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
      // side sits on the partition : DROP IT
      continue;
    }

    if (a_side >= 0 && b_side >= 0)
    {
      front->AddSide(S);
      continue;
    }

    if (a_side <= 0 && b_side <= 0)
    {
      back->AddSide(S);
      continue;
    }

    /* need to split it */

    // determine the intersection point
    double along = a / (a - b);

    double ix = S->x1 + along * (S->x2 - S->x1);
    double iy = S->y1 + along * (S->y2 - S->y1);

    cpSide_c *T = SplitSideAt(S, ix, iy);

    front->AddSide((a > 0) ? S : T);
     back->AddSide((a > 0) ? T : S);
  }
}


static void Split_Z(cpNode_c *leaf, const cpPartition_c *part,
                    cpNode_c *front, cpNode_c *back)
{
  std::vector<cpFlat_c *> local_flats;

  local_flats.swap(leaf->flats);


  for (unsigned int k = 0 ; k < local_flats.size() ; k++)
  {
    cpFlat_c *F = local_flats[k];

    if (fabs(F->z - part->z) < CLIP_EPSILON)
    {
      // flat sits on the partition : DROP IT
      continue;
    }

    if ((F->z < part->z) == (part_z < 0))
      front->AddFlat(F);
    else
      back->AddFlat(F);
  }

  front->CopySides(leaf);
   back->CopySides(leaf);

  leaf->sides.clear();
}


static bool SplitLeaf(cpNode_c *leaf, const cpPartition_c *part,
                      cpNode_c *front, cpNode_c *back)
{
  if (part->kind == PKIND_SIDE)
    Split_XY(leaf, part, front, back);
  else
    Split_Z(leaf, part, front, back);
    
  if (front->IsEmpty())
    front->contents = CONTENTS_EMPTY;

  if (back->IsEmpty())
    back->contents = CONTENTS_SOLID;
}


static bool FindPartition_XY(cpNode_c *leaf, cpPartition_c *part)
{
  if (leaf->sides.empty())
    return false;

  cpSide_c *best = NULL;

  for (unsigned int i = 0 ; i < leaf->sides.size() ; i++)
  {
    cpSide_c *S = leaf->sides[i];

    // MUST choose 2-sided snag BEFORE any 1-sided snag

    if (S->TwoSided())
    {
      best = S; break;  // !!!!! FIXME: decide properly
    }
  }

  part->Set(best ? best : leaf->sides[0]);

  return true;
}


static bool FindPartition_Z(cpNode_c *leaf, cpPartition_c *part)
{
  if (leaf->flats.empty())
    return false;

  int choice = ((int)leaf->flats.size() - 1) / 2;

  part->Set(leaf->flats[choice]);

  return true;
}


static bool FindPartition(cpNode_c *leaf, cpPartition_c *part)
{
  if (! leaf->flats.empty())
    return FindPartition_Z(leaf, part);
  else
    return FindPartition_XY(leaf, part);
}


static cpNode_c * PartitionLeaf(cpNode_c *leaf)
{
  leaf->CheckSameRegion();

  cpPartition_c part;

  if (FindPartition(leaf, &part))
  {
    cpNode_c *front = new cpNode_c();
    cpNode_c *back  = new cpNode_c();

    SplitLeaf(leaf, &part, front, back);

    leaf->MakeNode(&part);

    leaf->front = PartitionLeaf(front);
    leaf->back  = PartitionLeaf(back);
  }

  return leaf;
}


//------------------------------------------------------------------------

static void AssignIndexes(cpNode_c *node, int *cur_index)
{
  if (! node->IsNode())
    return;

  node->index = *cur_index;

  (*cur_index) += 1;

  AssignIndexes(node->front, idx_var);
  AssignIndexes(node->back,  idx_var);
}


static void WriteClipNodes(cpNode_c *node, qLump_c *lump)
{
  if (! node->IsNode())
    return;


  dclipnode_t clip;

  bool flipped;

  if (node->part.kind == PKIND_FLAT)
  {
    clip.planenum = BSP_AddPlane(0, 0, node->part.z,
                                 0, 0, node->part.dz,
                                 &flipped);
  }
  else
  {
    clip.planenum = BSP_AddPlane(node->part.x1, node->part.y1, 0,
                                 node->part.y2 - node->part.y1,
                                 node->part.x1 - node->part.x2, 0,
                                 &flipped);
  }

  node->CheckValid();

  if (node->front->IsNode())
    clip.children[0] = (u16_t) node->front->index;
  else
    clip.children[0] = (u16_t) node->front->contents;

  if (node->back->IsNode())
    clip.children[1] = (u16_t) node->back->index;
  else
    clip.children[1] = (u16_t) node->back->contents;

  if (flipped)
  {
    std::swap(clip.children[0], clip.children[1]);
  }


  // fix endianness
  clip.planenum    = LE_S32(clip.planenum);
  clip.children[0] = LE_U16(clip.children[0]);
  clip.children[1] = LE_U16(clip.children[1]);

  lump->Append(&clip, sizeof(clip));


  // recurse now, AFTER adding the current node

  WriteClipNodes(node->front, lump);
  WriteClipNodes(node->back,  lump);
}


static cpNode_c * CreateClipSides()
{
  cpNode_c * leaf = new cpNode_c();

  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c *R = all_regions[i];

    if (R->equiv_id == 0)
      continue;

    for (unsigned int k = 0 ; k < R->snags.size() ; k++)
    {
      snag_c *S = R->snags[k];

      region_c *N = S->partner ? S->partner->where : NULL;

      if (N && N->equiv_id == R->equiv_id)
        continue;

      leaf->NewSide(S);
    }
  }

  return leaf;
}


s32_t Q1_CreateClipHull(int which, qLump_c *q1_clip)
{
  SYS_ASSERT(1 <= which && which <= 3);

  cpSideFactory_c::FreeAll();

  // 3rd hull is not used in Quake
  if (which == 3)
    return 0;

  if (main_win)
  {
    char hull_name[32];
    sprintf(hull_name, "Hull %d", which);
    main_win->build_box->Prog_Step(hull_name);
  }

// fprintf(stderr, "Quake1_CreateClipHull %d\n", which);

  which--;


  static double pads[2][3] =
  {
    { 16, 24, 32 },
    { 32, 24, 64 },
  };

  SaveBrushes();

  FattenBrushes(pads[which][0], pads[which][1], pads[which][2]);


//  if (which == 0)
//   CSG2_Doom_TestBrushes();

  CSG_BSP(0.5);

  CSG_SwallowBrushes();
  CSG_DiscoverGaps();

  CoalesceClipRegions();

  
//  if (which == 0)
//    CSG2_Doom_TestClip();



  cpNode_c *LEAF = CreateClipSides(LEAF);

  cpNode_c *ROOT = PartitionLeaf(LEAF);


  int start_idx = q1_clip->GetSize() / sizeof(dclipnode_t);
  int cur_index = start_idx;

  AssignIndexes(ROOT, &cur_index);

  WriteClipNodes(ROOT, q1_clip);

  // this deletes the entire BSP tree (nodes and leafs)
  delete ROOT;


  // write clip nodes for each MapModel
  for (unsigned int mm=0; mm < q1_all_mapmodels.size(); mm++)
  {
    Q1_MapModel_Clip(q1_clip, cur_index,
                     q1_all_mapmodels[mm], which+1,
                     pads[which][0], pads[which][1], pads[which][2]);

    cur_index += 6;
  }

  if (cur_index >= MAX_MAP_CLIPNODES)
    Main_FatalError("Quake1 build failure: exceeded limit of %d CLIPNODES\n",
                    MAX_MAP_CLIPNODES);


  RestoreBrushes();

  return start_idx;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
