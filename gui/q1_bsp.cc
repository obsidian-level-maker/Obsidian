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



///  class qFace_c
///  {
///  public:
///    int foo;
///   
///  public:
///     qFace_c(  ) { }
///    ~qFace_c() { }
///  };


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

///  std::vector<qFace_c *> faces;

  std::list<qSide_c *> sides;

  // Note: qSide_c objects are shared when gap > 0

  int gap;

  double min_x, min_y;
  double max_x, max_y;

public:
  qLeaf_c() : contents(CONTENTS_EMPTY), /* faces(), */ sides(),
              gap(0), min_x(0), min_y(0), max_x(0), max_y(0)
  { }

  ~qLeaf_c()
  {
    // TODO: delete faces and sides
  }

  qLeaf_c(qLeaf_c& other, int _gap) :
          contents(other.contents), /* faces(), */ sides(), gap(_gap),
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

  bool IsConvex_XY()  // REMOVE ME 
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

  void Flip()
  {
    SYS_ASSERT(! z_splitter);

    qLeaf_c *tmp_l = front_l; front_l = back_l; back_l = tmp_l;
    qNode_c *tmp_n = front_n; front_n = back_n; back_n = tmp_n;

    dx = -dx;
    dy = -dy;
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

static qNode_c *q_root;

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

  q_root = PartitionXY(begin);
}


//------------------------------------------------------------------------

#define Q_SIDESPACE  24

static dmodel_t model;

static qLump_c *q_nodes;
static qLump_c *q_leafs;
static qLump_c *q_faces;
static qLump_c *q_mark_surfs;
static qLump_c *q_surf_edges;

static int total_nodes;
static int total_mark_surfs;
static int total_surf_edges;


static void AddEdge(double x1, double y1, double z1,
                    double x2, double y2, double z2,
                    dface_t *face, dleaf_t *raw_lf)
{
  u16_t v1 = Q1_AddVertex(x1, y1, z1);
  u16_t v2 = Q1_AddVertex(x2, y2, z2);

  if (v1 == v2)
  {
    Main_FatalError("INTERNAL ERROR (Q1 AddEdge): zero length!\n"
                    "coordinate (%1.2f %1.2f %1.2f)\n", x1, y1, z1);
  }

  s32_t edge_idx = Q1_AddEdge(v1, v2);


  edge_idx = LE_S32(edge_idx);

  Q1_Append(q_surf_edges, &edge_idx, 4);

  total_surf_edges += 1;

  face->numedges += 1;


  // update bounding boxes
  double lows[3], highs[3];

  lows[0] = MIN(x1, x2);  highs[0] = MAX(x1, x2);
  lows[1] = MIN(y1, y2);  highs[1] = MAX(y1, y2);
  lows[2] = MIN(z1, z2);  highs[2] = MAX(z1, z2);

  for (int b = 0; b < 3; b++)
  {
    s16_t low  =  (I_ROUND( lows[b]) - 2) & ~7;
    s16_t high = ((I_ROUND(highs[b]) + 2) |  7) + 1;

    raw_lf->mins[b] = MIN(raw_lf->mins[b], low);
    raw_lf->maxs[b] = MAX(raw_lf->maxs[b], high);

    double m_low  =  lows[b] - Q_SIDESPACE;
    double m_high = highs[b] + Q_SIDESPACE;

    model.mins[b] = MIN(model.mins[b], m_low);
    model.maxs[b] = MAX(model.maxs[b], m_high);
  }
}


static void Side_to_Face(qSide_c *S, qLeaf_c *leaf, dleaf_t *raw_lf)
{
  merge_region_c *R = leaf->GetRegion();
  merge_gap_c *gap  = R->gaps.at(leaf->gap);


  dface_t face;

  bool flipped;

  face.planenum = Q1_AddPlane(S->x1, S->y1, 0,
                              (S->y1 - S->y2), (S->x2 - S->x1), 0,
                              &flipped);

  face.side = flipped ? 1 : 0;

  face.texinfo = 0;
  if (fabs(S->x1 - S->x2) > fabs(S->y1 - S->y2))
    face.texinfo = 1;

  face.styles[0] = 0xFF;  // no lightmap
  face.styles[1] = 0x33;  // fairly bright
  face.styles[2] = 0xFF;
  face.styles[3] = 0xFF;

  face.lightofs = -1;  // no lightmap


  // add the edges

  face.firstedge = total_surf_edges;
  face.numedges  = 0;

  double z1 = gap->GetZ1();
  double z2 = gap->GetZ2();

  if (false) // !flipped)
  {
    AddEdge(S->x1, S->y1, z1,  S->x1, S->y1, z2,  &face, raw_lf);
    AddEdge(S->x1, S->y1, z2,  S->x2, S->y2, z2,  &face, raw_lf);
    AddEdge(S->x2, S->y2, z2,  S->x2, S->y2, z1,  &face, raw_lf);
    AddEdge(S->x2, S->y2, z1,  S->x1, S->y1, z1,  &face, raw_lf);
  }
  else
  {
    AddEdge(S->x1, S->y1, z1,  S->x2, S->y2, z1,  &face, raw_lf);
    AddEdge(S->x2, S->y2, z1,  S->x2, S->y2, z2,  &face, raw_lf);
    AddEdge(S->x2, S->y2, z2,  S->x1, S->y1, z2,  &face, raw_lf);
    AddEdge(S->x1, S->y1, z2,  S->x1, S->y1, z1,  &face, raw_lf);
  }


  // FIXME: fix endianness in face

  u16_t index = model.numfaces++;

  if (index >= MAX_MAP_FACES)
    Main_FatalError("Quake1 build failure: exceeded limit of %d FACES\n",
                    MAX_MAP_FACES);

  Q1_Append(q_faces, &face, sizeof(face));


  // add it into the mark_surfs lump
  index = LE_U16(index);

  Q1_Append(q_mark_surfs, &index, 2);

  total_mark_surfs += 1;

  raw_lf->num_marksurf += 1;
}


static void Floor_to_Face(qLeaf_c *leaf, dleaf_t *raw_lf, int is_ceil)
{
  merge_region_c *R = leaf->GetRegion();
  merge_gap_c *gap  = R->gaps.at(leaf->gap);

  double z1 = gap->GetZ1();
  double z2 = gap->GetZ2();

  double z = is_ceil ? z2 : z1;


  dface_t face;

  bool flipped;

  face.planenum = Q1_AddPlane(0, 0, z,
                              0, 0, is_ceil ? -1 : +1, &flipped);

  face.side = flipped ? 1 : 0;

  face.texinfo = 2;

  face.styles[0] = 0xFF;  // no lightmap
  face.styles[1] = 0x66;  // fairly bright
  face.styles[2] = 0xFF;
  face.styles[3] = 0xFF;

  face.lightofs = -1;  // no lightmap


  // add the edges

  face.firstedge = total_surf_edges;
  face.numedges  = 0;

  std::list<qSide_c *>::iterator SI;
  std::list<qSide_c *>::iterator EI;

  for (SI = leaf->sides.begin(); SI != leaf->sides.end(); SI++)
  {
    EI = SI; EI++;
    if (EI == leaf->sides.end())
      EI = leaf->sides.begin();

    qSide_c *S = *SI;
    qSide_c *E = *EI;

    SYS_ASSERT(S != E);

    AddEdge(S->x1, S->y1, z,  E->x1, E->y1, z,  &face, raw_lf);
  }


  // FIXME: fix endianness in face

  u16_t index = model.numfaces++;

  if (index >= MAX_MAP_FACES)
    Main_FatalError("Quake1 build failure: exceeded limit of %d FACES\n",
                    MAX_MAP_FACES);

  Q1_Append(q_faces, &face, sizeof(face));


  // add it into the mark_surfs lump
  index = LE_U16(index);

  Q1_Append(q_mark_surfs, &index, 2);

  total_mark_surfs += 1;

  raw_lf->num_marksurf += 1;
}


static s16_t MakeLeaf(qLeaf_c *leaf, dnode_t *parent)
{
  dleaf_t raw_lf;

  raw_lf.contents = leaf->contents;
  raw_lf.visofs   = -1;  // no visibility info

  int b;

  for (b = 0; b < 3; b++)
  {
    raw_lf.mins[b] = +32767;
    raw_lf.maxs[b] = -32767;
  }

  memset(raw_lf.ambient_level, 0, sizeof(raw_lf.ambient_level));

  raw_lf.first_marksurf = total_mark_surfs;
  raw_lf.num_marksurf   = 0;


  // make faces for floor and ceiling

//!!!  Floor_to_Face(leaf, &raw_lf, 0);
//!!!  Floor_to_Face(leaf, &raw_lf, 1);


  // make faces for real sides
  std::list<qSide_c *>::iterator SI;

  for (SI = leaf->sides.begin(); SI != leaf->sides.end(); SI++)
  {
    qSide_c *S = *SI;

    Side_to_Face(S, leaf, &raw_lf);
  }


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

  Q1_Append(q_leafs, &raw_lf, sizeof(raw_lf));

  return -(index+2);
}


static s32_t RecursiveMakeNodes(qNode_c *node, dnode_t *parent)
{
  dnode_t raw_nd;

  int b;
  bool flipped;

  if (node->z_splitter)
    raw_nd.planenum = Q1_AddPlane(0, 0, node->z, 0, 0, 1, &flipped);
  else
    raw_nd.planenum = Q1_AddPlane(node->x, node->y, 0,
                                  node->dy, -node->dx, 0, &flipped);
  if (flipped)
    node->Flip();

  
  raw_nd.firstface = 0;
  raw_nd.numfaces  = 0;

  for (b = 0; b < 3; b++)
  {
    raw_nd.mins[b] = +32767;
    raw_nd.maxs[b] = -32767;
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


  // FIXME: fix endianness in raw_nd

  // -AJA- NOTE WELL: the Quake1 code assumes the root node is the
  //       very first one.  The following is a hack to achieve that.
  //       (Hopefully no other assumptions about node ordering exist
  //        in the Quake1 code!).

  if (! parent) // is_root
  {
    Q1_Prepend(q_nodes, &raw_nd, sizeof(raw_nd));

    return 0;
  }

  s32_t index = total_nodes++;

  if (index >= MAX_MAP_NODES)
    Main_FatalError("Quake1 build failure: exceeded limit of %d NODES\n",
                    MAX_MAP_NODES);

  Q1_Append(q_nodes, &raw_nd, sizeof(raw_nd));

  return index;
}


static void CreateSolidLeaf(void)
{
  dleaf_t raw_lf;

  memset(&raw_lf, 0, sizeof(raw_lf));

  raw_lf.contents = CONTENTS_SOLID;
  raw_lf.visofs   = -1;  // no visibility info

  Q1_Append(q_leafs, &raw_lf, sizeof(raw_lf));
}


void BSP_CreateModel(void)
{
  qLump_c *lump = Q1_NewLump(LUMP_MODELS);

///  dmodel_t model;

  for (int b = 0; b < 3; b++)
  {
    model.mins[b] = +9e6;
    model.maxs[b] = -9e6;

    model.origin[b] = 0;
  }

  model.headnode[0] = 0;  // root of drawing BSP
  model.headnode[1] = 0;  // dummy clipper #1
  model.headnode[2] = 1;  // dummy clipper #2
  model.headnode[3] = 0;  // unused

  model.visleafs  = 0;
  model.firstface = 0;
  model.numfaces  = 0;

  total_nodes = 1;  // root node is always first

  q_nodes = Q1_NewLump(LUMP_NODES);
  q_leafs = Q1_NewLump(LUMP_LEAFS);
  q_faces = Q1_NewLump(LUMP_FACES);

  q_mark_surfs = Q1_NewLump(LUMP_MARKSURFACES);
  q_surf_edges = Q1_NewLump(LUMP_SURFEDGES);

  CreateSolidLeaf();

  RecursiveMakeNodes(q_root, NULL /* parent */);

  // FIXME: fix endianness in model

  Q1_Append(lump, &model, sizeof(model));
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
