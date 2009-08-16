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


void DoAssignFaces(qNode_c *N, qSide_c *S);


class qFace_c
{
public:
  enum face_kind_e
  {
    WALL  = 0,
    FLOOR = 1,
    CEIL  = 2
  };

  int kind;

  double z1, z2;

  int gap;

  qSide_c *side;
  qLeaf_c *floor_leaf;

  int index;  // final index into Faces lump

public:
   qFace_c(int _kind = WALL) : kind(_kind), side(NULL), floor_leaf(NULL), index(-1) { }
  ~qFace_c() { }

   qFace_c(int _kind, int _gap, double _z1, double _z2) :
           kind(_kind), z1(_z1), z2(_z2), gap(_gap),
           side(NULL), floor_leaf(NULL), index(-1)
   { }

   qFace_c(const qFace_c *other, qSide_c *new_side) :
           kind(other->kind), z1(other->z1), z2(other->z2),
           gap(other->gap), side(new_side),
           floor_leaf(NULL), index(-1)
   { }
};


class qSide_c
{
public:
  merge_segment_c *seg;  // NULL means "portal"

  int side;  // 0 is front, 1 is back

  double x1, y1;
  double x2, y2;

  // faces on this side
  std::vector<qFace_c *> faces;
 
  bool original;  // false for split-off pieces

  qNode_c * on_node;  // non-null if has been on a partition line

public:
  qSide_c(merge_segment_c * _seg, int _side) :
      seg(_seg), side(_side), faces(), original(true), on_node(NULL)
  {
    if (side == 0)
    {
      x1 = seg->start->x;  x2 = seg->end->x;
      y1 = seg->start->y;  y2 = seg->end->y;
    }
    else  // back
    {
      x1 = seg->end->x;  x2 = seg->start->x;
      y1 = seg->end->y;  y2 = seg->start->y;
    }
  }

  ~qSide_c()
  {
      // TODO: delete the faces
  }

private:
  // copy constructor, used when splitting
  qSide_c(const qSide_c *other, double new_x, double new_y) :
          seg(other->seg), side(other->side),
          x1(new_x), y1(new_y), x2(other->x2), y2(other->y2),
          faces(), original(false), on_node(other->on_node)
  { }

  // for NewPortal
  qSide_c(double px1, double py1, double px2, double py2, int _side) :
      seg(NULL), side(_side), faces(), original(true),
      on_node(NULL) // FIXME !!!!!
  {
    if (side == 0)
    {
      x1 = px1; y1 = py1;
      x2 = px2; y2 = py2;
    }
    else  // back
    {
      x1 = px2; y1 = py2;
      x2 = px1; y2 = py1;
    }
  }

public:
  double Length() const
  {
    return ComputeDist(x1,y1, x2,y2);
  }

  merge_region_c *GetRegion() const
  {
    SYS_ASSERT(seg);
    return (side == 0) ? seg->front : seg->back;
  }

  qSide_c *SplitAt(double new_x, double new_y)
  {
    qSide_c *T = new qSide_c(this, new_x, new_y);

    x2 = new_x;
    y2 = new_y;

    // duplicate the faces
    for (unsigned int i = 0; i < faces.size(); i++)
    {
      T->faces.push_back(new qFace_c(faces[i], T));
    }

    if (on_node)
      DoAssignFaces(on_node, T);

    return T;
  }

  static qSide_c *NewPortal(double px1, double py1, double px2, double py2,
                     int _side)
  {
    return new qSide_c(px1,py1, px2,py2, _side);
  }

  void AddFace(qFace_c *F)
  {
    SYS_ASSERT(original);

    faces.push_back(F);

    F->side = this;
  }
};


class qLeaf_c
{
public:
  int contents;

  std::list<qSide_c *> sides;

  // Note: qSide_c objects are shared when gap > 0

  int gap;
  int numgap;

  double min_x, min_y;
  double max_x, max_y;

  // list of faces is created when the leaf is vertically partitioned
  // NB: faces are managed by qSide_c, we only store ptr-copies here
  std::vector<qFace_c *> faces;

  qFace_c *floor;
  qFace_c *ceil;

  bool floor_on_node;
  bool ceil_on_node;

public:
  qLeaf_c() : contents(CONTENTS_EMPTY), /* faces(), */ sides(),
              gap(0), numgap(0),
              min_x(0), min_y(0), max_x(0), max_y(0),
              faces(), floor(NULL), ceil(NULL),
              floor_on_node(false), ceil_on_node(false)
  { }

  ~qLeaf_c()
  {
    // TODO: delete faces and sides
  }

  qLeaf_c(qLeaf_c& other, int _gap) :
          contents(other.contents), sides(), gap(_gap),
          min_x(other.min_x), min_y(other.min_y),
          max_x(other.max_x), max_y(other.max_y),
          faces(), floor(NULL), ceil(NULL),
          floor_on_node(false), ceil_on_node(false)
  {
    // copy the side pointers
    std::list<qSide_c *>::iterator SI;

    for (SI = other.sides.begin(); SI != other.sides.end(); SI++)
      sides.push_back(*SI);

    // we don't copy faces (???)
  }

  qSide_c * AddSide(merge_segment_c *_seg, int _side)
  {
    qSide_c *S = new qSide_c(_seg, _side); 

    sides.push_back(S);

#if 0
    fprintf(stderr, "Side #%p : seg (%1.0f,%1.0f) - (%1.0f,%1.0f) side:%d\n",
         S, _seg->start->x, _seg->start->y,
           _seg->end->x, _seg->end->y, _side);
#endif
    return S;
  }

  merge_region_c *GetRegion() // const
  {
    // NOTE: assumes a convex leaf (in XY) !!
    for (std::list<qSide_c *>::iterator SI = sides.begin();
         SI != sides.end();
         SI++)
    {
      if ((*SI)->seg)
        return (*SI)->GetRegion();
    }

    Main_FatalError("INTERNAL ERROR: Leaf %p has no solid side!", this);
    return NULL; /* NOT REACHED */
  }

  bool HasSide(qSide_c *side)
  {
    for (std::list<qSide_c *>::iterator SI = sides.begin();
         SI != sides.end();
         SI++)
    {
      if ((*SI) == side)
        return true;
    }

    return false;
  }

  merge_gap_c *GetGap()
  {
    SYS_ASSERT(numgap == 1);

    merge_region_c *R = GetRegion();

    SYS_ASSERT(R);
    SYS_ASSERT(gap >= 0 && gap < (int)R->gaps.size());

    return R->gaps[gap];
  }

  void ComputeBBox()
  {
    min_x = min_y = +9e9;
    max_x = max_y = -9e9;

    std::list<qSide_c *>::iterator SI;

    for (SI = sides.begin(); SI != sides.end(); SI++)
    {
      qSide_c *S = (*SI);

      if (S->x1 < min_x) min_x = S->x1;
      if (S->x2 < min_x) min_x = S->x2;
      if (S->y1 < min_y) min_y = S->y1;
      if (S->y2 < min_y) min_y = S->y2;

      if (S->x1 > max_x) max_x = S->x1;
      if (S->x2 > max_x) max_x = S->x2;
      if (S->y1 > max_y) max_y = S->y1;
      if (S->y2 > max_y) max_y = S->y2;
    }
  }

  void AssignFaces()
  {
    SYS_ASSERT(numgap == 1);

    std::list<qSide_c *>::iterator SI;

    for (SI = sides.begin(); SI != sides.end(); SI++)
    {
      qSide_c *S = *SI;

      if (! S->seg) // ignore portals
        continue;

      for (unsigned int k = 0; k < S->faces.size(); k++)
      {
        qFace_c *F = S->faces[k];

        // check if already there
        bool already = false;
        for (unsigned int m=0; m < faces.size(); m++)
        {
          SYS_ASSERT(faces[m] != F); // { already = true; break; }
        }

        if (F->gap == gap && !already)
          faces.push_back(F);
      }
    }
  }
};


class qNode_c
{
public:
  // true if this node splits the tree by Z
  // (with a horizontal upward-facing plane, i.e. dz = 1).
  int z_splitter;

  double z;

  // normal splitting planes are vertical, and here are the
  // coordinates on the map.
  double x,  y;
  double dx, dy;

  qLeaf_c *front_l;  // front space : one of these is non-NULL
  qNode_c *front_n;

  qLeaf_c *back_l;   // back space : one of these is non-NULL
  qNode_c *back_n;

  double min_x, min_y;
  double max_x, max_y;

  // NB: faces are managed by qSide_c, we only store copies here
  std::vector<qFace_c *> faces;

public:
  qNode_c(int _Zsplit) : z_splitter(_Zsplit), z(0),
                          x(0), y(0), dx(0), dy(0),
                          front_l(NULL), front_n(NULL),
                          back_l(NULL),  back_n(NULL),
                          min_x(0), min_y(0),
                          max_x(0), max_y(0),
                          faces()
  { }

  ~qNode_c()
  {
    if (front_l) delete front_l;
    if (front_n) delete front_n;

    if (back_l) delete back_l;
    if (back_n) delete back_n;
  }

  void Flip()
  {
    if (z_splitter)
      z_splitter = 3 - z_splitter;

    qLeaf_c *tmp_l = front_l; front_l = back_l; back_l = tmp_l;
    qNode_c *tmp_n = front_n; front_n = back_n; back_n = tmp_n;

    dx = -dx;
    dy = -dy;
  }

  void AssignFaces(qSide_c *S)
  {
    SYS_ASSERT(S->seg); // should never be a portal

    for (unsigned int f = 0; f < S->faces.size(); f++)
    {
      faces.push_back(S->faces[f]);
    }
  }

  void BBoxFromChildren()
  {
    min_x = +9e5; max_x = -9e5;
    min_y = +9e5; max_x = -9e5;

    // TODO z coordinate

    if (front_l == SOLID_LEAF)
    {
      // do nothing (???)
    }
    else if (front_l)
    {
      min_x = MIN(min_x, front_l->min_x);
      min_y = MIN(min_y, front_l->min_y);
      max_x = MAX(max_x, front_l->max_x);
      max_y = MAX(max_y, front_l->max_y);
    }
    else
    {
      SYS_ASSERT(front_n);

      min_x = MIN(min_x, front_n->min_x);
      min_y = MIN(min_y, front_n->min_y);
      max_x = MAX(max_x, front_n->max_x);
      max_y = MAX(max_y, front_n->max_y);
    }

    if (back_l == SOLID_LEAF)
    {
      // do nothing (???)
    }
    else if (back_l)
    {
      min_x = MIN(min_x, back_l->min_x);
      min_y = MIN(min_y, back_l->min_y);
      max_x = MAX(max_x, back_l->max_x);
      max_y = MAX(max_y, back_l->max_y);
    }
    else
    {
      SYS_ASSERT(back_n);

      min_x = MIN(min_x, back_n->min_x);
      min_y = MIN(min_y, back_n->min_y);
      max_x = MAX(max_x, back_n->max_x);
      max_y = MAX(max_y, back_n->max_y);
    }

    SYS_ASSERT(min_x <= max_x);
    SYS_ASSERT(min_y <= max_y);
  }
};


void DoAssignFaces(qNode_c *N, qSide_c *S)
{
  N->AssignFaces(S);
}



//------------------------------------------------------------------------


static void SplitDiagonalSides(qLeaf_c *L)
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


static void CreatePortals(std::vector<intersection_c *>& cut_list, 
                          qNode_c *part, qLeaf_c *front_l, qLeaf_c *back_l)
{
  for (unsigned int i = 0; i+1 < cut_list.size(); i++)
  {
    intersection_c *K1 = cut_list[i];
    intersection_c *K2 = cut_list[i+1];

    bool k1_open = (K1->closed & intersection_c::AFTER)  ? false : true;
    bool k2_open = (K2->closed & intersection_c::BEFORE) ? false : true;

    if (k1_open != k2_open) // sanity check
    {
      DebugPrintf("WARNING: portal mismatch from (%1.1f %1.1f) to (%1.1f %1.1f)\n",
              K1->x, K1->y, K2->x, K2->y);
      continue;
    }

    if (! (k1_open && k2_open))
      continue;

    if (K2->along - K1->along < 0.99) // don't create tiny portals
      continue;

    // check if portal crosses solid space
    // (NOTE: this is hackish!)
    double mx = (K1->x + K2->x) / 2.0;
    double my = (K1->y + K2->y) / 2.0;

    if (CSG2_PointInSolid(mx, my))
      continue;

    qSide_c *front_pt = qSide_c::NewPortal(K1->x,K1->y, K2->x,K2->y, 0);
    qSide_c * back_pt = qSide_c::NewPortal(K1->x,K1->y, K2->x,K2->y, 1);

    front_l->sides.push_back(front_pt);
     back_l->sides.push_back( back_pt);

#if 0
    fprintf(stderr, "Portal along (%1.1f %1.1f) .. (%1.1f %1.1f)\n",
         K1->x,K1->y, K2->x,K2->y);
#endif
  }
}

static void DumpLeaf(qLeaf_c *L)
{
  std::list<qSide_c *>::iterator SI;

fprintf(stderr, "LEAF %p\n{\n", L);
  for (SI = L->sides.begin(); SI != L->sides.end(); SI++)
  {
    qSide_c *S = *SI;
    
    if (S->seg)
      fprintf(stderr, "  side #%p : seg:%p side:%d (%1.0f,%1.0f)..(%1.0f,%1.0f) \n",
              S, S->seg, S->side, S->x1, S->y1, S->x2, S->y2);
    else
      fprintf(stderr, "  side #%p : PORTAL side:%d (%1.0f,%1.0f)..(%1.0f,%1.0f) \n",
              S, S->side, S->x1, S->y1, S->x2, S->y2);
  }
fprintf(stderr, "}\n");
}

static void Split_XY(qNode_c *part, qLeaf_c *front_l, qLeaf_c *back_l)
{
  std::list<qSide_c *> all_sides;

  all_sides.swap(front_l->sides);

  std::vector<intersection_c *> cut_list;


  while (! all_sides.empty())
  {
    qSide_c *S = all_sides.front();

    all_sides.pop_front();

    double sdx = S->x2 - S->x1;
    double sdy = S->y2 - S->y1;

    // get state of lines' relation to each other
    double a = PerpDist(S->x1, S->y1,
                        part->x, part->y,
                        part->x + part->dx, part->y + part->dy);

    double b = PerpDist(S->x2, S->y2,
                        part->x, part->y,
                        part->x + part->dx, part->y + part->dy);

    double fa = fabs(a);
    double fb = fabs(b);

    if (fa <= Q_EPSILON && fb <= Q_EPSILON)
    {
      // lines are colinear

      if (part->dx * sdx + part->dy * sdy < 0.0)
      {
        back_l->sides.push_back(S);

        AddIntersection(cut_list, part, S->x2, S->y2, intersection_c::AFTER);
        AddIntersection(cut_list, part, S->x1, S->y1, intersection_c::BEFORE);
      }
      else
      {
        front_l->sides.push_back(S);

        AddIntersection(cut_list, part, S->x1, S->y1, intersection_c::AFTER);
        AddIntersection(cut_list, part, S->x2, S->y2, intersection_c::BEFORE);
      }

      // remember the faces along this node
      part->AssignFaces(S);

      S->on_node = part;
      continue;
    }

    if (fa <= Q_EPSILON || fb <= Q_EPSILON)
    {
      // partition passes through one vertex

      if ( ((fa <= Q_EPSILON) ? b : a) >= 0 )
        front_l->sides.push_back(S);
      else
        back_l->sides.push_back(S);

      if (fa <= Q_EPSILON)
        AddIntersection(cut_list, part, S->x1, S->y1);
      else // fb <= Q_EPSILON
        AddIntersection(cut_list, part, S->x2, S->y2);

      continue;
    }

    if (a > 0 && b > 0)
    {
      front_l->sides.push_back(S);
      continue;
    }

    if (a < 0 && b < 0)
    {
      back_l->sides.push_back(S);
      continue;
    }

    /* need to split it */

    // determine the intersection point
    double along = a / (a - b);

    double ix = S->x1 + along * sdx;
    double iy = S->y1 + along * sdy;

    qSide_c *T = S->SplitAt(ix, iy);

    if (a < 0)
    {
       back_l->sides.push_back(S);
      front_l->sides.push_back(T);
    }
    else
    {
      SYS_ASSERT(b < 0);

      front_l->sides.push_back(S);
       back_l->sides.push_back(T);
    }

    AddIntersection(cut_list, part, ix, iy);
  }

  MergeIntersections(cut_list);

  CreatePortals(cut_list, part, front_l, back_l);

if (0) {
for (int kk=0; kk < 2; kk++)
{
  fprintf(stderr, "%s:\n", (kk==0) ? "FRONT" : "BACK");
  DumpLeaf((kk==0) ? front_l : back_l);
}}

}


static void Partition_Solid(qLeaf_c *leaf, qNode_c ** out_n, qLeaf_c ** out_l)
{
  // handle sides first

  std::list<qSide_c *>::iterator SI;

  for (SI = leaf->sides.begin(); SI != leaf->sides.end(); SI++)
  {
    qSide_c *S = *SI;

    if (S->seg && ! S->on_node)
    {
      qNode_c * node = new qNode_c(0 /* z_splitter */);

      node->x = S->x1;
      node->y = S->y1;

      node->dx = S->x2 - S->x1;
      node->dy = S->y2 - S->y1;

      // find _ALL_ sides that lie on the partition
      std::list<qSide_c *>::iterator TI;

      for (TI = leaf->sides.begin(); TI != leaf->sides.end(); TI++)
      {
        qSide_c *T = *TI;

        if (! T->seg || T->on_node)
          continue;

        double a = PerpDist(T->x1, T->y1,  S->x1, S->y1, S->x2, S->y2);
        double b = PerpDist(T->x2, T->y2,  S->x1, S->y1, S->x2, S->y2);

        if (! (fabs(a) <= Q_EPSILON && fabs(b) <= Q_EPSILON))
          continue;

        node->AssignFaces(T);

        T->on_node = node;
      }

      node->back_l = SOLID_LEAF;

      Partition_Solid(leaf, &node->front_n, &node->front_l);

      node->BBoxFromChildren();

      (*out_n) = node;
      return;
    }
  }


  merge_gap_c *gap = leaf->GetGap();

  if (! leaf->ceil_on_node)
  {
      leaf->ceil_on_node = true;

      qNode_c * node = new qNode_c(2 /* z_splitter */);

      node->z = gap->GetZ2();

      SYS_ASSERT(leaf->ceil);
      node->faces.push_back(leaf->ceil);

      node->back_l = SOLID_LEAF;

      Partition_Solid(leaf, &node->front_n, &node->front_l);

      node->BBoxFromChildren();

      (*out_n) = node;
      return;
  }


  SYS_ASSERT(! leaf->floor_on_node);
  {
      leaf->floor_on_node = true;
  
      qNode_c * node = new qNode_c(1 /* z_splitter */);

      node->z = gap->GetZ1();

      SYS_ASSERT(leaf->floor);
      node->faces.push_back(leaf->floor);

      // End of the road, folks!
      node->front_l = leaf;
      node-> back_l = SOLID_LEAF;

      node->BBoxFromChildren();

      (*out_n) = node;
      return;
  }
}

static void Partition_Z(qLeaf_c *leaf, qNode_c ** out_n, qLeaf_c ** out_l)
{
  merge_region_c *R = leaf->GetRegion();

  if (leaf->numgap > 1)
  {
    int new_g = leaf->gap + leaf->numgap / 2;

    qLeaf_c *top_leaf = new qLeaf_c(*leaf, new_g);

    // TODO: OPTIMISE THIS : too many nodes!  Use top of gaps[new_g-1] as
    //       the splitting plane.

    qNode_c *node = new qNode_c(1 /* z_splitter */);

    // choose height halfway between the two gaps (in the solid)
    node->z = (R->gaps[new_g-1]->GetZ2() + R->gaps[new_g]->GetZ1()) / 2.0;

    top_leaf->numgap = leaf->gap + leaf->numgap - new_g;
        leaf->numgap = new_g - leaf->gap;

    Partition_Z(top_leaf, &node->front_n, &node->front_l);
    Partition_Z(    leaf, &node->back_n,  &node->back_l);

    node->BBoxFromChildren();

    *out_n = node;
    return;
  }

  SYS_ASSERT(leaf->numgap == 1);

  // create face list for the leaf
  leaf->AssignFaces();


  // create floor and ceiling faces here
  leaf->floor = new qFace_c(qFace_c::FLOOR);
  leaf->ceil  = new qFace_c(qFace_c::CEIL);

  leaf->floor->gap = leaf->gap;
  leaf-> ceil->gap = leaf->gap;

  leaf->floor->floor_leaf = leaf;
  leaf-> ceil->floor_leaf = leaf;


  Partition_Solid(leaf, out_n, out_l);
}


static void Partition_XY(qLeaf_c *leaf, qNode_c **out_n, qLeaf_c **out_l)
{
  bool is_root = (out_l == NULL);

  SYS_ASSERT(out_n);

  qSide_c *best_p = FindPartition(leaf);
  qNode_c *node;

  if (! best_p)
  {
    // current leaf is convex
///fprintf(stderr, "LEAF %p IS CONVEX\n", leaf);

    leaf->ComputeBBox();
    
    bool too_big = false;
    
    // faces must not be too large because of the way the Quake
    // texture mapping works.  Here we are abusing the node
    // builder to ensure floor and ceiling faces are OK.
    double l_width  = leaf->max_x - leaf->min_x;
    double l_height = leaf->max_y - leaf->min_y;

    if (l_width > FACE_MAX_SIZE || l_height > FACE_MAX_SIZE)
    {
///fprintf(stderr, "__ BUT TOO BIG: %1.0f x %1.0f\n", l_width , l_height);

      too_big = true;
    }

    // we need a root node, even on the simplest possible map.

    if (! is_root && ! too_big)
    {
      leaf->numgap = (int) leaf->GetRegion()->gaps.size();
      SYS_ASSERT(leaf->numgap > 0);

      SplitDiagonalSides(leaf);

      Partition_Z(leaf, out_n, out_l);
      return;
    }

    node = new qNode_c(0 /* z_splitter */);

    if (l_width > l_height)
    {
      // vertical divider
      node->x = (leaf->min_x + leaf->max_x) / 2.0;
      node->y = leaf->min_y;

      node->dx = 0;
      node->dy = leaf->max_y - leaf->min_y;
    }
    else // horizontal divider
    {
      node->x = leaf->min_x;
      node->y = (leaf->min_y + leaf->max_y) / 2.0;

      node->dx = leaf->max_x - leaf->min_x;
      node->dy = 0;
    }
  }
  else
  {
// fprintf(stderr, "LEAF HAS SPLITTER %p \n", best_p);
    node = new qNode_c(0 /* z_splitter */);

    node->x = best_p->x1;
    node->y = best_p->y1;

    node->dx = best_p->x2 - node->x;
    node->dy = best_p->y2 - node->y;
  }


// fprintf(stderr, "Using partition (%1.0f,%1.0f) to (%1.2f,%1.2f)\n",
//                  node->x, node->y,
//                  node->x + node->dx, node->y + node->dy);

  qLeaf_c *front_l = leaf;
  qLeaf_c *back_l  = new qLeaf_c;

  Split_XY(node, leaf, back_l);


  Partition_XY(front_l, &node->front_n, &node->front_l);
  Partition_XY( back_l, &node-> back_n, &node-> back_l);

  node->BBoxFromChildren();

  *out_n = node;
}



//------------------------------------------------------------------------


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

  static void FreeAll()
  {
    all_faces.clear();
  }
};


class rSide_c
{
friend class rSideFactory_c;

public:
  int side;  // 0 = front/right, 1 = back/left

  rSide_c *partner;

  merge_segment_c *seg;

  double x1, y1;
  double x2, y2;

  std::vector<rFace_c *> faces;

public:
  rSide_c(merge_segment_c * _seg = NULL, int _side = 0) :
      side(_side), seg(_seg), partner(NULL)
      f_faces(), b_faces()
  { }

  ~rSide_c()
  { }

public:
  double Length() const
  {
    return ComputeDist(x1,y1, x2,y2);
  }

  void AddFace(int kind, int gap, double z1, double z2, area_vert_c *av)
  {
    rFace_c *F = rFaceFactory_c::NewFace(kind, gap, z1, z2, av);

    faces.push_back(F);
  }
};


class rSideFactory_c
{
  static std::list<rSide_c> all_sides;

public:
  static rSide_c *NewSide(merge_segment_c *seg, int side)
  {
    all_sides.push_back(rSide_c(seg, side));

    rSide_c *S = &all_sides.back();

    S->x1 = seg->start->x;  S->x2 = seg->end->x;
    S->y1 = seg->start->y;  S->y2 = seg->end->y;

    return S;
  }

  static rSide_c *SplitAt(rSide_c *S, double new_x, double new_y)
  {
    rSide_c *T = NewSide(S->seg, int S->side);
    
    S->x2 = new_x;
    S->y2 = new_y;

    T->x1 = new_x;
    T->y1 = new_y;

    return T;
  }

  static rSide_c *FakePartition(double x, double y, double dx, double dy)
  {
    rSide_c * S = NewSide(NULL);

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
std::list<rFace_c> rFaceFactory_c::all_faces;


#define CONTENT__NODE  12345


class rNode_c
{
public:
  /* LEAF STUFF */

  int lf_contents;

  std::vector<rSide_c *> sides;

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

  rNode_c *front;  // front space
  rNode_c *back;   // back space


  /* COMMON STUFF */

  std::vector<rFace_c *> faces;

  int index;

public:
  // LEAF
  rNode_c() : lf_contents(CONTENTS_EMPTY), sides(), region(NULL),
              front(NULL), back(NULL), faces(), index(-1)
  { }

  rNode_c(bool _Zsplit) : lf_contents(CONTENT__NODE), sides(), region(NULL),
                          z_splitter(_Zsplit), z(0),
                          x(0), y(0), dx(0), dy(0),
                          front(NULL), back(NULL), faces()
                          index(-1)
  { }

  ~cpNode_c()
  {
    if (front && front != SOLID_LEAF) delete front;
    if (back  && back  != SOLID_LEAF) delete back;
  }

  inline bool IsNode()  const { return lf_contents == CONTENT__NODE; }
  inline bool IsLeaf()  const { return lf_contents != CONTENT__NODE; }
  inline bool IsSolid() const { return lf_contents == CONTENTS_SOLID; }

  void AddSide(cpSide_c *S)
  {
    sides.push_back(S);
  }

//--  void Flip()
//--  {
//--    SYS_ASSERT(! z_splitter);
//--
//--    rNode_c *tmp = front; front = back; back = tmp;
//--
//--    dx = -dx;
//--    dy = -dy;
//--  }

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


static rNode_c *SOLID_LEAF;


static void DoAddFace(rSide_c *S, int gap, double z1, double z2,
                      area_vert_c *av)
{
  SYS_ASSERT(z2 > z1);

  // make sure face height does not exceed the limit
  if (z2 - z1 > FACE_MAX_SIZE)
  {
    int num = 1 + (int)floor((z2 - z1) / (double)FACE_MAX_SIZE);

///fprintf(stderr, "Splitting tall face (%1.0f .. %1.0f) into %d pieces\n", z1, z2, num);

    SYS_ASSERT(num >= 2);

    for (int i = 0; i < num; i++)
    {
      double nz1 = z1 + (z2 - z1) *  i    / (double)num;
      double nz2 = z1 + (z2 - z1) * (i+1) / (double)num;

      S->AddFace(rFace_c::WALL, gap, nz1, nz2, av);
    }
  }
  else
  {
    S->AddFace(rFace_c::WALL, gap, z1, z2, av);
  }
}

static void CreateSide(rNode_c *LEAF, merge_segment_c *seg, int side)
{
  rSide_c *S = rSideFactory_c::NewSide(seg, side);

  LEAF->AddSide(S);

  // create the faces
  merge_region_c *R  = (side == 0) ? seg->front : seg->back;
  merge_region_c *RX = (side == 0) ? seg->back  : seg->front;

  for (unsigned int k = 0; k < R->gaps.size(); k++)
  {
    merge_gap_c *G = R->gaps[k];

    double z1 = G->GetZ1();
    double z2 = G->GetZ2();

    // emergency fallback
    if (RX == NULL)
    {
      DoAddFace(S, k, z1, z2, CSG2_FindSideVertex(seg, (z1+z2)/2.0, (side==0)));
      continue;
    }

    // complex case: compare with solids on other side

    for (int m = 0; m <= (int)RX->gaps.size(); m++)
    {
      double sz1 = (m == 0) ? -9e6 : RX->gaps[m-1]->GetZ2();
      double sz2 = (m == RX->gaps.size()) ? +9e6 : RX->gaps[m]->GetZ1();

      if (sz1 < z1) sz1 = z1;
      if (sz2 > z2) sz2 = z2;

      if (sz2 < sz1 + 0.99)  // don't create tiny faces
        continue;

      DoAddFace(S, k, sz1, sz2, CSG2_FindSideVertex(seg, (sz1+sz2)/2.0, (side==0)));
    }
  }
}

static rNode_c * NewLeaf(int contents)
{
  rNode_c *leaf = new rNode_c();

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
      return SOLID_LEAF;
    else
      return NewLeaf(CONTENTS_EMPTY);
  }


  {
    rNode_c *node = new cpNode_c(true /* z_splitter */);

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


static void GrabFaces(rNode_c *part, rSide_c *S, rNode_c *FRONT, rNode_c *BACK)
{
  double a = (S->x2 - S->x1) * part->dx + (S->y2 - S->y1) * part->dy;

  int p_side = (a >= 0) ? 0 : 1;

  for (unsigned int i = 0; i < S->faces.size(); i++)
  {
    rFace_c *F = S->faces[i];

    part->faces.push_back(F);

    if (p_side == S->side)
      FRONT->faces.push_back(F);
    else
      BACK->faces.push_back(F);
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

  std::vector<cpSide_c *>::iterator SI;

  for (SI = LEAF->sides.begin(); SI != LEAF->sides.end(); SI++)
  {
    cpSide_c *S = *SI;

    // get state of lines' relation to each other
    double a = PerpDist(S->x1, S->y1, px1, py1, px2, py2);
    double b = PerpDist(S->x2, S->y2, px1, py1, px2, py2);

    double fa = fabs(a);
    double fb = fabs(b);

    if (fa <= Q_EPSILON && fb <= Q_EPSILON)
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

    if (fa <= Q_EPSILON || fb <= Q_EPSILON)
    {
      // partition passes through one vertex

      if ( ((fa <= Q_EPSILON) ? b : a) >= 0 )
        front++;
      else
        back++;

      continue;
    }

    if (a > 0 && b > 0)
    {
      front++;
      continue;
    }

    if (a < 0 && b < 0)
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


static void Split_XY(rNode_c *part, rNode_c *FRONT, rNode_c *BACK)
{
  std::vector<rSide_c *> all_sides;

  all_sides.swap(FRONT->sides);

  FRONT->region = NULL;


  for (int k = 0; k < (int)all_sides.size(); k++)
  {
    rSide_c *S = all_sides[k];

    double sdx = S->x2 - S->x1;
    double sdy = S->y2 - S->y1;

    // get state of lines' relation to each other
    double a = PerpDist(S->x1, S->y1,
                        part->x, part->y,
                        part->x + part->dx, part->y + part->dy);

    double b = PerpDist(S->x2, S->y2,
                        part->x, part->y,
                        part->x + part->dx, part->y + part->dy);

    double fa = fabs(a);
    double fb = fabs(b);

    if (fa <= Q_EPSILON && fb <= Q_EPSILON)
    {
      // side sits on the partition : DROP IT
      
      if (S->seg)
        GrabFaces(part, S, FRONT, BACK);

      continue;
    }

    if (fa <= Q_EPSILON || fb <= Q_EPSILON)
    {
      // partition passes through one vertex

      if ( ((fa <= Q_EPSILON) ? b : a) >= 0 )
        FRONT->AddSide(S);
      else
        BACK->AddSide(S);

      continue;
    }

    if (a > 0 && b > 0)
    {
      FRONT->AddSide(S);
      continue;
    }

    if (a < 0 && b < 0)
    {
      BACK->AddSide(S);
      continue;
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
  }
}


static rSide_c * FindPartition(rNode_c * LEAF)
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


static rNode_c * XY_SegSide(merge_segment_c *SEG, int side)
{
  SYS_ASSERT(SEG);

  if (side == 0)
  {
    if (SEG->front && SEG->front->gaps.size() > 0)
      return Partition_Z(SEG->front);
    else
      return SOLID_LEAF;
  }
  else
  {
    if (SEG->back && SEG->back->gaps.size() > 0)
      return Partition_Z(SEG->back);
    else
      return SOLID_LEAF;
  }
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

  rNode_c * BACK = new rNode_c();

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


//------------------------------------------------------------------------

static dmodel_t model;

qLump_c *q1_nodes;
qLump_c *q1_leafs;
qLump_c *q1_faces;

static qLump_c *q_mark_surfs;
static qLump_c *q_surf_edges;
static qLump_c *q_clip_nodes;

int q1_total_nodes;
int q1_total_mark_surfs;
int q1_total_surf_edges;


void Q1_AddEdge(double x1, double y1, double z1,
                double x2, double y2, double z2,
                dface_t *face, dleaf_t *raw_lf = NULL)
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

  face->numedges += 1;


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


static int CollectClockwiseVerts(float *vert_x, float *vert_y, qLeaf_c *leaf, bool anticlock)
{
  int v_num = 0;

  std::list<qSide_c *>::iterator SI;

  double mid_x = 0;
  double mid_y = 0;
  

  for (SI = leaf->sides.begin(); SI != leaf->sides.end(); SI++, v_num++)
  {
    qSide_c *S = *SI;

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

static void MakeFloorFace(qFace_c *F, dface_t *face)
{
  qLeaf_c *leaf = F->floor_leaf;
  SYS_ASSERT(leaf);

  merge_region_c *R = leaf->GetRegion();
  SYS_ASSERT(R);

  merge_gap_c *gap = R->gaps.at(F->gap);

  double z1 = gap->GetZ1();
  double z2 = gap->GetZ2();

  double z = (F->kind == qFace_c::CEIL) ? z2 : z1;
///fprintf(stderr, "MakeFloorFace: F=%p kind:%d @ z:%1.0f\n", F, F->kind, z);


  bool is_ceil = (F->kind == qFace_c::CEIL) ? true : false;
  bool flipped;

  face->planenum = BSP_AddPlane(0, 0, z,
                                0, 0, is_ceil ? -1 : +1, &flipped);

  face->side = flipped ? 1 : 0;

  const char *texture = is_ceil ? gap->CeilTex() : gap->FloorTex();

  int flags = CalcTextureFlag(texture);

  double s[4] = { 1.0, 0.0, 0.0, 0.0 };
  double t[4] = { 0.0, 1.0, 0.0, 0.0 };

  face->texinfo = Q1_AddTexInfo(texture, flags, s, t);

  face->styles[0] = 0xFF;  // no lightmap
  face->styles[1] = 0xFF;
  face->styles[2] = 0xFF;
  face->styles[3] = 0xFF;

  face->lightofs = -1;  // no lightmap

  // collect the vertices and sort in clockwise order

  float vert_x[256];
  float vert_y[256];

  int v_num = CollectClockwiseVerts(vert_x, vert_y, leaf, flipped);

  double min_x = +9e9; double max_x = -9e9;
  double min_y = +9e9; double max_y = -9e9;


  // add the edges

  face->firstedge = q1_total_surf_edges;
  face->numedges  = 0;

  for (int pos = 0; pos < v_num; pos++)
  {
    int p2 = (pos + 1) % v_num;

    Q1_AddEdge(vert_x[pos], vert_y[pos], z,
               vert_x[p2 ], vert_y[p2 ], z, face);

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
    face->styles[0] = 0; // (foo & 3); //!!!!!

    face->lightofs = 100; //!!!! Quake1_LightAddBlock(ext_W, ext_H, rand()&0x7F);
  }
}

static void MakeWallFace(qFace_c *F, dface_t *face)
{
  qSide_c *S = F->side;

  merge_region_c *R = S->GetRegion();
  SYS_ASSERT(R);

///  merge_gap_c *gap = R->gaps.at(F->gap);

  double z1 = F->z1;
  double z2 = F->z2;


  bool flipped;

  face->planenum = BSP_AddPlane(S->x1, S->y1, 0,
                                (S->y2 - S->y1), (S->x1 - S->x2), 0,
                                &flipped);

  face->side = flipped ? 1 : 0;
  
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

  face->texinfo = Q1_AddTexInfo(texture, flags, s, t);

  face->styles[0] = 0xFF;  // no lightmap
  face->styles[1] = 0xFF;
  face->styles[2] = 0xFF;
  face->styles[3] = 0xFF;

  face->lightofs = -1;  // no lightmap

  // add the edges

  face->firstedge = q1_total_surf_edges;
  face->numedges  = 0;

  Q1_AddEdge(S->x1, S->y1, z1,  S->x1, S->y1, z2,  face);
  Q1_AddEdge(S->x1, S->y1, z2,  S->x2, S->y2, z2,  face);
  Q1_AddEdge(S->x2, S->y2, z2,  S->x2, S->y2, z1,  face);
  Q1_AddEdge(S->x2, S->y2, z1,  S->x1, S->y1, z1,  face);

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
    face->styles[0] = 0; // (foo & 3); //!!!!!

    face->lightofs = 100; //!!!! Quake1_LightAddBlock(ext_W, ext_H, 0x80|(rand()&0x7F));
  }
}

static void MakeFace(qFace_c *F, qNode_c *N)
{
  SYS_ASSERT(F->index < 0);


  dface_t face;

  if (F->kind == qFace_c::WALL)
    MakeWallFace(F, &face);
  else
    MakeFloorFace(F, &face);


  // FIXME: fix endianness in face

  u16_t index = model.numfaces++;

  if (index >= MAX_MAP_FACES)
    Main_FatalError("Quake1 build failure: exceeded limit of %d FACES\n",
                    MAX_MAP_FACES);

  F->index = (int)index;

  q1_faces->Append(&face, sizeof(face));
}


static s16_t WriteLeaf(rNode_c *LEAF, dnode_t *parent)
{
  if (leaf == SOLID_LEAF)
    return -1;


  dleaf_t raw_lf;

  raw_lf.contents = leaf->contents;
  raw_lf.visofs   = -1;  // no visibility info

  int b;

  raw_lf.mins[0] = I_ROUND(leaf->min_x)-16;
  raw_lf.mins[1] = I_ROUND(leaf->min_y)-16;
  raw_lf.mins[2] = -2000;  //!!!!

  raw_lf.maxs[0] = I_ROUND(leaf->max_x)+16;
  raw_lf.maxs[1] = I_ROUND(leaf->max_y)+16;
  raw_lf.maxs[2] = 2000;  //!!!!

  memset(raw_lf.ambient_level, 0, sizeof(raw_lf.ambient_level));

  raw_lf.first_marksurf = q1_total_mark_surfs;
  raw_lf.num_marksurf   = 0;


  // make faces
  for (unsigned int n = 0; n < LEAF->faces.size(); n++)
  {
    rFace_c *F = leaf->faces[n];

    // should have been in a node already
    SYS_ASSERT(F->index >= 0);

    Q1_AddSurf(F->index, &raw_lf);
  }

  // ???  probably should just put into leaf->faces array 
  SYS_ASSERT(leaf->floor->index >= 0);
  SYS_ASSERT(leaf-> ceil->index >= 0);

  Q1_AddSurf(leaf->floor->index, &raw_lf);
  Q1_AddSurf(leaf-> ceil->index, &raw_lf);


  for (b = 0; b < 3; b++)
  {
    parent->mins[b] = MIN(parent->mins[b], raw_lf.mins[b]);
    parent->maxs[b] = MAX(parent->maxs[b], raw_lf.maxs[b]);
  }


  // FIXME: fix endianness in raw_lf

  s32_t index = model.visleafs++;

  if (index >= MAX_MAP_LEAFS)
    Main_FatalError("Quake1 build failure: exceeded limit of %d LEAFS\n",
                    MAX_MAP_LEAFS);

  q1_leafs->Append(&raw_lf, sizeof(raw_lf));

  return -(index+2);  // index+2 because the first leaf is SOLID
}


static s32_t RecursiveMakeNodes(qNode_c *node, dnode_t *parent)
{
  dnode_t raw_nd;

  int b;
  bool flipped;

  if (node->z_splitter)
    raw_nd.planenum = BSP_AddPlane(0, 0, node->z,
                                   0, 0, (node->z_splitter==2) ? -1 : +1, &flipped);
  else
    raw_nd.planenum = BSP_AddPlane(node->x, node->y, 0,
                                   node->dy, -node->dx, 0, &flipped);
  if (flipped)
    node->Flip();


  raw_nd.firstface = 0;
  raw_nd.numfaces  = 0;

  raw_nd.mins[0] = I_ROUND(node->min_x)-32;
  raw_nd.mins[1] = I_ROUND(node->min_y)-32;
  raw_nd.mins[2] = -2000;  //!!!!

  raw_nd.maxs[0] = I_ROUND(node->max_x)+32;
  raw_nd.maxs[1] = I_ROUND(node->max_y)+32;
  raw_nd.maxs[2] = 2000;  //!!!!


  // make faces [NOTE: must be done before recursing down]
  for (unsigned int j = 0; j < node->faces.size(); j++)
  {
    qFace_c *F = node->faces[j];

///fprintf(stderr, "node face: %p kind:%d (node %1.4f,%1.4f += %1.4f,%1.4f)\n",
///        F, F->kind, node->x, node->y, node->dx, node->dy);

    SYS_ASSERT(F->index < 0);

    MakeFace(F, node);

    SYS_ASSERT(F->index >= 0);

    if (j == 0)
      raw_nd.firstface = F->index;
    
    raw_nd.numfaces++;
  }


  if (node->front_n)
    raw_nd.children[0] = RecursiveMakeNodes(node->front_n, &raw_nd);
  else
    raw_nd.children[0] = MakeLeaf(node->front_l, &raw_nd);

  if (node->back_n)
    raw_nd.children[1] = RecursiveMakeNodes(node->back_n, &raw_nd);
  else
    raw_nd.children[1] = MakeLeaf(node->back_l, &raw_nd);


  if (parent)
  {
    for (b = 0; b < 3; b++)
    {
      parent->mins[b] = MIN(parent->mins[b], raw_nd.mins[b]);
      parent->maxs[b] = MAX(parent->maxs[b], raw_nd.maxs[b]);
    }
  }


  s32_t index = q1_total_nodes++;

  // FIXME: fix endianness in raw_nd

  q1_nodes->Append(&raw_nd, sizeof(raw_nd));

  return index;
}


static void AssignIndexes(rNode_c *node, int *idx_var)
{
  node->index = *idx_var;

  (*idx_var) += 1;

  if (node->front->IsNode())
    AssignIndexes(node->front, idx_var);

  if (node->back->IsNode())
    AssignIndexes(node->back, idx_var);

  // FIXME node bounding box

}


static void WriteClipNodes(qLump_c *L, rNode_c *node)
{
  dnode_t raw_nd;

  bool flipped;

  if (node->z_splitter)
    clip.planenum = BSP_AddPlane(0, 0, node->z, 0, 0, 1, &flipped);
  else
    clip.planenum = BSP_AddPlane(node->x, node->y, 0,
                                 node->dy, -node->dx, 0, &flipped);

  node->CheckValid();

  raw_nd.children[0] = (u16_t) node->front->index;
  raw_nd.children[1] = (u16_t) node->back ->index;

  if (flipped)
  {
    u16_t tmp = raw_nd.children[0];
    raw_nd.children[0] = raw_nd.children[1];
    raw_nd.children[1] = tmp;
  }


  // TODO: fix endianness in 'raw_nd'

  L->Append(&raw_nd, sizeof(raw_nd));


  // recurse now, AFTER adding the current node

  if (node->front->IsNode())
    WriteClipNodes(L, node->front);

  if (node->back->IsNode())
    WriteClipNodes(L, node->back);
}


static void CreateSolidLeaf(void)
{
  dleaf_t raw_lf;

  memset(&raw_lf, 0, sizeof(raw_lf));

  raw_lf.contents = CONTENTS_SOLID;
  raw_lf.visofs   = -1;  // no visibility info

  q1_leafs->Append(&raw_lf, sizeof(raw_lf));
}


void Q1_BuildBSP( void )
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


  R_ROOT = Partition_XY(C_LEAF);

  SYS_ASSERT(R_ROOT->IsNode());
}


void Q1_CreateModel(void)
{
  Q1_BuildBSP();

  qLump_c *lump = BSP_NewLump(LUMP_MODELS);

  memset(&model, 0, sizeof(model));

  q1_total_nodes = 0;
  q1_total_mark_surfs = 0;
  q1_total_surf_edges = 0;

  q1_nodes = BSP_NewLump(LUMP_NODES);
  q1_leafs = BSP_NewLump(LUMP_LEAFS);
  q1_faces = BSP_NewLump(LUMP_FACES);

  q_mark_surfs = BSP_NewLump(LUMP_MARKSURFACES);
  q_surf_edges = BSP_NewLump(LUMP_SURFEDGES);

  CreateSolidLeaf();

///---  RecursiveMakeNodes(Q_ROOT, NULL /* parent */);

  AssignIndexes(R_ROOT, &q1_total_nodes);

  if (q1_total_nodes >= MAX_MAP_NODES)
    Main_FatalError("Quake1 build failure: exceeded limit of %d NODES\n",
                    MAX_MAP_NODES);

  WriteClipNodes(q1_nodes, R_ROOT);


  // set model bounding box
  double min_x, min_y, min_z;
  double max_x, max_y, max_z;

  CSG2_GetBounds(min_x, min_y, min_z,  max_x, max_y, max_z);

  model.mins[0] = min_x;  model.maxs[0] = max_x;
  model.mins[1] = min_y;  model.maxs[1] = max_y;
  model.mins[2] = min_z;  model.maxs[2] = max_z;

  model.origin[0] = 0;
  model.origin[1] = 0;
  model.origin[2] = 0;


  // clipping hulls
  q_clip_nodes = BSP_NewLump(LUMP_CLIPNODES);

  model.headnode[0] = 0; // root of drawing BSP
  model.headnode[1] = Q1_CreateClipHull(1, q_clip_nodes);
  model.headnode[2] = Q1_CreateClipHull(2, q_clip_nodes);
  model.headnode[3] = Q1_CreateClipHull(3, q_clip_nodes);


  // FIXME: fix endianness in model

  lump->Append(&model, sizeof(model));

  Q1_CreateSubModels(lump, model.numfaces, model.visleafs);
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
