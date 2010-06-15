//------------------------------------------------------------------------
//  LEVEL building - QUAKE 1 CLIPPING HULLS
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2009 Andrew Apted
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

#include "g_lua.h"

#include "q_bsp.h"
#include "q1_main.h"
#include "q1_structs.h"


extern void  Q1_MapModel_Clip(qLump_c *L, s32_t base,
                      q1MapModel_c *model, int which,
                      double pad_w, double pad_t, double pad_b);

extern void CSG2_Doom_TestBrushes(void);
extern void CSG2_Doom_TestClip(void);


std::vector<csg_brush_c *> saved_all_brushes;


static void SaveBrushes(void)
{
  SYS_ASSERT(all_brushes.size() > 0);
  SYS_ASSERT(saved_all_brushes.empty());

  std::swap(all_brushes, saved_all_brushes);
}

static void RestoreBrushes(void)
{
  // free our modified ones
  for (unsigned int i = 0; i < all_brushes.size(); i++)
  {
    csg_brush_c *P2 = all_brushes[i];

///---    // FIXME DIRTY HACK (copy constructor does not duplicate these)
///---    P2->t_face = NULL;
///---    P2->b_face = NULL;
///---    P2->w_face = NULL;

    delete P2;
  }

  all_brushes.clear();

  std::swap(all_brushes, saved_all_brushes);

  SYS_ASSERT(all_brushes.size() > 0);
  SYS_ASSERT(saved_all_brushes.empty());
}


static void CalcNormal(double x1, double y1, double x2, double y2,
                       double *nx, double *ny)
{
  *nx = (y2 - y1);
  *ny = (x1 - x2);

  double n_len = ComputeDist(x1, y1, x2, y2);
  SYS_ASSERT(n_len > EPSILON);

  *nx /= n_len;
  *ny /= n_len;
}

static void CalcIntersection(double nx1, double ny1, double nx2, double ny2,
                             double px1, double py1, double px2, double py2,
                             double *x, double *y)
{
  // NOTE: lines are extended to infinity to find the intersection

  double a = PerpDist(nx1, ny1,  px1, py1, px2, py2);
  double b = PerpDist(nx2, ny2,  px1, py1, px2, py2);

  // BIG ASSUMPTION: lines are not parallel or colinear
  SYS_ASSERT(fabs(a - b) > EPSILON);

  // determine the intersection point
  double along = a / (a - b);

  *x = nx1 + along * (nx2 - nx1);
  *y = ny1 + along * (ny2 - ny1);
}

static double CalcIntersect_Y(double nx1, double ny1, double nx2, double ny2,
                              double x)
{
    double a = nx1 - x;
    double b = nx2 - x;

    // BIG ASSUMPTION: lines are not parallel or colinear
    SYS_ASSERT(fabs(a - b) > EPSILON);

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
    SYS_ASSERT(fabs(a - b) > EPSILON);

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

  if (fabs(PerpDist(kv->x, kv->y, pv->x, pv->y, nv->x, nv->y)) < 4.0*EPSILON)
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


static void FattenBrushes(double pad_w, double pad_t, double pad_b)
{
  for (unsigned int i = 0; i < saved_all_brushes.size(); i++)
  {
    csg_brush_c *P = saved_all_brushes[i];

    if (! (P->bkind == BKIND_Solid || P->bkind == BKIND_Clip ||
           P->bkind == BKIND_Sky))
      continue;

    csg_brush_c *P2 = new csg_brush_c(P);  // clone it, except vertices

    // !!!! FIXME: if floor is sloped, split this poly into two halves
    //             at the point where the (slope + fh) exceeds (z2 + fh)

    SYS_ASSERT(! P2->t.slope);

    // TODO: if ceiling is sloped, adjust slope to keep it in new bbox
    //       (this is a kludge.  Floors are a lot more important to get
    //        right because players and monsters walk on them).

    SYS_ASSERT(! P2->b.slope);

    P2->b.z -= pad_b;
    P2->t.z += pad_t;

    for (unsigned int k = 0; k < P->verts.size(); k++)
    {
      FattenVertex3(P, k, P2, pad_w);
    }

    P2->ComputeBBox();
    P2->Validate();

    all_brushes.push_back(P2);
  }
}


//------------------------------------------------------------------------

class cpSide_c
{
friend class cpSideFactory_c;

public:
  merge_segment_c *seg;

  double x1, y1;
  double x2, y2;

public:
  cpSide_c(merge_segment_c * _seg = NULL) : seg(_seg)
  { }

  ~cpSide_c()
  { }

public:
  double Length() const
  {
    return ComputeDist(x1,y1, x2,y2);
  }
};


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

  static cpSide_c *SplitAt(cpSide_c *S, double new_x, double new_y)
  {
    cpSide_c *T = RawNew(S->seg);

    T->x1 = new_x; T->y1 = new_y;
    T->x2 = S->x2; T->y2 = S->y2;

    S->x2 = new_x; S->y2 = new_y;

    return T;
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

std::list<cpSide_c> cpSideFactory_c::all_sides;


#define CONTENT__NODE  12345


class cpNode_c
{
public:
  /* LEAF STUFF */

  int lf_contents;

  std::vector<cpSide_c *> sides;

  merge_region_c *region;


  /* NODE STUFF */

  // true if this node splits the tree by Z
  // (with a horizontal upward-facing plane, i.e. dz = 1).
  bool z_splitter;

  double z;

  // normal splitting planes are vertical, and here are the
  // coordinates on the map.
  double x,  y;
  double dx, dy;

  cpNode_c *front;  // front space
  cpNode_c *back;   // back space

  int index;

public:
  // LEAF
  cpNode_c() : lf_contents(CONTENTS_EMPTY), sides(), region(NULL),
               front(NULL), back(NULL), index(-1)
  { }

  cpNode_c(bool _Zsplit) : lf_contents(CONTENT__NODE), sides(), region(NULL),
                          z_splitter(_Zsplit), z(0),
                          x(0), y(0), dx(0), dy(0),
                          front(NULL), back(NULL),
                          index(-1)
  { }

  ~cpNode_c()
  {
    if (front) delete front;
    if (back)  delete back;
  }

  inline bool IsNode()  const { return lf_contents == CONTENT__NODE; }
  inline bool IsLeaf()  const { return lf_contents != CONTENT__NODE; }
  inline bool IsSolid() const { return lf_contents == CONTENTS_SOLID; }

  void AddSide(cpSide_c *S)
  {
    sides.push_back(S);
  }

  void CheckValid() const
  {
    SYS_ASSERT(index >= 0);
  }

  void CalcBounds(double *lx, double *ly, double *w, double *h) const
  {
    SYS_ASSERT(lf_contents != CONTENT__NODE);

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
};


static cpNode_c * MakeLeaf(int contents)
{
  cpNode_c *leaf = new cpNode_c();

  leaf->lf_contents = contents;

  return leaf;
}


// area number is:
//    0 for below the lowest floor,
//    1 for the first gap
//    2 for above the first gap
//    3 for the second gap
//    etc etc...

static cpNode_c * DoPartitionZ(merge_region_c *R,
                              int min_area, int max_area)
{
  SYS_ASSERT(min_area <= max_area);

  if (min_area == max_area)
  {
    if ((min_area & 1) == 0)
      return MakeLeaf(CONTENTS_SOLID);
    else
      return MakeLeaf(CONTENTS_EMPTY);
  }


  {
    cpNode_c *node = new cpNode_c(true /* z_splitter */);

    int a1 = (min_area + max_area) / 2;
    int a2 = a1 + 1;

    int g = a1 / 2;
    SYS_ASSERT(g < (int)R->gaps.size());

    if ((a1 & 1) == 0)
      node->z = R->gaps[g]->GetZ1();
    else
      node->z = R->gaps[g]->GetZ2();

    node->back  = DoPartitionZ(R, min_area, a1);
    node->front = DoPartitionZ(R, a2, max_area);

    return node;
  }
}


static cpNode_c * Partition_Z(merge_region_c *R)
{
  SYS_ASSERT(R->gaps.size() > 0);

  return DoPartitionZ(R, 0, (int)R->gaps.size() * 2);
}


//------------------------------------------------------------------------

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

    int a_side = (a < -Q_EPSILON) ? -1 : (a > Q_EPSILON) ? +1 : 0;
    int b_side = (b < -Q_EPSILON) ? -1 : (b > Q_EPSILON) ? +1 : 0;

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


static void Split_XY(cpNode_c *part, cpNode_c *FRONT, cpNode_c *BACK)
{
  std::vector<cpSide_c *> all_sides;

  all_sides.swap(FRONT->sides);

  FRONT->region = NULL;


  for (int k = 0; k < (int)all_sides.size(); k++)
  {
    cpSide_c *S = all_sides[k];

    double sdx = S->x2 - S->x1;
    double sdy = S->y2 - S->y1;

    // get state of lines' relation to each other
    double a = PerpDist(S->x1, S->y1,
                        part->x, part->y,
                        part->x + part->dx, part->y + part->dy);

    double b = PerpDist(S->x2, S->y2,
                        part->x, part->y,
                        part->x + part->dx, part->y + part->dy);

    int a_side = (a < -Q_EPSILON) ? -1 : (a > Q_EPSILON) ? +1 : 0;
    int b_side = (b < -Q_EPSILON) ? -1 : (b > Q_EPSILON) ? +1 : 0;

    if (a_side == 0 && b_side == 0)
    {
      // side sits on the partition : DROP IT
      continue;
    }

    if (a_side >= 0 && b_side >= 0)
    {
      FRONT->AddSide(S);
      continue;
    }

    if (a_side <= 0 && b_side <= 0)
    {
      BACK->AddSide(S);
      continue;
    }

    /* need to split it */

    // determine the intersection point
    double along = a / (a - b);

    double ix = S->x1 + along * sdx;
    double iy = S->y1 + along * sdy;

    cpSide_c *T = cpSideFactory_c::SplitAt(S, ix, iy);

    if (a < 0)
    {
       BACK->AddSide(S);
      FRONT->AddSide(T);
    }
    else
    {
      SYS_ASSERT(b < 0);

      FRONT->AddSide(S);
       BACK->AddSide(T);
    }
  }
}


static cpSide_c * FindPartition(cpNode_c * LEAF)
{
  if (LEAF->sides.size() == 0)
    return NULL;

  if (LEAF->sides.size() == 1)
    return LEAF->sides[0];

  // speed up large maps
  if (LEAF->sides.size() > 8)
  {
    double lx, ly, w, h;
    LEAF->CalcBounds(&lx, &ly, &w, &h);

    if (MAX(w, h) > 400)
    {
			if (w >= h)
        return cpSideFactory_c::FakePartition(BSP_NiceMidwayPoint(lx, w), 0, 0, 1);
      else
        return cpSideFactory_c::FakePartition(0, BSP_NiceMidwayPoint(ly, h), 1, 0);
    }
  }

  double    best_c = 1e30;
  cpSide_c *best_p = NULL;

  std::vector<cpSide_c *>::iterator SI;

  for (SI = LEAF->sides.begin(); SI != LEAF->sides.end(); SI++)
  {
    cpSide_c *part = *SI;

    double cost = EvaluatePartition(LEAF, part->x1, part->y1, part->x2, part->y2);

    if (! best_p || cost < best_c)
    {
      best_c = cost;
      best_p = part;
    }
  }
// fprintf(stderr, "FIND DONE : best_c=%1.0f best_p=%p\n",
//         best_p ? best_c : -9999, best_p);

  return best_p;
}


static cpNode_c * XY_SegSide(merge_segment_c *SEG, int side)
{
  SYS_ASSERT(SEG);

  merge_region_c *region = (side == 0) ? SEG->front : SEG->back;

  if (!region || region->gaps.size() == 0)
    return MakeLeaf(CONTENTS_SOLID);

  return Partition_Z(region);
}


static cpNode_c * Partition_XY(cpNode_c * LEAF)
{
  cpSide_c *part = FindPartition(LEAF);
  SYS_ASSERT(part);

  cpNode_c *node = new cpNode_c(false /* z_splitter */);

  node->x = part->x1;
  node->y = part->y1;

  node->dx = part->x2 - node->x;
  node->dy = part->y2 - node->y;

// fprintf(stderr, "PARTITION_XY = (%1.0f,%1.0f) to (%1.2f,%1.2f)\n",
//                  node->x, node->y, node->x + node->dx, node->y + node->dy);

  cpNode_c * BACK = new cpNode_c();

  Split_XY(node, LEAF, BACK);

  if (LEAF->sides.size() == 0)
    node->front = XY_SegSide(part->seg, 0);
  else
    node->front = Partition_XY(LEAF);

  if (BACK->sides.size() == 0)
    node->back = XY_SegSide(part->seg, 1);
  else
    node->back = Partition_XY(BACK);

  return node;
}


static bool SameGaps(merge_segment_c *S)
{
  bool no_front = (! S->front || S->front->gaps.size() == 0);
  bool no_back  = (! S->back  || S->back ->gaps.size() == 0);

  if (no_front && no_back)
    return true;

  if (no_front || no_back)
    return false;

  if (S->front->gaps.size() != S->back->gaps.size())
    return false;

  // FIXME: check if any gaps actually touch

  for (unsigned k = 0; k < S->front->gaps.size(); k++)
  {
    merge_gap_c *fg = S->front->gaps[k];
    merge_gap_c *bg = S-> back->gaps[k];

    // FIXME: take slopes into account!

    if (fabs(fg->GetZ1() - bg->GetZ1()) > EPSILON)
      return false;

    if (fabs(fg->GetZ2() - bg->GetZ2()) > EPSILON)
      return false;
  }

  // for clipping, this seg can be ignored
  return true;
}


//------------------------------------------------------------------------

static void AssignIndexes(cpNode_c *node, int *idx_var)
{
  node->index = *idx_var;

  (*idx_var) += 1;

  if (node->front->IsNode())
    AssignIndexes(node->front, idx_var);

  if (node->back->IsNode())
    AssignIndexes(node->back, idx_var);
}


static void WriteClipNodes(qLump_c *L, cpNode_c *node)
{
  dclipnode_t clip;

  bool flipped;

  if (node->z_splitter)
    clip.planenum = BSP_AddPlane(0, 0, node->z, 0, 0, 1, &flipped);
  else
    clip.planenum = BSP_AddPlane(node->x, node->y, 0,
                                 node->dy, -node->dx, 0, &flipped);

  node->CheckValid();

  if (node->front->IsNode())
    clip.children[0] = (u16_t) node->front->index;
  else
    clip.children[0] = (u16_t) node->front->lf_contents;

  if (node->back->IsNode())
    clip.children[1] = (u16_t) node->back->index;
  else
    clip.children[1] = (u16_t) node->back->lf_contents;

  if (flipped)
  {
    u16_t tmp = clip.children[0];
    clip.children[0] = clip.children[1];
    clip.children[1] = tmp;
  }


  // TODO: fix endianness in 'clip'

  L->Append(&clip, sizeof(clip));


  // recurse now, AFTER adding the current node

  if (node->front->IsNode())
    WriteClipNodes(L, node->front);

  if (node->back->IsNode())
    WriteClipNodes(L, node->back);
}


s32_t Q1_CreateClipHull(int which, qLump_c *q1_clip)
{
  SYS_ASSERT(1 <= which && which <= 3);

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

  cpSideFactory_c::FreeAll();

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

  CSG2_FreeMerges();
  CSG2_MergeAreas(true /* do_clips */);

//  if (which == 0)
//    CSG2_Doom_TestClip();

  cpNode_c *C_LEAF = new cpNode_c();

  for (unsigned int i = 0; i < mug_segments.size(); i++)
  {
    merge_segment_c *S = mug_segments[i];

    if (! SameGaps(S))
    {
      C_LEAF->AddSide(cpSideFactory_c::NewSide(S)); 
    }
  }


  cpNode_c *C_ROOT = Partition_XY(C_LEAF);

  SYS_ASSERT(C_ROOT->IsNode());


  int start_idx = q1_clip->GetSize() / sizeof(dclipnode_t);
  int cur_index = start_idx;

  AssignIndexes(C_ROOT, &cur_index);

  WriteClipNodes(q1_clip, C_ROOT);

  // this deletes the entire BSP tree (nodes and leafs)
  delete C_ROOT;

  RestoreBrushes();


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

  return start_idx;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
