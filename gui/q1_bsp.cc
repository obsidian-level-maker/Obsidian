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

#include "q1_structs.h"

#include "g_glbsp.h"
#include "g_image.h"
#include "g_lua.h"

#include "main.h"


// TODO


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
 
public:
  qSide_c(merge_segment_c * _seg, int _side) : seg(_seg), side(_side)
  { }

  ~qSide_c()
  { }

  merge_region_c *GetRegion() const
  {
    return (side == 0) ? seg->front : seg->back;
  }

};


class qLeaf_c
{
public:
  int contents;

  std::vector<qFace_c *> faces;

  std::list<qSide_c *> sides;

  double min_x, min_y;
  double max_x, max_y;

public:
  qLeaf_c() : contents(CONTENTS_EMPTY), faces(), sides(),
              min_x(0), min_y(0), max_x(0), max_y(0)
  { }

  ~qLeaf_c()
  {
    // TODO: delete faces and sides
  }

  void AddSide(merge_segment_c *_seg, int _side)
  {
    sides.push_back(new qSide_c(_seg, _side));
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
    // FIXME : ComputeBBox
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
  // true if this node splits the tree by Z (with a horizontal plane)
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


static void Split_Z(qNode_c *node, qLeaf_c *leaf)
{
  merge_region_c *R = leaf->GetRegion();
  SYS_ASSERT(R && R->gaps.size() > 1);

  unsigned int gap = R->gaps.size() / 2;

  // choose height halfway between the two gaps (in the solid)
  node->z = (R->gaps[gap-1]->GetZ2() + R->gaps[gap]->GetZ1()) / 2.0;

  // FIXME !!!!!
}

static qNode_c * PartitionZ(qLeaf_c *leaf)
{
  qNode_c *node = new qNode_c(true /* z_splitter */);

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

  return node;
}


static int EvaluatePartition(qLeaf_c *leaf, qSide_c *p, int best_n)
{
  // FIXME:  EvaluatePartition
  
}

static void FindPartitionXY(qNode_c *node, qLeaf_c *leaf)
{
  std::list<qSide_c *>::iterator SI;

  int best_n = 0;
  qSide_c *best_S = NULL;

  int count = 0;

  for (SI = leaf->sides.begin(); SI != leaf->sides.end(); SI++)
  {
    qSide_c *S = *SI;

    count++;

    // Optimisation: skip the back sides of segments, since there
    // is always a corresponding front side (except when they've
    // been separated by a partition line, and in that case it
    // can never be a valid partition candidate).
#if 1
    if (S->side != 0)
      continue;
#endif

    // TODO: skip sides that lie on the same vertical plane

    int niceness = EvaluatePartition(leaf, S, best_n);

    if (niceness < 0)  // either invalid or not as good
      continue;

    best_n = niceness;
    best_S = S;
  }

  if (! best_S)
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

  node->x = best_S->seg->start->x;
  node->y = best_S->seg->start->y;

  node->dx = best_S->seg->end->x - node->x;
  node->dy = best_S->seg->end->y - node->y;
}

static void Split_XY(qNode_c *node, qLeaf_c *leaf)
{
  // FIXME !!!!!
}

static qNode_c * PartitionXY(qLeaf_c *leaf)
{
  qNode_c *node = new qNode_c(false /* z_splitter */);

  FindPartitionXY(node, leaf);

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
