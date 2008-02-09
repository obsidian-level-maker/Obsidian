//------------------------------------------------------------------------
//  LEVEL building - QUAKE 1 BSP
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
#include "hdr_ui.h"

#include "lib_file.h"
#include "lib_util.h"

#include "csg_poly.h"
#include "csg_doom.h"
#include "csg_quake.h"

#include "g_glbsp.h"
#include "g_image.h"
#include "g_lua.h"

#include "q1_main.h"
#include "q1_structs.h"

#include "main.h"



class qFace_c
{
public:
  int foo;
 
public:
   qFace_c(  ) { }
  ~qFace_c() { }
};


class qSide_c
{
public:
  merge_segment_c *seg;

  int side;  // 0 is front, 1 is back

  double x1, y1;
  double x2, y2;
 
public:
  qSide_c(merge_segment_c * _seg, int _side) : seg(_seg), side(_side)
  {
    x1 = seg->start->x;
    y1 = seg->start->y;

    x2 = seg->end->x;
    y2 = seg->end->y;
  }

  ~qSide_c()
  { }

private:
  qSide_c(const qSide_c *other, double new_x, double new_y) :
          seg(other->seg), side(other->side),
          x1(new_x), y1(new_y),
          x2(other->x2), y2(other->y2)
  { }

public:
  merge_region_c *GetRegion() const
  {
    return (side == 0) ? seg->front : seg->back;
  }

  qSide_c *SplitAt(double new_x, double new_y)
  {
    qSide_c *T = new qSide_c(this, new_x, new_y);

    x2 = new_x;
    y2 = new_y;

    return T;
  }
};


class qLeaf_c
{
public:
  int contents;

  std::vector<qFace_c *> faces;

  std::list<qSide_c *> sides;

  // Note: qSide_c objects are shared when gap > 0

  int gap;

  double min_x, min_y;
  double max_x, max_y;

public:
  qLeaf_c() : contents(CONTENTS_EMPTY), faces(), sides(),
              gap(0), min_x(0), min_y(0), max_x(0), max_y(0)
  { }

  ~qLeaf_c()
  {
    // TODO: delete faces and sides
  }

  qLeaf_c(qLeaf_c& other, int _gap) :
          contents(other.contents), faces(), sides(), gap(_gap),
          min_x(other.min_x), min_y(other.min_y),
          max_x(other.max_x), max_y(other.max_y)
  {
    // copy the side pointers
    std::list<qSide_c *>::iterator SI;

    for (SI = other.sides.begin(); SI != other.sides.end(); SI++)
      sides.push_back(*SI);
  }

  void AddSide(merge_segment_c *_seg, int _side)
  {
    sides.push_back(new qSide_c(_seg, _side));
fprintf(stderr, "Side #%p : seg (%1.0f,%1.0f) - (%1.0f,%1.0f) side:%d\n",
         sides.back(),
         _seg->start->x, _seg->start->y,
         _seg->end->x, _seg->end->y, _side);
  }


  merge_region_c *GetRegion() const
  {
    // NOTE: assumes a convex leaf (in XY) !!
    SYS_ASSERT(! sides.empty());

    qSide_c *S = *sides.begin();

    return S->GetRegion();
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

  bool IsConvex_XY()
  {
    // Requirements for Convexicity:
    // 1. all sides look into the same region
    // 2. all sides are connected (no separate parts)
    // 3. angle between any two connected sides <= 180 degrees.

    std::list<qSide_c *>::iterator SI;

    merge_region_c *R = NULL;

    for (SI = sides.begin(); SI != sides.end(); SI++)
    {
      qSide_c *S = *SI;

      merge_region_c *cur_R = S->GetRegion();
      SYS_ASSERT(cur_R);

      if (! R)
      {
        R = cur_R;
        continue;
      }

      if (R != cur_R)
        return false;
    }

    // OK, all sides belong to the same region.

    // Now rearrange sides in the list so they are contiguous
    // (winding in an anti-clockwise direction).
    // If any are left over, then requirement #2 is not satisfied.
    // Early out if any angle is > 180 degrees.

    // FIXME !!!!!!

    return true;
  }

  bool IsConvex_Z()
  {
    SYS_ASSERT(! sides.empty());

    qSide_c *first = * sides.begin();

    merge_region_c *R = first->GetRegion();

    return (R->gaps.size() <= 1);
  }
};


class qNode_c
{
public:
  // true if this node splits the tree by Z
  // (with a horizontal upward-facing plane, i.e. dz = 1).
  bool z_splitter;

  double z;

  // normal splitting planes are vertical, and here are the
  // coordinates on the map.
  double x,  y;
  double dx, dy;

  qLeaf_c *front_l;  // front space : one of these is non-NULL
  qNode_c *front_n;

  qLeaf_c *back_l;   // back space : one of these is non-NULL
  qNode_c *back_n;

public:
  qNode_c(bool _Zsplit) : z_splitter(_Zsplit), z(0),
                          x(0), y(0), dx(0), dy(0),
                          front_l(NULL), front_n(NULL),
                          back_l(NULL),  back_n(NULL)
  { }

  ~qNode_c()
  {
    if (front_l) delete front_l;
    if (front_n) delete front_n;

    if (back_l) delete back_l;
    if (back_n) delete back_n;
  }

};


static inline double PerpDist(double x, double y,
                              double x1, double y1, double x2, double y2)
{
  x  -= x1; y  -= y1;
  x2 -= x1; y2 -= y1;

  double len = sqrt(x2*x2 + y2*y2);

  SYS_ASSERT(len > 0);

  return (x * y2 - y * x2) / len;
}


///---static void Split_Z(qNode_c *node, qLeaf_c *leaf)
///---{
///---
///---  unsigned int gap = R->gaps.size() / 2;
///---
///---
///---  node->front_l = leaf;
///---  node->back_l  = new qLeaf_c;
///---
///---  // FIXME !!!!!
///---}

static qNode_c * PartitionZ(qLeaf_c *leaf)
{
  merge_region_c *R = leaf->GetRegion();

  SYS_ASSERT(R && R->gaps.size() > 1);

  
  qLeaf_c ** leaf_list = new qLeaf_c* [R->gaps.size()];
  qNode_c ** node_list = new qNode_c* [R->gaps.size()-1];

  leaf_list[0] = leaf;

  for (int gap = 1; gap < (int)R->gaps.size(); gap++)
  {
    leaf_list[gap]   = new qLeaf_c(*leaf, gap);
    node_list[gap-1] = new qNode_c(true /* z_splitter */);
  }

  // TODO: produce a well balanced tree

  for (int gap = 1; gap < (int)R->gaps.size(); gap++)
  {
    qNode_c *n = node_list[gap-1];

    // choose height halfway between the two gaps (in the solid)
    n->z = (R->gaps[gap-1]->GetZ2() + R->gaps[gap]->GetZ1()) / 2.0;

    n->back_l = leaf_list[gap-1];

    if (gap < (int)R->gaps.size()-1)
      n->front_n = node_list[gap];
    else
      n->front_l = leaf_list[gap];
  } 

#if 0 // OLD CODE
  Split_Z(node, leaf);

  if (! node->front_l->IsConvex_Z())
  {
    node->front_n = PartitionZ(node->front_l);
    node->front_l = NULL;
  }

  if (! node->back_l->IsConvex_Z())
  {
    node->back_n = PartitionZ(node->back_l);
    node->back_l = NULL;
  }
#endif

  qNode_c *node = node_list[0];

  delete[] leaf_list;
  delete[] node_list;

  return node;
}


static int EvaluatePartition(qLeaf_c *leaf, qSide_c *part)
{
  std::list<qSide_c *>::iterator SI;

  int back   = 0;
  int front  = 0;
  int splits = 0;

  for (SI = leaf->sides.begin(); SI != leaf->sides.end(); SI++)
  {

    qSide_c *S = *SI;

    // get state of lines' relation to each other
    double a = PerpDist(S->x1, S->y1,
                        part->x1, part->y1, part->x2, part->y2);

    double b = PerpDist(S->x2, S->y2,
                        part->x1, part->y1, part->x2, part->y2);

    double fa = fabs(a);
    double fb = fabs(b);

    if (fa <= Q_EPSILON && fb <= Q_EPSILON)
    {
      // lines are colinear

      double pdx = part->x2 - part->x1;
      double pdy = part->y2 - part->y1;

      double sdx = S->x2 - S->x1;
      double sdy = S->y2 - S->y1;

      if ( ((pdx * sdx + pdy * sdy < 0.0) ? 1 : 0) == S->side)
        front++;
      else
        back++;

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

  if (front == 0 || back == 0)
    return -1;

  // calculate heuristic
  int diff = ABS(front - back);

  return (splits * splits * 20 + diff * 100) / (front + back);
}


static void FindPartitionXY(qNode_c *node, qLeaf_c *leaf)
{
  std::list<qSide_c *>::iterator SI;

  int best_c = 99999;
  qSide_c *best_p = NULL;

  int count = 0;

  for (SI = leaf->sides.begin(); SI != leaf->sides.end(); SI++)
  {
    qSide_c *part = *SI;

    count++;

    // Optimisation: skip the back sides of segments, since there
    // is always a corresponding front side (except when they've
    // been separated by a partition line, and in that case it
    // can never be a valid partition candidate).
#if 1
    if (part->side != 0)
      continue;
#endif

    // TODO: skip sides that lie on the same vertical plane

    int cost = EvaluatePartition(leaf, part);

    if (cost < 0)  // not a potential candidate
      continue;

    if (! best_p || cost < best_c)
    {
      best_c = cost;
      best_p = part;
    }
  }

  if (! best_p)
  {
    // this is quite possible for the root node of the simplest
    // possible map, otherwise it is a serious error because the
    // IsConvex_XY() must have told us the area was not convex.
    //
    // TODO: take action in the serious case

    fprintf(stderr, "FindPartitionXY: cannot find any splitter (in %d sides).\n", count);

    leaf->ComputeBBox();

    node->x = (leaf->min_x + leaf->max_x) / 2.0;
    node->y = leaf->min_y;

    node->dx = 0;
    node->dy = leaf->max_y - leaf->min_y;

    return;
  }

  node->x = best_p->x1;
  node->y = best_p->y1;

  node->dx = best_p->x2 - node->x;
  node->dy = best_p->y2 - node->y;
}


static void Split_XY(qNode_c *part, qLeaf_c *leaf)
{
  part->front_l = leaf;
  part->back_l  = new qLeaf_c;


  std::list<qSide_c *> all_sides;

  all_sides.swap(leaf->sides);

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

      if ( ((part->dx * sdx + part->dy * sdy < 0.0) ? 1 : 0) == S->side)
        part->front_l->sides.push_back(S);
      else
        part->back_l->sides.push_back(S);

      continue;
    }

    if (fa <= Q_EPSILON || fb <= Q_EPSILON)
    {
      // partition passes through one vertex

      if ( ((fa <= Q_EPSILON) ? b : a) >= 0 )
        part->front_l->sides.push_back(S);
      else
        part->back_l->sides.push_back(S);

      continue;
    }

    if (a > 0 && b > 0)
    {
      part->front_l->sides.push_back(S);
      continue;
    }

    if (a < 0 && b < 0)
    {
      part->back_l->sides.push_back(S);
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
      part-> back_l->sides.push_back(S);
      part->front_l->sides.push_back(T);
    }
    else
    {
      SYS_ASSERT(b < 0);

      part->front_l->sides.push_back(S);
      part-> back_l->sides.push_back(T);
    }
  }

for (int kk=0; kk < 2; kk++)
{
fprintf(stderr, "%s:\n", (kk==0) ? "FRONT" : "BACK");

std::list<qSide_c *>& LLL = (kk==0) ? part->front_l->sides : part->back_l->sides;
std::list<qSide_c *>::iterator LI;

  for (LI = LLL.begin(); LI != LLL.end(); LI++)
  {
    qSide_c *S = *LI;
    fprintf(stderr, "  side #%p : seg (%1.0f,%1.0f) - (%1.0f,%1.0f) side:%d\n",
             S, S->seg->start->x, S->seg->start->y,
                S->seg->end->x, S->seg->end->y, S->side);
  }
fprintf(stderr, "\n");
}

}


static qNode_c * PartitionXY(qLeaf_c *leaf)
{
  qNode_c *node = new qNode_c(false /* z_splitter */);

  FindPartitionXY(node, leaf);

fprintf(stderr, "Using partition (%1.0f,%1.0f) vec:(%1.2f,%1.2f)\n",
                 node->x, node->y, node->dx, node->dy);


  Split_XY(node, leaf);

  if (! node->front_l->IsConvex_XY())
  {
    node->front_n = PartitionXY(node->front_l);
    node->front_l = NULL;
  }
  else if (! node->front_l->IsConvex_Z())
  {
    node->front_n = PartitionZ(node->front_l);
    node->front_l = NULL;
  }

  if (! node->back_l->IsConvex_XY())
  {
    node->back_n = PartitionXY(node->back_l);
    node->back_l = NULL;
  }
  else if (! node->back_l->IsConvex_Z())
  {
    node->back_n = PartitionZ(node->back_l);
    node->back_l = NULL;
  }

  return node;
}


///---static void PartitionZ(qNode_c *node)
///---{
///---  if (node->front_n)
///---  {
///---    PartitionZ(node->front_n);
///---  }
///---  else if (! node->front_l->IsConvex_Z())
///---  {
///---    node->front_n = PartitionZ_Leaf(node->front_l);
///---    node->front_l = NULL;
///---  }
///---
///---  if (node->back_n)
///---  {
///---    PartitionZ(node->back_n);
///---  }
///---  else if (! node->back_l->IsConvex_Z())
///---  {
///---    node->back_n = PartitionZ_Leaf(node->back_l);
///---    node->back_l = NULL;
///---  }
///---}



//------------------------------------------------------------------------

void Quake1_BuildBSP( void )
{
  // INPUTS:
  //   all the stuff created by CSG_MergeAreas
  //
  // OUTPUTS:
  //   a BSP tree consisting of nodes, leaves and faces

  // ALGORITHM:
  //   1. create a qSide list from every segment
  //   2. while list is not yet convex:
  //      (a) find a splitter side --> create qNode
  //      (b) split list into front and back
  //      (c) recursively handle front/back lists
  //   3. perform Z splitting

  qLeaf_c *begin = new qLeaf_c();

  for (unsigned int i = 0; i < mug_segments.size(); i++)
  {
    merge_segment_c *S = mug_segments[i];

    if (S->front && S->front->gaps.size() > 0)
      begin->AddSide(S, 0);

    if (S->back && S->back->gaps.size() > 0)
      begin->AddSide(S, 1);
  }

  // NOTE WELL: we assume at least one partition (hence at least
  //            one node).  The simplest possible map is already a
  //            convex space (no partitions are needed) so in that
  //            case we use an arbitrary splitter plane.

  qNode_c *root = PartitionXY(begin);

  
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
