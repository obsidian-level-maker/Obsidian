//------------------------------------------------------------------------
//  LEVEL building - QUAKE 1 BSP
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


#define FACE_MAX_SIZE  240


extern bool CSG2_PointInSolid(double x, double y);

extern void Q1_CreateSubModels(qLump_c *L, int first_face, int first_leaf);


class rSide_c;
class rNode_c;


static rNode_c *R_ROOT;

static rNode_c *SOLID_LEAF;

static dmodel_t model;

qLump_c *q1_nodes;
qLump_c *q1_leafs;
qLump_c *q1_faces;

static qLump_c *q_mark_surfs;
static qLump_c *q_surf_edges;
static qLump_c *q_clip_nodes;

int q1_total_nodes;
int q1_total_leafs;
int q1_total_mark_surfs;
int q1_total_surf_edges;


static std::vector<rNode_c *> all_windings;

static std::vector<rNode_c *> z_leafs;


#if 0

static void OLD_SplitDiagonalSides(qLeaf_c *L)
{
  // leafs are already split to be small than 240 units in width
  // and height.  If diagonal sides (the faces on them) are texture
  // mapped by an axis aligned plane, then we don't need to split
  // them.  Otherwise it is possible that the side is too long and
  // must be split.

  std::list<qSide_c *> new_bits;

  std::list<qSide_c *>::iterator SI;

  for (SI = L->sides.begin(); SI != L->sides.end(); SI++)
  {
    qSide_c *S = *SI;

    if (S->Length() > FACE_MAX_SIZE)
    {
// fprintf(stderr, "Splitting DIAGONAL side %p length:%1.0f\n", S, S->Length());

      double ix = (S->x1 + S->x2) / 2.0;
      double iy = (S->y1 + S->y2) / 2.0;

      qSide_c *T = S->SplitAt(ix, iy);

      new_bits.push_back(T);
    }
  }

  while (! new_bits.empty())
  {
    L->sides.push_back(new_bits.back());

    new_bits.pop_back();
  }
}

#endif



class rFace_c
{
public:
  enum
  {
    WALL  = 0,
    FLOOR = 1,
    CEIL  = 2
  };

  int kind;

  int index;

public:
  rFace_c() : index(-1)
  { }
};
#if 0

// for WALL faces, the x and y coordinates are not stored in the
// face itself, but come from the rSide_c which contains the face.

class rFace_c
{
friend class rFaceFactory_c;

public:
  enum
  {
    WALL  = 0,
    FLOOR = 1,
    CEIL  = 2
  };

  int kind;
  int gap;

  double z1, z2;

  area_vert_c *area_v;  // for texture (etc)

public:
  rFace_c(int _kind = WALL) : kind(_kind), area_v(NULL)
  { }

  ~rFace_c()
  { }
};


class rFaceFactory_c
{
  static std::list<rFace_c> all_faces;

public:
  static rFace_c *NewFace(int kind)
  {
    all_faces.push_back(rFace_c(kind));

    rFace_c *F = &all_faces.back();

    return F;
  }

  static rFace_c *NewFace(int kind, int gap, double z1, double z2,
                          area_vert_c *av)
  {
    rFace_c *F = NewFace(kind);

    F->gap = gap;
    F->z1  = z1;
    F->z2  = z2;
    F->area_v = av;

    return F;
  }

  static rFace_c *CopyFace(const rFace_c *other)
  {
    rFace_c *F = NewFace(other->kind);

    F->gap = other->gap;
    F->z1  = other->z1;
    F->z2  = other->z2;
    F->area_v = other->area_v;

    return F;
  }

  static void FreeAll()
  {
    all_faces.clear();
  }
};

#endif


class rSide_c
{
friend class rSideFactory_c;

public:
  merge_segment_c *seg;

  int side;  // side on the seg: 0 = front/right, 1 = back/left

  rSide_c *partner;
  rNode_c *node;

  double x1, y1;
  double x2, y2;

  rNode_c *on_partition;

  std::vector<rFace_c *> faces;

public:
  rSide_c(merge_segment_c * _seg = NULL, int _side = 0) :
      seg(_seg), side(_side), partner(NULL), node(NULL),
      on_partition(NULL), faces()
  { }

  ~rSide_c()
  { }

public:
  bool Usable() const
  {
    return (seg && ! on_partition);
  }

  double Length() const
  {
    return ComputeDist(x1,y1, x2,y2);
  }

  merge_region_c *FrontRegion() const
  {
    if (! seg) return NULL;
    return side ? seg->back : seg->front;
  }

  merge_region_c *BackRegion() const
  {
    if (! seg) return NULL;
    return side ? seg->front : seg->back;
  }

  void AddFace(int kind, int gap, double z1, double z2, area_vert_c *av)
  {
///    rFace_c *F = rFaceFactory_c::NewFace(kind, gap, z1, z2, av);
///
///    faces.push_back(F);
  }
};


class rSideFactory_c
{
  static std::list<rSide_c> all_sides;

  static rSide_c *RawNew(merge_segment_c *seg, int side)
  {
    all_sides.push_back(rSide_c(seg, side));
    return &all_sides.back();
  }

public:
  static rSide_c *NewSide(merge_segment_c *seg, int side)
  {
    rSide_c *S = RawNew(seg, side);

    if (side == 0)
    {
      S->x1 = seg->start->x;  S->x2 = seg->end->x;
      S->y1 = seg->start->y;  S->y2 = seg->end->y;
    }
    else
    {
      S->x1 = seg->end->x;  S->x2 = seg->start->x;
      S->y1 = seg->end->y;  S->y2 = seg->start->y;
    }

    return S;
  }

  static rSide_c *NewPortal(double px, double py, double pdx, double pdy,
                            double start, double end)
  {
    rSide_c *P = RawNew(NULL, 0);

    double p_len = ComputeDist(0, 0, pdx, pdy);

    P->x1 = px + pdx * start / p_len;
    P->y1 = py + pdy * start / p_len;

    P->x2 = px + pdx * end / p_len;
    P->y2 = py + pdy * end / p_len;

    return P;
  }

  static rSide_c *SplitAt(rSide_c *S, double new_x, double new_y);

  static rSide_c *FakePartition(double x, double y, double dx, double dy)
  {
    rSide_c * S = RawNew(NULL, 0);

    S->x1 = x;
    S->y1 = y;

    S->x2 = x+dx;
    S->y2 = y+dy;

    return S;
  }

  static void FreeAll()
  {
    all_sides.clear();
  }
};


std::list<rSide_c> rSideFactory_c::all_sides;
/// std::list<rFace_c> rFaceFactory_c::all_faces;


#define CONTENT__NODE  12345


class rNode_c
{
public:
  /* LEAF STUFF */

  int lf_contents;

  std::vector<rSide_c *> sides;

  // this node just contains a list of sides which will be used
  // to construct the floor and ceiling faces.
  rNode_c * winding;

  merge_region_c *region;

  int gap;


  /* NODE STUFF */

  // if this node splits the tree by Z
  int z_splitter;

  double z; int dz;

  // normal splitting planes are vertical, and here are the
  // coordinates on the map.
  double x,  y;
  double dx, dy;

  rNode_c *front;  // front space
  rNode_c *back;   // back space


  /* COMMON STUFF */

  std::vector<rFace_c *> faces;

  int index;

  double mins[3];
  double maxs[3];

public:
  // LEAF
  rNode_c() : lf_contents(CONTENTS_EMPTY), sides(),
              winding(NULL), region(NULL),
              front(NULL), back(NULL), faces(), index(-1)
  { }

  rNode_c(bool  _Zsplit) : lf_contents(CONTENT__NODE), sides(),
                          winding(NULL), region(NULL),
                          z_splitter(_Zsplit), z(0), dz(_Zsplit ? 1 : 0),
                          x(0), y(0), dx(0), dy(0),
                          front(NULL), back(NULL), faces(),
                          index(-1)
  { }

  ~rNode_c()
  {
    if (front && front != SOLID_LEAF) delete front;
    if (back  && back  != SOLID_LEAF) delete back;
  }

  inline bool IsNode()  const { return lf_contents == CONTENT__NODE; }
  inline bool IsLeaf()  const { return lf_contents != CONTENT__NODE; }
  inline bool IsSolid() const { return lf_contents == CONTENTS_SOLID; }

  void AddSide(rSide_c *S)
  {
    S->node = this;

    sides.push_back(S);
  }

  void AddFace(rFace_c *F)
  {
    faces.push_back(F);
  }

  int UsableSides() const
  {
    int count = 0;

    for (unsigned int i = 0; i < sides.size(); i++)
      if (sides[i]->Usable())
        count++;

    return count;
  }

  void CheckValid() const
  {
    SYS_ASSERT(index >= 0);
  }

  void BecomeNode(double x1, double y1, double x2, double y2)
  {
    lf_contents = CONTENT__NODE;

    z_splitter = false;

    x = x1; dx = x2 - x1;
    y = y1; dy = y2 - y1;
  }

  void CalcBounds(double *lx, double *ly, double *w, double *h) const
  {
    SYS_ASSERT(lf_contents != CONTENT__NODE);

    double hx = -99999; *lx = +99999;
    double hy = -99999; *ly = +99999;

    for (unsigned int i = 0; i < sides.size(); i++)
    {
      rSide_c *S = sides[i];

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


rSide_c *rSideFactory_c::SplitAt(rSide_c *S, double new_x, double new_y)
{
  rSide_c *T = RawNew(S->seg, S->side);

  T->x2 = S->x2; T->y2 = S->y2;
  T->x1 = new_x; T->y1 = new_y;
  S->x2 = new_x; S->y2 = new_y;

  T->node = S->node;
  T->on_partition = S->on_partition;

///---    // copy faces
///---    for (unsigned int i = 0; i < S->faces.size(); i++)
///---      T->AddFace(rFaceFactory::CopyFace(S->faces[i]));

  // howdy partners!
  if (S->partner)
  {
    rSide_c *SP = S->partner;
    rSide_c *TP = RawNew(SP->seg, SP->side);

    SYS_ASSERT(SP->node);
    SYS_ASSERT(SP->side != S->side);

    TP->x1 = SP->x1; TP->y1 = SP->y1;
    TP->x2 = new_x;  TP->y2 = new_y;
    SP->x1 = new_x;  SP->y1 = new_y;

    TP->node = SP->node;
    TP->on_partition = SP->on_partition;

    // establish partner relationship (S <-> SP remains OK)
     T->partner = TP;
    TP->partner = T;

    // insert new partner into its containing node
    TP->node->AddSide(TP);
  }

  return T;
}


static rSide_c * CreateSide(rNode_c *LEAF, merge_segment_c *seg, int side)
{
  rSide_c *S = rSideFactory_c::NewSide(seg, side);

  LEAF->AddSide(S);

  return S;
}

static rNode_c * NewLeaf(int contents)
{
  rNode_c *leaf = new rNode_c();

  leaf->lf_contents = contents;

  return leaf;
}



///---static void GrabFaces(rNode_c *part, rSide_c *S, rNode_c *FRONT, rNode_c *BACK)
///---{
///---
///---  int p_side = (a >= 0) ? 0 : 1;
///---
///---  for (unsigned int i = 0; i < S->faces.size(); i++)
///---  {
///---    rFace_c *F = S->faces[i];
///---
///---    part->faces.push_back(F);
///---
///---    if (p_side == S->side)
///---      FRONT->faces.push_back(F);
///---    else
///---      BACK->faces.push_back(F);
///---  }
///---}


static void CreatePortals(rNode_c *part, rNode_c *FRONT, rNode_c *BACK,
                          std::vector<intersect_t> & cut_list)
{
  for (unsigned int i = 0; i < cut_list.size(); i++)
  {
    double along1 = cut_list[i].along;
    double along2 = cut_list[i].next_along;

#if 0
    // check if portal crosses solid space
    // (NOTE: this is hackish!)
    double mx = (K1->x + K2->x) / 2.0;
    double my = (K1->y + K2->y) / 2.0;

    assert (! CSG2_PointInSolid(mx, my));
#endif

    rSide_c *F = rSideFactory_c::NewPortal(part->x, part->y, part->dx, part->dy, along1, along2);
    rSide_c *B = rSideFactory_c::NewPortal(part->x, part->y, part->dx, part->dy, along2, along1);

    F->partner = B;
    B->partner = F;

    FRONT->AddSide(F);
     BACK->AddSide(B);
  }
}


static double EvaluatePartition(rNode_c * LEAF,
                                double px1, double py1, double px2, double py2)
{
  double pdx = px2 - px1;
  double pdy = py2 - py1;

  int back   = 0;
  int front  = 0;
  int splits = 0;

  std::vector<rSide_c *>::iterator SI;

  for (SI = LEAF->sides.begin(); SI != LEAF->sides.end(); SI++)
  {
    rSide_c *S = *SI;

    // get state of lines' relation to each other
    double a = PerpDist(S->x1, S->y1, px1, py1, px2, py2);
    double b = PerpDist(S->x2, S->y2, px1, py1, px2, py2);

    int a_side = (a < -Q_EPSILON) ? -1 : (a > Q_EPSILON) ? +1 : 0;
    int b_side = (b < -Q_EPSILON) ? -1 : (b > Q_EPSILON) ? +1 : 0;

    if (a_side == 0 && b_side == 0)
    {
      // lines are colinear

      if (VectorSameDir(pdx, pdy, S->x2 - S->x1, S->y2 - S->y1))
        front++;
      else
        back++;

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
  // (this helps prevent the "sticky doorways" problem)
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


// what: 0 for start, 1 for end
static inline double P_Along(rNode_c *p, rSide_c *S, int what)
{
  if (what == 0)
    return AlongDist(S->x1, S->y1, p->x, p->y, p->x+p->dx, p->y+p->dy);
  else
    return AlongDist(S->x2, S->y2, p->x, p->y, p->x+p->dx, p->y+p->dy);
}


static void DivideOneSide(rSide_c *S, rNode_c *part, rNode_c *FRONT, rNode_c *BACK,
                          std::vector<intersect_t> & cut_list)
{
  S->node = NULL;

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

// fprintf(stderr, "dividing side %p valid:%d (%1.1f,%1.1f -> %1.1f,%1.1f)\n",
//         S, (S->seg && ! S->on_partition) ? 1 : 0,
//         S->x1, S->y1, S->x2, S->y2);
// fprintf(stderr, "  a=%d b=%d\n", a_side, b_side);

  if (a_side == 0 && b_side == 0)
  {
    // side sits on the partition, it will go either left or right
    S->on_partition = part;

    if (VectorSameDir(part->dx, part->dy, sdx, sdy))
    {
      FRONT->AddSide(S);

      // +2 and -2 mean "remove"
      BSP_AddIntersection(cut_list, P_Along(part, S, 0), +2);
      BSP_AddIntersection(cut_list, P_Along(part, S, 1), -2);
    }
    else
    {
      BACK->AddSide(S);

      BSP_AddIntersection(cut_list, P_Along(part, S, 0), -2);
      BSP_AddIntersection(cut_list, P_Along(part, S, 1), +2);
    }

    return;
  }

  /* check for right side */
  if (a_side >= 0 && b_side >= 0)
  {
    if (a_side == 0)
      BSP_AddIntersection(cut_list, P_Along(part, S, 0), -1);
    else if (b_side == 0)
      BSP_AddIntersection(cut_list, P_Along(part, S, 1), +1);

    FRONT->AddSide(S);
    return;
  }

  /* check for left side */
  if (a_side <= 0 && b_side <= 0)
  {
    if (a_side == 0)
      BSP_AddIntersection(cut_list, P_Along(part, S, 0), +1);
    else if (b_side == 0)
      BSP_AddIntersection(cut_list, P_Along(part, S, 1), -1);

    BACK->AddSide(S);
    return;
  }

  /* need to split it */

  // determine the intersection point
  double along = a / (a - b);

  double ix = S->x1 + along * sdx;
  double iy = S->y1 + along * sdy;

  rSide_c *T = rSideFactory_c::SplitAt(S, ix, iy);

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

  BSP_AddIntersection(cut_list, P_Along(part, T, 0), a_side);
}


static rSide_c * FindPartition(rNode_c * LEAF)
{
  // speed up large maps
  if (LEAF->sides.size() > 8)
  {
    double lx, ly, w, h;
    LEAF->CalcBounds(&lx, &ly, &w, &h);

    if (MAX(w, h) > 600)
    {
			if (w >= h)
        return rSideFactory_c::FakePartition(BSP_NiceMidwayPoint(lx, w), 0, 0, 1);
      else
        return rSideFactory_c::FakePartition(0, BSP_NiceMidwayPoint(ly, h), 1, 0);
    }
  }

  double   best_c = 1e30;
  rSide_c *best_p = NULL;

  std::vector<rSide_c *>::iterator SI;

  for (SI = LEAF->sides.begin(); SI != LEAF->sides.end(); SI++)
  {
    rSide_c *part = *SI;

    if (! part->Usable())
      continue;

    double cost = EvaluatePartition(LEAF, part->x1, part->y1, part->x2, part->y2);

    if (! best_p || cost < best_c)
    {
      best_c = cost;
      best_p = part;
    }
  }
// fprintf(stderr, "FIND DONE : best_c=%1.0f best_p=%p\n",
//         best_p ? best_c : -9999, best_p);

  SYS_ASSERT(best_p);

  return best_p;
}


static void Split_XY(rNode_c *part, rNode_c *FRONT, rNode_c *BACK)
{
  std::vector<rSide_c *> all_sides;

  all_sides.swap(part->sides);

//???  FRONT->region = NULL;

  std::vector<intersect_t> cut_list;

  for (unsigned int k = 0; k < all_sides.size(); k++)
  {
    DivideOneSide(all_sides[k], part, FRONT, BACK, cut_list);
  }

  BSP_MergeIntersections(cut_list);

  CreatePortals(part, FRONT, BACK, cut_list);
}


static rNode_c * Partition_XY(rNode_c * LN, merge_region_c *part_reg = NULL)
{
  if (LN->UsableSides() == 0)
  {
fprintf(stderr, "Partition_XY: found pseudo-leaf %p, sides:%u\n",
LN, LN->sides.size());

    merge_region_c *R = part_reg;

    if (! part_reg || part_reg->gaps.size() == 0)
    {
fprintf(stderr, "  SOLID\n");
      delete LN; return SOLID_LEAF;
    }

    all_windings.push_back(LN);

    // Z partitioning occurs later (the second pass)
fprintf(stderr, "  Region %p\n", part_reg);
    LN->region = part_reg;

    return LN;
  }


  rSide_c *part = FindPartition(LN);
  SYS_ASSERT(part);

fprintf(stderr, "PARTITION_XY = (%1.2f,%1.2f) -> (%1.2f,%1.2f)\n",
                part->x1, part->y1, part->x2, part->y2);

  // turn the pseudo leaf into a real node
  LN->BecomeNode(part->x1, part->y1, part->x2, part->y2);

  rNode_c * FRONT = new rNode_c();
  rNode_c * BACK  = new rNode_c();

/// int count = (int)LN->sides.size(); // LN->UsableSides();

  Split_XY(LN, FRONT, BACK);

/// int c_front = (int)FRONT->sides.size(); //  FRONT->UsableSides();
/// int c_back  = (int) BACK->sides.size(); //  BACK->UsableSides();

/// fprintf(stderr, "  SplitXY DONE: %d --> %d / %d\n", count, c_front, c_back);

  LN->front = Partition_XY(FRONT, part->FrontRegion());
  LN->back  = Partition_XY(BACK,  part->BackRegion());

  return LN;
}


static void Q1_BuildBSP()
{
  LogPrintf("\nQuake1_BuildBSP BEGUN\n");

  SOLID_LEAF = new rNode_c();
  SOLID_LEAF->lf_contents = CONTENTS_SOLID;
  SOLID_LEAF->index = -1;

  rNode_c *R_LEAF = new rNode_c();

  for (unsigned int i = 0; i < mug_segments.size(); i++)
  {
    merge_segment_c *S = mug_segments[i];

    rSide_c *F = NULL;
    rSide_c *B = NULL;

    if (S->front && S->front->gaps.size() > 0)
      F = CreateSide(R_LEAF, S, 0);

    if (S->back && S->back->gaps.size() > 0)
      B = CreateSide(R_LEAF, S, 1);

    if (F && B)
    {
      F->partner = B;
      B->partner = F;
    }
  }


  R_ROOT = Partition_XY(R_LEAF);

  SYS_ASSERT(R_ROOT->IsNode());
}



//------------------------------------------------------------------------
//  FACE STUFF
//------------------------------------------------------------------------


void Q1_AddEdge(double x1, double y1, double z1,
                double x2, double y2, double z2,
                dface_t *raw_face, dleaf_t *raw_lf = NULL)
{
  u16_t v1 = BSP_AddVertex(x1, y1, z1);
  u16_t v2 = BSP_AddVertex(x2, y2, z2);

  if (v1 == v2)
  {
    Main_FatalError("INTERNAL ERROR (Q1 AddEdge): zero length!\n"
                    "coordinate (%1.2f %1.2f %1.2f)\n", x1, y1, z1);
  }

  s32_t edge_idx = BSP_AddEdge(v1, v2);


  edge_idx = LE_S32(edge_idx);

  q_surf_edges->Append(&edge_idx, 4);

  q1_total_surf_edges += 1;

  raw_face->numedges += 1;


  // update bounding boxes
  double lows[3], highs[3];

  lows[0] = MIN(x1, x2);  highs[0] = MAX(x1, x2);
  lows[1] = MIN(y1, y2);  highs[1] = MAX(y1, y2);
  lows[2] = MIN(z1, z2);  highs[2] = MAX(z1, z2);

  for (int b = 0; b < 3; b++)
  {
    s16_t low  =  (I_ROUND( lows[b]) - 2) & ~3;
    s16_t high = ((I_ROUND(highs[b]) + 2) |  3) + 1;

    if (raw_lf)
    {
      raw_lf->mins[b] = MIN(raw_lf->mins[b], low);
      raw_lf->maxs[b] = MAX(raw_lf->maxs[b], high);
    }
  }
}


void Q1_AddSurf(u16_t index, dleaf_t *raw_lf )
{
  index = LE_U16(index);

  q_mark_surfs->Append(&index, 2);

  q1_total_mark_surfs += 1;

  raw_lf->num_marksurf += 1;
}


struct Compare_FloorAngle_pred
{
  double *angles;

   Compare_FloorAngle_pred(double *p) : angles(p) { }
  ~Compare_FloorAngle_pred() { }

  inline bool operator() (int A, int B) const
  {
    return angles[A] < angles[B];
  }
};


static int CollectClockwiseVerts(rNode_c *winding, float *vert_x, float *vert_y, bool anticlock)
{
  int v_num = 0;

  std::vector<rSide_c *>::iterator SI;

  double mid_x = 0;
  double mid_y = 0;
  

  for (SI = winding->sides.begin(); SI != winding->sides.end(); SI++, v_num++)
  {
    rSide_c *S = *SI;

    vert_x[v_num] = S->x1;
    vert_y[v_num] = S->y1;

    mid_x += vert_x[v_num];
    mid_y += vert_y[v_num];
  }

  mid_x /= v_num;
  mid_y /= v_num;

  
  // determine angles, then sort into clockwise order

  double angles[256];

  std::vector<int> mapping(v_num);

  for (int a = 0; a < v_num; a++)
  {
    angles[a] = CalcAngle(mid_x, mid_y, vert_x[a], vert_y[a]);

    if (! anticlock)
      angles[a] *= -1.0;

    mapping[a] = a;
  }


  std::sort(mapping.begin(), mapping.end(),
            Compare_FloorAngle_pred(angles));


  // apply mapping to vertices
  float old_x[256];
  float old_y[256];

  for (int k = 0; k < v_num; k++)
  {
    old_x[k] = vert_x[k];
    old_y[k] = vert_y[k];
  }

///fprintf(stderr, "\nMIDDLE @ (%1.2f %1.2f) COUNT:%d\n", mid_x, mid_y, v_num);
  for (int m = 0; m < v_num; m++)
  {
    vert_x[m] = old_x[mapping[m]];
    vert_y[m] = old_y[mapping[m]];

///fprintf(stderr, "___ (%+5.0f %+5.0f)\n", vert_x[m], vert_y[m]);
  }

  return v_num;
}


static int CalcTextureFlag(const char *tex_name)
{
  if (tex_name[0] == '*')
    return TEX_SPECIAL;

  if (strncmp(tex_name, "sky", 3) == 0)
    return TEX_SPECIAL;

  return 0;
}

static double DotProduct3(const double *A, const double *B)
{
  return A[0] * B[0] + A[1] * B[1] + A[2] * B[2];
}

static void GetExtents(double min_s, double min_t, double max_s, double max_t,
                       int *ext_W, int *ext_H)
{
  // -AJA- this matches the logic in the Quake1 engine.

  int bmin_s = (int)floor(min_s / 16.0);
  int bmin_t = (int)floor(min_t / 16.0);

  int bmax_s = (int)ceil(max_s / 16.0);
  int bmax_t = (int)ceil(max_t / 16.0);

  *ext_W = bmax_s - bmin_s + 1;
  *ext_H = bmax_t - bmin_t + 1;
}


static void BuildFloorFace(dface_t& raw_face, rFace_c *F)
{
// FIXME BuildFloorFace
#if 0
  qLeaf_c *leaf = F->floor_leaf;
  SYS_ASSERT(leaf);

  merge_region_c *R = leaf->GetRegion();
  SYS_ASSERT(R);

  merge_gap_c *gap = R->gaps.at(F->gap);

  double z1 = gap->GetZ1();
  double z2 = gap->GetZ2();

  double z = (F->kind == qFace_c::CEIL) ? z2 : z1;
///fprintf(stderr, "BuildFloorFace: F=%p kind:%d @ z:%1.0f\n", F, F->kind, z);


  bool is_ceil = (F->kind == qFace_c::CEIL) ? true : false;
  bool flipped;

  raw_face.planenum = BSP_AddPlane(0, 0, z,
                                   0, 0, is_ceil ? -1 : +1, &flipped);
  raw_face.side = flipped ? 1 : 0;


  const char *texture = is_ceil ? gap->CeilTex() : gap->FloorTex();

  int flags = CalcTextureFlag(texture);

  double s[4] = { 1.0, 0.0, 0.0, 0.0 };
  double t[4] = { 0.0, 1.0, 0.0, 0.0 };

  raw_face.texinfo = Q1_AddTexInfo(texture, flags, s, t);

  raw_face.styles[0] = 0xFF;  // no lightmap
  raw_face.styles[1] = 0xFF;
  raw_face.styles[2] = 0xFF;
  raw_face.styles[3] = 0xFF;

  raw_face.lightofs = -1;  // no lightmap

  // collect the vertices and sort in clockwise order

  float vert_x[256];
  float vert_y[256];

  int v_num = CollectClockwiseVerts(vert_x, vert_y, leaf, flipped);

  double min_x = +9e9; double max_x = -9e9;
  double min_y = +9e9; double max_y = -9e9;


  // add the edges

  for (int pos = 0; pos < v_num; pos++)
  {
    int p2 = (pos + 1) % v_num;

    Q1_AddEdge(vert_x[pos], vert_y[pos], z,
               vert_x[p2 ], vert_y[p2 ], z, &raw_face);

    min_x = MIN(min_x, vert_x[pos]);
    min_y = MIN(min_y, vert_y[pos]);
    max_x = MAX(max_x, vert_x[pos]);
    max_y = MAX(max_y, vert_y[pos]);
  }


  if (! (flags & TEX_SPECIAL))
  {
    int ext_W, ext_H;

    GetExtents(min_x, min_y, max_x, max_y, &ext_W, &ext_H);

    static int foo; foo++;
    raw_face.styles[0] = 0; // (foo & 3); //!!!!!

    raw_face.lightofs = 100; //!!!! Quake1_LightAddBlock(ext_W, ext_H, rand()&0x7F);
  }
#endif
}


static void BuildWallFace(dface_t& raw_face, rFace_c *F)
{
// FIXME BuildWallFace
#if 0
  qSide_c *S = F->side;

  merge_region_c *R = S->GetRegion();
  SYS_ASSERT(R);

///  merge_gap_c *gap = R->gaps.at(F->gap);

  double z1 = F->z1;
  double z2 = F->z2;


  bool flipped;

  raw_face.planenum = BSP_AddPlane(S->x1, S->y1, 0,
                                (S->y2 - S->y1), (S->x1 - S->x2), 0,
                                &flipped);

  raw_face.side = flipped ? 1 : 0;
  
  const char *texture = "error";

  merge_region_c *BACK = (S->side == 0) ? S->seg->back : S->seg->front;
///fprintf(stderr, "BACK = %p\n", BACK);
  if (BACK)
  {
    csg_brush_c *MID = PolyForSideTexture(BACK, z1, z2);
    if (MID)
      texture = MID->w_face->tex.c_str();
  }

  int flags = CalcTextureFlag(texture);

  double s[4] = { 0.0, 0.0, 0.0, 0.0 };
  double t[4] = { 0.0, 0.0, 1.0, 0.0 };

  if (fabs(S->x1 - S->x2) > fabs(S->y1 - S->y2))
  {
    s[0] = 1.0;
  }
  else
  {
    s[1] = 1.0;
  }

  raw_face.texinfo = Q1_AddTexInfo(texture, flags, s, t);

  raw_face.styles[0] = 0xFF;  // no lightmap
  raw_face.styles[1] = 0xFF;
  raw_face.styles[2] = 0xFF;
  raw_face.styles[3] = 0xFF;

  raw_face.lightofs = -1;  // no lightmap

  // add the edges

  Q1_AddEdge(S->x1, S->y1, z1,  S->x1, S->y1, z2, &raw_face);
  Q1_AddEdge(S->x1, S->y1, z2,  S->x2, S->y2, z2, &raw_face);
  Q1_AddEdge(S->x2, S->y2, z2,  S->x2, S->y2, z1, &raw_face);
  Q1_AddEdge(S->x2, S->y2, z1,  S->x1, S->y1, z1, &raw_face);

  if (! (flags & TEX_SPECIAL))
  {
    double coord[4][3];

    coord[0][0] = S->x1; coord[0][1] = S->y1; coord[0][2] = z1;
    coord[1][0] = S->x1; coord[1][1] = S->y1; coord[1][2] = z2;
    coord[2][0] = S->x2; coord[2][1] = S->y2; coord[2][2] = z1;
    coord[3][0] = S->x2; coord[3][1] = S->y2; coord[3][2] = z2;

    double min_s = +9e9; double max_s = -9e9;
    double min_t = +9e9; double max_t = -9e9;

    for (int k = 0; k < 4; k++)
    {
      double ss = DotProduct3(s, coord[k]);
      double tt = DotProduct3(t, coord[k]);

      min_s = MIN(min_s, ss); max_s = MAX(max_s, ss);
      min_t = MIN(min_t, tt); max_t = MAX(max_t, tt);
    }

    int ext_W, ext_H;

    GetExtents(min_s, min_t, max_s, max_t, &ext_W, &ext_H);

    static int foo = 0; foo++;
    raw_face.styles[0] = 0; // (foo & 3); //!!!!!

    raw_face.lightofs = 100; //!!!! Quake1_LightAddBlock(ext_W, ext_H, 0x80|(rand()&0x7F));
  }
#endif
}


///---static void Flat_BuildFaces(rNode_c *LN)
///---{
///---  if (LN == SOLID_LEAF)
///---    return;
///---
///---  if (! LN->IsNode())
///---    return;
///---
///---  // recurse down
///---  Flat_BuildFaces(LN->front);
///---  Flat_BuildFaces(LN->back);
///---
///---  if (! LN->winding())
///---    return;
///---
///---  SYS_ASSERT(LN->z_splitter);
///---
///---  rFace_c * F = new rFace_c;
///---
///---  LN->faces.insert(F);
///---
///---  // FIXME
///---}


static rFace_c * NewFace(...)
{
  rFace_c * F = new rFace_c;

  return F;
}


static void DoAddFace(rNode_c *LEAF, rSide_c *S, double z1, double z2,
                      area_vert_c *av)
{
  SYS_ASSERT(z2 > z1);

  // make sure face height does not exceed the limit
  if (true)
  {
    int num = 1 + (int)floor((z2 - z1) / (double)FACE_MAX_SIZE);

///fprintf(stderr, "Splitting tall face (%1.0f .. %1.0f) into %d pieces\n", z1, z2, num);

    SYS_ASSERT(num >= 1);

    for (int i = 0; i < num; i++)
    {
      double nz1 = z1 + (z2 - z1) *  i    / (double)num;
      double nz2 = z1 + (z2 - z1) * (i+1) / (double)num;

      rFace_c * F = NewFace(rFace_c::WALL, nz1, nz2, av);

fprintf(stderr, "Created face %p : %1.0f..%1.0f\n", F, nz1, nz2);
fprintf(stderr, "  added to leaf %p and node %p\n", LEAF, S->on_partition);

      LEAF->AddFace(F);
      S->on_partition->AddFace(F);
    }
  }
}


static void Side_BuildFaces(rNode_c *LEAF, rSide_c *S, merge_gap_c *G   )

{
  if (! S->seg)
    return;

  if (! S->on_partition)
  {
    LogPrintf("WARNING: Side found which is not on any node.\n");
    return;
  }

  merge_segment_c * seg = S->seg;
  SYS_ASSERT(seg);

  // create the faces
  merge_region_c *RX = S->BackRegion();

  double z1 = G->GetZ1();
  double z2 = G->GetZ2();

  // emergency fallback
  if (RX == NULL)
  {
    DoAddFace(LEAF, S, z1, z2, CSG2_FindSideVertex(seg, (z1+z2)/2.0, (S->side==0)));
    return;
  }

  // complex case: compare with solids on other side

  // FIXME: use brushes, not gaps

  for (int m = 0; m <= (int)RX->gaps.size(); m++)
  {
    double sz1 = (m == 0) ? -9e6 : RX->gaps[m-1]->GetZ2();
    double sz2 = (m == (int)RX->gaps.size()) ? +9e6 : RX->gaps[m]->GetZ1();

    if (sz1 < z1) sz1 = z1;
    if (sz2 > z2) sz2 = z2;

    if (sz2 < sz1 + 0.99)  // don't create tiny faces
      continue;

    DoAddFace(LEAF, S,  sz1, sz2, CSG2_FindSideVertex(seg, (sz1+sz2)/2.0, (S->side==0)));
  }
}



static rNode_c * Z_Leaf(rNode_c *winding, merge_region_c *R, int gap)
{
  rNode_c *LEAF = NewLeaf(CONTENTS_EMPTY);

  LEAF->gap = gap;

  z_leafs.push_back(LEAF);

  SYS_ASSERT(R);
  SYS_ASSERT(0 <= gap && gap < (int)R->gaps.size());
  
  merge_gap_c *G = R->gaps[gap];

fprintf(stderr, "Z_Leaf: winding %p has %u sides\n", winding, winding->sides.size());
  for (unsigned int i = 0; i < winding->sides.size(); i++)
  {
    Side_BuildFaces(LEAF, winding->sides[i], G);
  }

  return LEAF;
}


static void AddFlatFace(rNode_c * N, int gap, int kind)
{
  for (unsigned int k = 0; k < z_leafs.size(); k++)
  {
    rNode_c * LEAF = z_leafs[k];

    if (LEAF->gap == gap)
    {
      rFace_c *F = NewFace();

      F->kind = kind;

fprintf(stderr, "Created flat face z=%1.0f\n", N->z);
fprintf(stderr, "  added to leaf %p and node %p\n", LEAF, N);

      LEAF->AddFace(F);
      N->AddFace(F);

      return;
    }
  }

  LogPrintf("WARNING: missing leaf for flat surface\n");
}


// area number is:
//    0 for below the lowest floor,
//    1 for the first gap
//    2 for above the first gap
//    3 for the second gap
//    etc etc...

static rNode_c * Partition_Z(rNode_c *winding, merge_region_c *R,
                              int min_area, int max_area)
{
  SYS_ASSERT(min_area <= max_area);

  if (min_area == max_area)
  {
    if ((min_area & 1) == 0)
      return SOLID_LEAF;
    else
      return Z_Leaf(winding, R, min_area / 2);
  }


  {
///---    int dz = (a1 & 1) ? -1 : +1;

    rNode_c *node = new rNode_c(true /* z_splitter */);

    node->dz = 1;
    node->winding = winding;

    int a1 = (min_area + max_area) / 2;
    int a2 = a1 + 1;

    int g = a1 / 2;
    SYS_ASSERT(g < (int)R->gaps.size());

    if (a1 & 1)
      node->z = R->gaps[g]->GetZ2();
    else
      node->z = R->gaps[g]->GetZ1();

    node->back  = Partition_Z(winding, R, min_area, a1);
    node->front = Partition_Z(winding, R, a2, max_area);

    AddFlatFace(node, g, (a1 & 1) ? rFace_c::CEIL : rFace_c::FLOOR);

    return node;
  }
}


static rNode_c * SecondPass(rNode_c *LN)
{
  // Faces are built in a second pass after building the 2D BSP tree.
  // This is because Sides (and their partners) can get split by future
  // partition lines, and trying to manage faces in the face of that
  // becomes a nightmare.

  if (LN == SOLID_LEAF)
    return LN;

  if (LN->IsNode())
  {
    LN->front = SecondPass(LN->front);
    LN->back  = SecondPass(LN->back);

    return LN;
  }

  SYS_ASSERT(LN->region);
  SYS_ASSERT(LN->region->gaps.size() > 0);

  z_leafs.clear();

  return Partition_Z(LN, LN->region, 0, (int)LN->region->gaps.size() * 2);
}



//------------------------------------------------------------------------
//  LUMP WRITING CODE
//------------------------------------------------------------------------


static void AssignLeafIndex(rNode_c *leaf)
{
  if (leaf == SOLID_LEAF)
    return;

  // must add 2 (instead of 1) because leaf #0 is the SOLID_LEAF
  leaf->index = -(q1_total_leafs+2);

  q1_total_leafs += 1;

  // FIXME: leaf bounding box
}

static void AssignIndexes(rNode_c *node)
{
  node->index = q1_total_nodes;

  q1_total_nodes += 1;

  if (node->front->IsNode())
    AssignIndexes(node->front);
  else
    AssignLeafIndex(node->front);

  if (node->back->IsNode())
    AssignIndexes(node->back);
  else
    AssignLeafIndex(node->back);

  // determine node's bounding box
  for (int b = 0; b < 3; b++)
  {
    // FIXME
  }
}


static void WriteFace(rFace_c *F)
{
  SYS_ASSERT(F->index < 0);

  dface_t raw_face;

  memset(&raw_face, 0, sizeof(raw_face));

  raw_face.firstedge = q1_total_surf_edges;
  raw_face.numedges  = 0;

  if (true) //!!!!!!  rFace_c::WALL)
    BuildWallFace(raw_face, F);
  else
    BuildFloorFace(raw_face, F);

  F->index = (int)model.numfaces;
  model.numfaces += 1;

  if (F->index >= MAX_MAP_FACES)
    Main_FatalError("Quake1 build failure: exceeded limit of %d FACES\n",
                    MAX_MAP_FACES);

  // TODO: fix endianness in face
  q1_faces->Append(&raw_face, sizeof(raw_face));
}


static void WriteSolidLeaf(void)
{
  dleaf_t raw_lf;

  memset(&raw_lf, 0, sizeof(raw_lf));

  raw_lf.contents = CONTENTS_SOLID;
  raw_lf.visofs   = -1;  // no visibility info

  q1_leafs->Append(&raw_lf, sizeof(raw_lf));
}


static void WriteLeaf(rNode_c *leaf)
{
  SYS_ASSERT(leaf);

  if (leaf == SOLID_LEAF)
    return;


  dleaf_t raw_lf;

  memset(&raw_lf, 0, sizeof(raw_lf));

  raw_lf.contents = leaf->lf_contents;
  raw_lf.visofs   = -1;  // no visibility info

  for (int b = 0; b < 3; b++)
  {
    raw_lf.mins[b] = I_ROUND(leaf->mins[b]) - 4;
    raw_lf.maxs[b] = I_ROUND(leaf->maxs[b]) + 4;
  }


  raw_lf.first_marksurf = q1_total_mark_surfs;
  raw_lf.num_marksurf   = 0;


  // create the 'mark surfs'
fprintf(stderr, "Write leaf %p : faces=%u\n", leaf, leaf->faces.size());
  for (unsigned int i = 0; i < leaf->faces.size(); i++)
  {
    rFace_c *F = leaf->faces[i];

    // should have been in a node already
    if (F->index < 0)
      LogPrintf("WARNING: face found in leaf but not in node\n");
    else
      Q1_AddSurf(F->index, &raw_lf);
  }

  // TODO: fix endianness in raw_lf
  q1_leafs->Append(&raw_lf, sizeof(raw_lf));
}


static void WriteNodes(rNode_c *node)
{
  node->CheckValid();

  dnode_t raw_nd;

  memset(&raw_nd, 0, sizeof(raw_nd));

  bool flipped;

  if (node->z_splitter)
    raw_nd.planenum = BSP_AddPlane(0, 0, node->z, 0, 0, node->dz, &flipped);
  else
    raw_nd.planenum = BSP_AddPlane(node->x, node->y, 0,
                                   node->dy, -node->dx, 0, &flipped);

  raw_nd.children[0] = (u16_t) node->front->index;
  raw_nd.children[1] = (u16_t) node->back ->index;

  if (flipped)
  {
    u16_t tmp = raw_nd.children[0];
    raw_nd.children[0] = raw_nd.children[1];
    raw_nd.children[1] = tmp;
  }

  for (int b = 0; b < 3; b++)
  {
    raw_nd.mins[b] = I_ROUND(node->mins[b]) - 32;
    raw_nd.maxs[b] = I_ROUND(node->maxs[b]) + 32;
  }


fprintf(stderr, "Write node %p : faces=%u\n", node, node->faces.size());
  if (node->faces.size() > 0)
  {
    raw_nd.firstface = model.numfaces;
    raw_nd.numfaces  = node->faces.size();

    for (unsigned int k = 0; k < node->faces.size(); k++)
      WriteFace(node->faces[k]);
  }


  // TODO: fix endianness in 'raw_nd'
  q1_nodes->Append(&raw_nd, sizeof(raw_nd));


  // recurse now, AFTER adding the current node

  if (node->front->IsNode())
    WriteNodes(node->front);
  else
    WriteLeaf(node->front);

  if (node->back->IsNode())
    WriteNodes(node->back);
  else
    WriteLeaf(node->back);
}


void Q1_CreateModel(void)
{
  rSideFactory_c::FreeAll();
  all_windings.clear();

  Q1_BuildBSP();

  qLump_c *lump = BSP_NewLump(LUMP_MODELS);

  memset(&model, 0, sizeof(model));

  q1_total_nodes = 0;
  q1_total_leafs = 0;  // ignoring the solid leaf

  q1_total_mark_surfs = 0;
  q1_total_surf_edges = 0;

  q1_nodes = BSP_NewLump(LUMP_NODES);
  q1_leafs = BSP_NewLump(LUMP_LEAFS);
  q1_faces = BSP_NewLump(LUMP_FACES);

  q_mark_surfs = BSP_NewLump(LUMP_MARKSURFACES);
  q_surf_edges = BSP_NewLump(LUMP_SURFEDGES);

  SecondPass(R_ROOT);

  AssignIndexes(R_ROOT);

  if (q1_total_nodes >= MAX_MAP_NODES)
    Main_FatalError("Quake1 build failure: exceeded limit of %d NODES\n",
                    MAX_MAP_NODES);

  if (q1_total_leafs >= MAX_MAP_LEAFS)
    Main_FatalError("Quake1 build failure: exceeded limit of %d LEAFS\n",
                    MAX_MAP_LEAFS);

  WriteSolidLeaf();

  WriteNodes(R_ROOT);


  // set model bounding box
  double mins[3], maxs[3];

  CSG2_GetBounds(mins[0], mins[1], mins[2],  maxs[0], maxs[1], maxs[2]);

  for (int b = 0; b < 3; b++)
  {
    model.mins[b]   = mins[b];
    model.maxs[b]   = maxs[b];
    model.origin[b] = 0;
  }


  // clipping hulls
  model.visleafs = q1_total_leafs;

  q_clip_nodes = BSP_NewLump(LUMP_CLIPNODES);

  model.headnode[0] = 0; // root of drawing BSP
  model.headnode[1] = Q1_CreateClipHull(1, q_clip_nodes);
  model.headnode[2] = Q1_CreateClipHull(2, q_clip_nodes);
  model.headnode[3] = Q1_CreateClipHull(3, q_clip_nodes);


  // TODO: fix endianness in model
  lump->Append(&model, sizeof(model));

  Q1_CreateSubModels(lump, model.numfaces, model.visleafs);


  delete R_ROOT;  R_ROOT = NULL;
  delete SOLID_LEAF;  SOLID_LEAF = NULL;


  // there is no need to delete the lumps from BSP_NewLump()
  // since is handled by the q_bsp.c code.
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
