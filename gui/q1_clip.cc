//------------------------------------------------------------------------
//  LEVEL building - QUAKE 1 CLIPPING HULLS
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

#include "csg_main.h"
#include "csg_quake.h"

#include "g_image.h"
#include "g_lua.h"

#include "q1_main.h"
#include "q1_structs.h"

#include "main.h"


class cpSide_c
{
public:
  merge_segment_c *seg;

  int side;  // 0 is front, 1 is back

  double x1, y1;
  double x2, y2;

  bool on_node;  // true if has been on a partition line

public:
  cpSide_c(merge_segment_c * _seg, int _side) :
      seg(_seg), side(_side), on_node(false)
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

  ~cpSide_c()
  { }

private:
  // copy constructor, used when splitting
  cpSide_c(const cpSide_c *other, double new_x, double new_y) :
           seg(other->seg), side(other->side),
           x1(new_x), y1(new_y), x2(other->x2), y2(other->y2),
           on_node(other->on_node)
  { }

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

  cpSide_c *SplitAt(double new_x, double new_y)
  {
    cpSide_c *T = new cpSide_c(this, new_x, new_y);

    x2 = new_x;
    y2 = new_y;

    return T;
  }

};


typedef std::list<cpSide_c *> cpSideList_c;


class cpNode_c
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

  cpNode_c *front_n;  // front space, NULL for leaf
  cpNode_c *back_n;   // back space,  NULL for leaf 

  int front_l;  // contents of leaf
  int back_l;   //

  int index;

public:
  cpNode_c(bool _Zsplit) : z_splitter(_Zsplit), z(0),
                          x(0), y(0), dx(0), dy(0),
                          front_n(NULL), back_n(NULL),
                          front_l(0),    back_l(0),  
                          index(-1)
  { }

  ~cpNode_c()
  {
    if (front_n) delete front_n;
    if (back_n)  delete back_n;
  }

  void Flip()
  {
    SYS_ASSERT(! z_splitter);

    cpNode_c *tmp_n = front_n; front_n = back_n; back_n = tmp_n;

    int tmp_l = front_l; front_l = back_l; back_l = tmp_l;

    dx = -dx;
    dy = -dy;
  }

  void CheckValid() const
  {
    if (! node->front_n)
    {
      SYS_ASSERT(node->front_l < 0);
    }

    if (! node->back_n)
    {
      SYS_ASSERT(node->back_l < 0);
    }
  }
};


static merge_region_c * GetLeafRegion(cpSideList_c& LEAF)
{
  // NOTE: assumes a convex leaf (in XY) !!
  cpSideList_c::iterator SI;

  for (SI = LEAF.begin(); SI != LEAF.end(); SI++)
  {
    cpSide_c *S = *SI;

    if (S->seg)
      return S->GetRegion();
  }

  Main_FatalError("INTERNAL ERROR: Clip Leaf has no solid side!");
  return NULL; /* NOT REACHED */
}


static void MarkColinearSides(cpSideList_c& LEAF,
                              double px1, double py1, double px2, double py2)
{
  // find _ALL_ sides that lie on the partition
  cpSideList_c::iterator TI;

  for (TI = LEAF.begin(); TI != LEAF.end(); TI++)
  {
    cpSide_c *T = *TI;

    if (T->on_node)
      continue;

    double a = PerpDist(T->x1, T->y1,  px1, py1, px2, py2);
    double b = PerpDist(T->x2, T->y2,  px1, py1, px2, py2);

    if (! (fabs(a) <= Q_EPSILON && fabs(b) <= Q_EPSILON))
      continue;

    T->on_node = true;
  }
}

//------------------------------------------------------------------------

static double EvaluatePartition(cpSideList_c& LEAF,
                                double px1, double py1, double px2, double py2)
{
  double pdx = px2 - px1;
  double pdy = py2 - py1;

  int back   = 0;
  int front  = 0;
  int splits = 0;

  cpSideList_c::iterator SI;

  for (SI = LEAF.begin(); SI != LEAF.end(); SI++)
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

fprintf(stderr, "CLIP PARTITION CANDIDATE (%1.0f %1.0f)..(%1.0f %1.0f) : %d|%d splits:%d\n",
        px1, py1, px2, py2, back, front, splits);


  if (front == 0 || back == 0)
    return -1;

  // calculate heuristic
  int diff = ABS(front - back);

  double cost = (diff * 100.0) / (double)(front + back);

  // preference for axis-aligned planes
  if (! (fabs(pdx) < EPSILON || fabs(pdy) < EPSILON))
    cost += 4.2;

  return cost;
}


static cpSide_c * FindPartition(cpSideList_c& LEAF)
{
  cpSideList_c::iterator SI;

  double    best_c = 9e30;
  cpSide_c *best_p = NULL;

  int count = 0;

  for (SI = LEAF.begin(); SI != LEAF.end(); SI++)
  {
    cpSide_c *part = *SI;

    count++;

    // TODO: Optimise for two-sided segments by skipping the back one

    // TODO: skip sides that lie on the same vertical plane

    double cost = EvaluatePartition(LEAF, part->x1, part->y1, part->x2, part->y2);

fprintf(stderr, "--> COST:%1.2f for %p\n", cost, part);

    if (cost < 0)  // not a potential candidate
      continue;

    if (! best_p || cost < best_c)
    {
      best_c = cost;
      best_p = part;
    }
  }
fprintf(stderr, "ALL DONE : best_c=%1.0f best_p=%p\n",
        best_p ? best_c : -9999, best_p);

  return best_p;
}


static void Split_XY(cpNode_c *part, cpSideList_c& front_l, cpSideList_c& back_l)
{
  cpSideList_c all_sides;

  all_sides.swap(front_l);


  while (! all_sides.empty())
  {
    cpSide_c *S = all_sides.front();

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
        back_l.push_back(S);
      }
      else
      {
        front_l.push_back(S);
      }

      S->on_node = true;
      continue;
    }

    if (fa <= Q_EPSILON || fb <= Q_EPSILON)
    {
      // partition passes through one vertex

      if ( ((fa <= Q_EPSILON) ? b : a) >= 0 )
        front_l.push_back(S);
      else
        back_l.push_back(S);

      continue;
    }

    if (a > 0 && b > 0)
    {
      front_l.push_back(S);
      continue;
    }

    if (a < 0 && b < 0)
    {
      back_l.push_back(S);
      continue;
    }

    /* need to split it */

    // determine the intersection point
    double along = a / (a - b);

    double ix = S->x1 + along * sdx;
    double iy = S->y1 + along * sdy;

    cpSide_c *T = S->SplitAt(ix, iy);

    if (a < 0)
    {
       back_l.push_back(S);
      front_l.push_back(T);
    }
    else
    {
      SYS_ASSERT(b < 0);

      front_l.push_back(S);
       back_l.push_back(T);
    }
  }
}


static cpNode_c * Partition_Gap(cpSideList_c& LEAF, merge_region_c *R, int gap)
{
  cpNode_c * result = NULL;

  while (! LEAF.empty())
  {
    cpSide_c *S = LEAF.front();
    LEAF.pop_front();

    if (S->on_node)
      continue;

    MarkColinearSides(LEAF, S->x1, S->y1, S->x2, S->y2);

    cpNode_c *node = new cpNode_c(false /* z_splitter */);

    node->x = S->x1;
    node->y = S->y1;

    node->dx = S->x2 - S->x1;
    node->dy = S->y2 - S->y1;

    node->back_l = CONTENTS_SOLID;

    if (result)
      node->front_n = result;
    else
      node->front_l = CONTENTS_EMPTY;

    result = node;
  }

  if (! result)
    Main_FatalError("INTERNAL ERROR: Partition_Gap: no usable sides!!\n");

  return result;
}


static cpNode_c * Partition_Z(cpSideList_c& LEAF, merge_region_c *R,
                              int min_plane, int max_plane)
{
  SYS_ASSERT(min_plane <= max_plane);

  if (max_plane - min_plane < 2)
  {
    int p2 = max_plane;

    cpNode_c *node = new cpNode_c(true /* z_splitter */);
    cpNode_c *n2;

    if (p2 != min_plane)
    {
      n2 = Partition_Z(LEAF, R, min_plane, min_plane);
    }
    else
    {
      n2 = Partition_Gap(LEAF, R, p2/2);
    }

    if (p2 & 1)
    {
      node->z = R->gaps[p2/2]->GetZ2();

      node->front_l = CONTENTS_SOLID;
      node->back_n  = n2;
    }
    else
    {
      node->z = R->gaps[p2/2]->GetZ1();

      node->front_n = n2;
      node->back_l  = CONTENTS_SOLID;
    }

    return node;
  }


  int p2 = (min_plane + max_plane + 1) / 2;

  cpNode_c *node = new cpNode_c(true /* z_splitter */);

  node->z = (p2 & 1) ? R->gaps[p2/2]->GetZ2() : R->gaps[p2/2]->GetZ1();

  node->front_n = Partition_Z(LEAF, R, p2+1, max_plane);
  node->back_n  = Partition_Z(LEAF, R, min_plane, p2-1);

  return node;
}


static cpNode_c * Partition_XY(cpSideList_c& LEAF)
{
  cpSide_c *best_p = FindPartition(LEAF);

  if (! best_p)
  {
    merge_region_c *R = GetLeafRegion(LEAF);

    SYS_ASSERT(! R->gaps.empty());

    return Partition_Z(LEAF, R, 0, (int)R->gaps.size()*2 - 1);
  }


// fprintf(stderr, "CLIP LEAF HAS SPLITTER %p \n", best_p);
  cpNode_c *node = new cpNode_c(false /* z_splitter */);

  node->x = best_p->x1;
  node->y = best_p->y1;

  node->dx = best_p->x2 - node->x;
  node->dy = best_p->y2 - node->y;


fprintf(stderr, "Using clip partition (%1.0f,%1.0f) to (%1.2f,%1.2f)\n",
                 node->x, node->y,
                 node->x + node->dx, node->y + node->dy);

  
  cpSideList_c BACK;

  Split_XY(node, LEAF, BACK);


  node->front_n = Partition_XY(LEAF);
  node->back_n  = Partition_XY(BACK);


  // free stuff in BACK ???

  return node;
}


static void MakeClipSide(cpSideList_c LEAF, merge_segment_c *seg, int side)
{
  cpSide_c *S = new cpSide_c(seg, side); 

  LEAF.push_back(S);
}


//------------------------------------------------------------------------

static void AssignIndexes(cpNode_c *node, int *idx_var)
{
  node->index = *idx_var;

  (*idx_var) += 1;

  if (node->front_n)
    AssignIndexes(node->front_n, idx_var);

  if (node->back_n)
    AssignIndexes(node->back_n, idx_var);
}


static void WriteClipNodes(qLump_c *L, cpNode_c *node)
{
  dclipnode_t clip;

  bool flipped;

  if (node->z_splitter)
    clip.planenum = Q1_AddPlane(0, 0, node->z, 0, 0, 1, &flipped);
  else
    clip.planenum = Q1_AddPlane(node->x, node->y, 0,
                                node->dy, -node->dx, 0, &flipped);
  if (flipped)
    node->Flip();


  node->CheckValid();

  if (node->front_n)
    clip.children[0] = (u16_t) node->front_n->index;
  else
    clip.children[0] = (u16_t) node->front_l;

  if (node->back_n)
    clip.children[1] = (u16_t) node->back_n->index;
  else
    clip.children[1] = (u16_t) node->back_l;


  // TODO: fix endianness in 'clip'

  Q1_Append(L, &clip, sizeof(clip));


  // recurse now, AFTER adding the current node

  if (node->front_n)
    WriteClipNodes(L, node->front_n);

  if (node->back_n)
    WriteClipNodes(L, node->back_n);


  delete node;
}


s32_t Quake1_CreateClipHull(int which, qLump_c *q1_clip)
{
  SYS_ASSERT(1 <= which && which <= 3);

  // 3rd hull is not used in Quake 1
  if (which == 3)
    return 0;

  // ALGORITHM:
  //   1. create a Side list from every segment
  //   2. while list is not yet convex:
  //      (a) find a splitter side --> create Node
  //      (b) split list into front and back
  //      (c) recursively handle front/back lists
  //   3. perform Z splitting (the gaps)
  //   4. perform solid splitting
  
  cpSideList_c C_LEAF;

  for (unsigned int i = 0; i < mug_segments.size(); i++)
  {
    merge_segment_c *S = mug_segments[i];

    if (S->front && S->front->HasGap())
      MakeClipSide(C_LEAF, S, 0);

    if (S->back && S->back->HasGap())
      MakeClipSide(C_LEAF, S, 1);
  }


  cpNode_c *C_ROOT = Partition_XY(C_LEAF);

  SYS_ASSERT(C_LEAF.size() == 0);


  int start_idx = q1_clip->size() / sizeof(dclipnode_t);
  int cur_index = start_idx;

  AssignIndexes(C_ROOT, &cur_index);

  if (cur_index >= MAX_MAP_CLIPNODES)
    Main_FatalError("Quake1 build failure: exceeded limit of %d CLIPNODES\n",
                    MAX_MAP_CLIPNODES);

  // this also frees everything
  WriteClipNodes(q1_clip, C_ROOT);

  return start_idx;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
