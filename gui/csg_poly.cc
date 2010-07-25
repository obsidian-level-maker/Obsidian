//------------------------------------------------------------------------
//  2.5D Constructive Solid Geometry
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

#include <algorithm>

#include "lib_util.h"
#include "main.h"

#include "csg_main.h"
#include "g_lua.h"
#include "ui_dialog.h"


static int mug_changes = 0;

static int hot_index;

static bool do_clip_brushes;



static inline bool IsCold(const merge_segment_c *S)
{
  return (S->index > hot_index+1);
}

static inline void MarkHot(merge_segment_c *S)
{
  S->index = hot_index;
}


#define QUADTREE_LEAF_SIZE  128

class quadtree_node_c
{
public:
  // area covered by this node
  short x1, y1, x2, y2;

  // sub trees:
  //    0 | 1
  //    --+--
  //    2 | 3
  quadtree_node_c * children[4];

  std::vector<merge_segment_c *> segs;
 
public:
  quadtree_node_c(int lx, int ly, int hx, int hy) :
      x1(lx), y1(ly), x2(hx), y2(hy), segs()
  {
    children[0] = children[1] = children[2] = children[3] = NULL;
  }

  ~quadtree_node_c()
  {
    for (int i = 0; i < 4; i++)
      if (children[i])
        delete children[i];
  }

  static quadtree_node_c * CreateTree(int lx, int ly, int hx, int hy)
  {
    int mx = (hx + lx) / 2;
    int my = (hy + ly) / 2;

    // adjust centre so that zero axes touch a leaf boundary
    mx = (mx / QUADTREE_LEAF_SIZE) * QUADTREE_LEAF_SIZE;
    my = (my / QUADTREE_LEAF_SIZE) * QUADTREE_LEAF_SIZE;

    // determine total size of quadtree (N = number of leaves)
    int N = 1;
    int depth = 0;

    while (lx < (mx - (N-1)*QUADTREE_LEAF_SIZE) || hx > (mx + N * QUADTREE_LEAF_SIZE) ||
           ly < (my - (N-1)*QUADTREE_LEAF_SIZE) || hy > (my + N * QUADTREE_LEAF_SIZE))
    {
      N *= 2;
      depth += 1;
    }

    lx = mx - (N-1) * QUADTREE_LEAF_SIZE;
    ly = my - (N-1) * QUADTREE_LEAF_SIZE;

    hx = mx + N * QUADTREE_LEAF_SIZE;
    hy = my + N * QUADTREE_LEAF_SIZE;

    return CreateSubTree(lx, ly, hx, hy, depth);
  }

  void AddSeg(merge_segment_c *S)
  {
    int min_x = (int)floor(MIN(S->start->x, S->end->x)) - 1;
    int min_y = (int)floor(MIN(S->start->y, S->end->y)) - 1;

    int max_x = (int)ceil(MAX(S->start->x, S->end->x)) + 1;
    int max_y = (int)ceil(MAX(S->start->y, S->end->y)) + 1;

    int node_mx = (x1 + x2) / 2;
    int node_my = (y1 + y2) / 2;

    if (children[0])
    {
      int where = 0;

      if (max_x <= node_mx) where |= 1;
      if (min_x >= node_mx) where |= 2;
      if (max_y <= node_my) where |= 4;
      if (min_y >= node_my) where |= 8;

      if (where ==  5) { children[0]->AddSeg(S); return; }
      if (where ==  6) { children[1]->AddSeg(S); return; }
      if (where ==  9) { children[2]->AddSeg(S); return; }
      if (where == 10) { children[3]->AddSeg(S); return; }
    }

    MarkHot(S);

    segs.push_back(S);
  }

  void Transfer()
  {
    for (int i = 0; i < (int)segs.size(); i++)
    {
      if (segs[i]->start)
        mug_segments.push_back(segs[i]);
      else
        delete segs[i];
    }

    // recurse down
    if (children[0])
      for (int c = 0; c < 4; c++)
        children[c]->Transfer();
  }

private:
  static quadtree_node_c * CreateSubTree(int lx, int ly, int hx, int hy, int depth)
  {
    quadtree_node_c *nd = new quadtree_node_c(lx, ly, hx, hy);

    if (depth > 0)
    {
      depth--;

      int mx = (lx + hx) / 2;
      int my = (ly + hy) / 2;

      nd->children[0] = CreateSubTree(lx, ly, mx, my, depth);
      nd->children[1] = CreateSubTree(mx, ly, hx, my, depth);
      nd->children[2] = CreateSubTree(lx, my, mx, hy, depth);
      nd->children[3] = CreateSubTree(mx, my, hx, hy, depth);
    }

    return nd;
  }
};


static quadtree_node_c *quad_root;


void merge_vertex_c::AddSeg(merge_segment_c *seg)
{
  for (unsigned int j=0; j < segs.size(); j++)
    if (segs[j] == seg)
      return;

  segs.push_back(seg);
}

void merge_vertex_c::RemoveSeg(merge_segment_c *seg)
{
  std::vector<merge_segment_c *>::iterator ENDP;

  ENDP = std::remove(segs.begin(), segs.end(), seg);

  segs.erase(ENDP, segs.end());
}

void merge_vertex_c::ReplaceSeg(merge_segment_c *old_seg, merge_segment_c *new_seg)
{
  for (unsigned int j=0; j < segs.size(); j++)
    if (segs[j] == old_seg)
    {
      segs[j] = new_seg;
      return;
    }

  Main_FatalError("ReplaceSeg: does not exist!\n");
}

bool merge_vertex_c::HasSeg(merge_segment_c *seg) const
{
  for (unsigned int j=0; j < segs.size(); j++)
    if (segs[j] == seg)
      return true;

  return false;  // nope
}


merge_segment_c * merge_vertex_c::FindSeg(merge_vertex_c *other)
{
  for (unsigned int j=0; j < segs.size(); j++)
    if (segs[j]->Match(this, other))
      return segs[j];

  return NULL;  // not found
}
 

///?? void merge_segment_c::ReplaceStart(merge_vertex_c *V)
///?? {
///??   start->RemoveSeg(this);
///??   start = V;
///??   start->AddSeg(this);
///?? }
///?? 
///?? void merge_segment_c::ReplaceEnd(merge_vertex_c *V)
///?? {
///??   end->RemoveSeg(this);
///??   end = V;
///??   end->AddSeg(this);
///?? }

bool merge_segment_c::HasGap() const
{
  return (front && front->gaps.size() > 0) ||
         (back  &&  back->gaps.size() > 0);
}

void merge_segment_c::Kill()
{
  start->RemoveSeg(this);
  end  ->RemoveSeg(this);

  start = end = NULL;
}

void merge_segment_c::Flip()
{
  std::swap(start, end);
  std::swap(front, back);
  std::swap(f_sides, b_sides);
}

void merge_segment_c::MergeSides(merge_segment_c *other)
{
  unsigned int k;

  if (start == other->start)
  {
    for (k = 0; k < other->f_sides.size(); k++)
      f_sides.push_back(other->f_sides[k]);

    for (k = 0; k < other->b_sides.size(); k++)
      b_sides.push_back(other->b_sides[k]);
  }
  else
  {
    SYS_ASSERT(start == other->end);

    for (k = 0; k < other->f_sides.size(); k++)
      b_sides.push_back(other->f_sides[k]);

    for (k = 0; k < other->b_sides.size(); k++)
      f_sides.push_back(other->b_sides[k]);
  }
}

brush_vert_c *merge_segment_c::FindSide(csg_brush_c *brush)
{
  unsigned int k;

  for (k = 0; k < f_sides.size(); k++)
    if (f_sides[k]->parent == brush)
      return f_sides[k];

  for (k = 0; k < b_sides.size(); k++)
    if (b_sides[k]->parent == brush)
      return b_sides[k];

  return NULL;  // not found
}


double merge_region_c::MinGapZ() const
{
  SYS_ASSERT(gaps.size() > 0);

  return gaps[0]->GetZ1();
}

double merge_region_c::MaxGapZ() const
{
  SYS_ASSERT(gaps.size() > 0);

  return gaps[gaps.size() - 1]->GetZ2();
}

bool merge_region_c::HasSeg(merge_segment_c *seg) const
{
  for (unsigned int j=0; j < segs.size(); j++)
    if (segs[j] == seg)
      return true;

  return false;  // nope
}

void merge_region_c::AddSeg(merge_segment_c *seg)
{
  for (unsigned int j=0; j < segs.size(); j++)
    if (segs[j] == seg)
      return;

  segs.push_back(seg);
}
 
bool merge_region_c::HasBrush(csg_brush_c *P) const
{
  for (unsigned int j = 0; j < brushes.size(); j++)
    if (brushes[j] == P)
      return true;

  return false; // nope
}

void merge_region_c::AddBrush(csg_brush_c *P)
{
  brushes.push_back(P);
}

void merge_region_c::ComputeBBox()
{
  min_x = +9e7;
  min_y = +9e7;
  max_x = -9e7;
  max_y = -9e7;

  SYS_ASSERT(segs.size() > 0);

  for (unsigned int j = 0; j < segs.size(); j++)
  {
    merge_segment_c *S = segs[j];

    if (S->start->x < min_x) min_x = S->start->x;
    if (S->start->y < min_y) min_y = S->start->y;
    
    if (S->start->x > max_x) max_x = S->start->x;
    if (S->start->y > max_y) max_y = S->start->y;

    if (S->end->x < min_x) min_x = S->end->x;
    if (S->end->y < min_y) min_y = S->end->y;

    if (S->end->x > max_x) max_x = S->end->x;
    if (S->end->y > max_y) max_y = S->end->y;
  }
}


#define VERTEX_HASH  512
static std::vector<merge_vertex_c *> * hashed_verts[VERTEX_HASH];


static void ClearVertexHash()
{
  for (int h = 0; h < VERTEX_HASH; h++)
  {
    delete hashed_verts[h];
    hashed_verts[h] = NULL;
  }
}

static merge_vertex_c *Mug_AddVertex(double x, double y)
{
  // quantize position
  int qx = I_ROUND(x / QUANTIZE_GRID);
  int qy = I_ROUND(y / QUANTIZE_GRID);

  x = qx * QUANTIZE_GRID;
  y = qy * QUANTIZE_GRID;

  // check if already present.
  // for speed we use a hash-table
  int hash = IntHash(qx ^ IntHash(qy)) & (VERTEX_HASH-1);
  SYS_ASSERT(hash >= 0);

  if (! hashed_verts[hash])
    hashed_verts[hash] = new std::vector<merge_vertex_c *>;

  std::vector<merge_vertex_c *> * htable = hashed_verts[hash];

  for (unsigned int i=0; i < htable->size(); i++)
    if ((* htable)[i]->Match(x, y))
      return (* htable)[i];

  merge_vertex_c * V = new merge_vertex_c(x, y);

  mug_vertices.push_back(V);
  htable->push_back(V);

  return V;
}

static merge_segment_c *Mug_AddSegment(merge_vertex_c *start, merge_vertex_c *end)
{
  // check for zero-length lines
  if (start == end)
    Main_FatalError("Line loop contains zero-length line! (%1.2f, %1.2f)\n",
                    start->x, start->y);

  // check if already present
  merge_segment_c *S = start->FindSeg(end);

  if (S)
  {
    SYS_ASSERT(end->FindSeg(start) == S);
    return S;
  }

  SYS_ASSERT(! end->FindSeg(start));

  S = new merge_segment_c(start, end);

  mug_segments.push_back(S);

  start->AddSeg(S);
  end  ->AddSeg(S);

  return S;
}

static void Mug_MakeSegments(csg_brush_c *P)
{
  SYS_ASSERT(P);

  if (! do_clip_brushes && P->bkind == BKIND_Clip)
    return;

  for (int k=0; k < (int)P->verts.size(); k++)
  {
    brush_vert_c *v1 = P->verts[k];
    brush_vert_c *v2 = P->verts[(k+1) % (int)P->verts.size()];

    v1->partner = Mug_AddVertex(v1->x, v1->y);
    v2->partner = Mug_AddVertex(v2->x, v2->y);

    // swap vertices so that segment faces inward
    merge_segment_c *S = Mug_AddSegment(v2->partner, v1->partner);

    if (S->start == v2->partner)
      S->f_sides.push_back(v1);
    else
      S->b_sides.push_back(v1);
  }
}

static bool Mug_SplitSegment(merge_segment_c *S, merge_vertex_c *V,
                             quadtree_node_c *nd)
{
  if (V == S->start || V == S->end)
  {
/// DebugPrintf("Mug_SplitSegment %p (%1.6f %1.6f) --> (%1.6f %1.6f) : V IS START/END\n",
/// S, S->start->x, S->start->y, S->end->x, S->end->y);
    return false;
  }

/// DebugPrintf("Mug_SplitSegment: %p (%1.6f %1.6f) --> (%1.6f %1.6f) at (%1.6f %1.6f)\n", S,
/// S->start->x, S->start->y, S->end->x, S->end->y, V->x, V->y);

  MarkHot(S);

  merge_segment_c *NS = new merge_segment_c(V, S->end);

  nd->AddSeg(NS);

  // replace end vertex
  S->end->ReplaceSeg(S, NS);
  S->end = V;

  // SYS_ASSERT(! V->HasSeg(S));
  // SYS_ASSERT(! V->HasSeg(NS));

  V->AddSeg(S);
  V->AddSeg(NS);

  // copy sides
  unsigned int k;

  for (k = 0; k < S->f_sides.size(); k++)
    NS->f_sides.push_back(S->f_sides[k]);

  for (k = 0; k < S->b_sides.size(); k++)
    NS->b_sides.push_back(S->b_sides[k]);

  mug_changes++;

  return true;
}


static void Mug_TransferQuadTree(quadtree_node_c *root)
{
#if 0
  std::vector<merge_segment_c *> old_segments;

  std::swap(mug_segments, old_segments);

  for (int i = 0; i < (int)old_segments.size(); i++)
    if (! old_segments[i]->start)
      delete old_segments[i];
#else

  // every segment (including ones marked as deleted) is still in the
  // quadtree, hence this should not leak any memory.
  mug_segments.clear();
#endif

  root->Transfer();
}


struct Compare_SegmentMinX_pred
{
  inline bool operator() (const merge_segment_c *A, const merge_segment_c *B) const
  {
    return MIN(A->start->x, A->end->x) < MIN(B->start->x, B->end->x);
  }
};

struct Compare_BrushMinX_pred
{
  inline bool operator() (const csg_brush_c *A, const csg_brush_c *B) const
  {
    return A->min_x < B->min_x;
  }
};

struct Compare_BrushZ1_pred
{
  inline bool operator() (const csg_brush_c *A, const csg_brush_c *B) const
  {
    return A->b.z < B->b.z;
  }
};

struct Compare_RegionMinX_pred
{
  inline bool operator() (const merge_region_c *A, const merge_region_c *B) const
  {
    return A->min_x < B->min_x;
  }
};


static inline void TestOverlap(merge_segment_c *A, merge_segment_c *B,
                               quadtree_node_c *AN, quadtree_node_c *BN)
{
  double ax1 = A->start->x;
  double ay1 = A->start->y;
  double ax2 = A->end->x;
  double ay2 = A->end->y;

  double bx1 = B->start->x;
  double by1 = B->start->y;
  double bx2 = B->end->x;
  double by2 = B->end->y;

  if (MIN(bx1, bx2) > MAX(ax1, ax2)+EPSILON ||
      MIN(ax1, ax2) > MAX(bx1, bx2)+EPSILON)
    return;

  if (MIN(by1, by2) > MAX(ay1, ay2)+EPSILON ||
      MIN(ay1, ay2) > MAX(by1, by2)+EPSILON)
    return;

  /* to get here, the bounding boxes must touch or overlap.
   * now we perform the line-line intersection test.
   */

/// DebugPrintf("\nA = %p (%1.5f %1.5f) .. (%1.5f %1.5f)\n", A, ax1,ay1, ax2,ay2);
/// DebugPrintf(  "B = %p (%1.5f %1.5f) .. (%1.5f %1.5f)\n", B, bx1,by1, bx2,by2);


  // total overlap (same start + end points) ?
  if (A->Match(B))
  {
/// DebugPrintf("Killed %p (merged with %p)\n", B, A);

    A->MergeSides(B);
    B->Kill();

    MarkHot(A);

    mug_changes++;
    return;
  }


  double ap1 = PerpDist(ax1,ay1, bx1,by1, bx2,by2);
  double ap2 = PerpDist(ax2,ay2, bx1,by1, bx2,by2);

  int a1_side = (ap1 < -EPSILON) ? -1 : (ap1 > EPSILON) ? +1 : 0;
  int a2_side = (ap2 < -EPSILON) ? -1 : (ap2 > EPSILON) ? +1 : 0;

/// DebugPrintf("A SIDES: %d %d\n", a1_side, a2_side);

  // is A completely on one side of B?
  if (a1_side == a2_side && a1_side != 0)
    return;

  double bp1 = PerpDist(bx1,by1, ax1,ay1, ax2,ay2);
  double bp2 = PerpDist(bx2,by2, ax1,ay1, ax2,ay2);

  int b1_side = (bp1 < -EPSILON) ? -1 : (bp1 > EPSILON) ? +1 : 0;
  int b2_side = (bp2 < -EPSILON) ? -1 : (bp2 > EPSILON) ? +1 : 0;

/// DebugPrintf("B SIDES: %d %d\n", a1_side, a2_side);

  // is B completely on one side of A?
  if (b1_side == b2_side && b1_side != 0)
    return;


  // check if on the same line
  if ((a1_side == 0 && a2_side == 0) || (b1_side == 0 && b2_side == 0))
  {
    // find vertices that split a segment
    double a1_along = 0.0;
    double a2_along = AlongDist(ax2,ay2, ax1,ay1, ax2,ay2);
    double b1_along = AlongDist(bx1,by1, ax1,ay1, ax2,ay2);
    double b2_along = AlongDist(bx2,by2, ax1,ay1, ax2,ay2);

    SYS_ASSERT(a2_along > a1_along);

    double b_min = MIN(b1_along, b2_along);
    double b_max = MAX(b1_along, b2_along);

    // doesn't touch, or merely connects?
    if (b_max < a1_along + EPSILON)
      return;

    if (b_min > a2_along - EPSILON)
      return;


    // Note: it's possible one of the new (split off) segments
    //       is directly overlapping another segment.  This will
    //       be detected and handled in the next pass.

    if (b1_along > a1_along+EPSILON && b1_along < a2_along-EPSILON)
      if (Mug_SplitSegment(A, B->start, AN))
        return;

    if (b2_along > a1_along+EPSILON && b2_along < a2_along-EPSILON)
      if (Mug_SplitSegment(A, B->end, AN))
        return;

    if (a1_along > b_min+EPSILON && a1_along < b_max-EPSILON)
      if (Mug_SplitSegment(B, A->start, BN))
        return;

    if (a2_along > b_min+EPSILON && a2_along < b_max-EPSILON)
      if (Mug_SplitSegment(B, A->end, BN))
        return;

    return;
  }


  // check for sharing a single vertex
#if 0
  if (A->start == B->start || A->start == B->end ||
      A->end   == B->start || A->end   == B->end)
    return false;
#else
  if ((a1_side == 0 || a2_side == 0) && (b1_side == 0 || b2_side == 0))
    return;
#endif


  // compute intersection point
  double ix, iy, along;

  if (fabs(ap1 - ap2) > fabs(bp1 - bp2))
  {
    along = ap1 / (ap1 - ap2);

    ix = ax1 + along * (ax2 - ax1);
    iy = ay1 + along * (ay2 - ay1);
  }
  else
  {
    along = bp1 / (bp1 - bp2);

    ix = bx1 + along * (bx2 - bx1);
    iy = by1 + along * (by2 - by1);
  }
  
  // add a new vertex at the intersection point
  // (this alone does not count as a change)
  merge_vertex_c * NV = Mug_AddVertex(ix, iy);

#if 0
DebugPrintf("cross-over at (%1.6f %1.6f)\n", ix, iy);
DebugPrintf("   A = (%1.6f %1.6f) --> (%1.6f %1.6f)\n", ax1,ay1, ax2,ay2);
DebugPrintf("   B = (%1.6f %1.6f) --> (%1.6f %1.6f)\n", bx1,by1, bx2,by2);
DebugPrintf("   AP = %1.7f / %1.7f\n", ap1, ap2);
DebugPrintf("   BP = %1.7f / %1.7f\n", bp1, bp2);
DebugPrintf("   NV at (%1.6f %1.6f)\n", NV->x, NV->y);
#endif

  if (a1_side * a2_side < 0)
  {
    Mug_SplitSegment(A, NV, AN);
  }

  if (b1_side * b2_side < 0)
  {
    Mug_SplitSegment(B, NV, BN);
  }
}

static void TestOverlap_recursive(merge_segment_c *A, int i,
                                  quadtree_node_c *AN, quadtree_node_c *BN)
{
  int min_x = (int)floor(MIN(A->start->x, A->end->x)) - 1;
  int min_y = (int)floor(MIN(A->start->y, A->end->y)) - 1;

  int max_x = (int)ceil(MAX(A->start->x, A->end->x)) + 1;
  int max_y = (int)ceil(MAX(A->start->y, A->end->y)) + 1;

  // NOTE: the check against segs.size() here allows newly added segs
  //       (from splits) to be processed as well.

  for (int k=(AN==BN) ? i+1 : 0; k < (int)BN->segs.size(); k++)
  {
    merge_segment_c *B = BN->segs[k];

    // skip deleted segments
    if (! A->start) return;
    if (! B->start) continue;

    if (IsCold(A) && IsCold(B))
      continue;

    TestOverlap(A, B, AN, BN);
  }

  if (! BN->children[0])
    return;

  for (int c = 0; c < 4; c++)
  {
    quadtree_node_c *CN = BN->children[c];

    if (max_x < CN->x1 || min_x > CN->x2 ||
        max_y < CN->y1 || min_y > CN->y2)
      continue;

    TestOverlap_recursive(A, i, AN, CN);
  }
}

static void OverlapPass_recursive(quadtree_node_c *AN, quadtree_node_c *BN = NULL)
{
  if (! BN)
    BN = AN;

  // NOTE: the check against segs.size() here allows newly added segs
  //       (from splits) to be processed as well.

  for (int i=0; i < (int)AN->segs.size(); i++)
  {
    merge_segment_c *A = AN->segs[i];

    if (! A->start)
      continue;

    TestOverlap_recursive(A, i, AN, BN);
  }

  if (AN == BN && AN->children[0])
    for (int c = 0; c < 4; c++)
      OverlapPass_recursive(AN->children[c]);
}

static void Mug_FindOverlaps(void)
{
  hot_index = -1;

  quad_root = quadtree_node_c::CreateTree(
    (int)bounds_x1, (int)bounds_y1, (int)bounds_x2, (int)bounds_y2);

  for (int i = 0; i < (int)mug_segments.size(); i++)
    quad_root->AddSeg(mug_segments[i]);


  int loops = 0;

  do
  {
    loops++ ; SYS_ASSERT(loops < 100);

    hot_index--;

    mug_changes = 0;

    OverlapPass_recursive(quad_root);

    LogPrintf("Mug_FindOverlaps: loop=%d changes=%d\n", loops, mug_changes);

  } while (mug_changes > 0);


  Mug_TransferQuadTree(quad_root);

  delete quad_root;  // TODO: consider using quadtree in other functions
}


//------------------------------------------------------------------------

static merge_segment_c *trace_seg;
static merge_vertex_c  *trace_vert;

static int    trace_side;
static double trace_angles;

static bool TraceNext(void)
{
  merge_vertex_c *next_v = trace_seg->Other(trace_vert);

  merge_segment_c *best_seg = NULL;
  double best_angle = 9999;

  double old_angle = CalcAngle(next_v->x, next_v->y, trace_vert->x, trace_vert->y);
  
  for (int k = 0; k < (int)next_v->segs.size(); k++)
  {
    merge_segment_c *T = next_v->segs[k];

    if (T == trace_seg)
      continue;

    merge_vertex_c *TV2 = T->Other(next_v);

    double angle = CalcAngle(next_v->x, next_v->y, TV2->x, TV2->y);

    if (trace_side == 0)
    {
      // FRONT: want lowest angle ANTI-Clockwise from current seg
      angle = angle - old_angle;
    }
    else
    {
      // BACK: want lowest angle CLOCKWISE from current seg
      angle = old_angle - angle;
    }

    // should never have two segments with same angle (pt 1)
    if (fabs(angle) < ANGLE_EPSILON)
    {
      LogPrintf("WARNING: TraceNext failure near (%1.4f,%1.4f)\n", next_v->x, next_v->y);
      return false;
    }

    if (angle < 0)
      angle += 360.0;

    SYS_ASSERT(angle > -ANGLE_EPSILON);
    SYS_ASSERT(angle < 360.0 + ANGLE_EPSILON);

#if 0
DebugPrintf("T: %p (%1.6f %1.6f) --> (%1.6f %1.6f)\n", T,
  T->start->x, T->start->y, T->end->x, T->end->y);
if (best_seg)
DebugPrintf("best_seg: %p (%1.6f %1.6f) --> (%1.6f %1.6f)\n", best_seg,
  best_seg->start->x, best_seg->start->y,
  best_seg->end->x, best_seg->end->y);
DebugPrintf("best_angle: %1.8f  angle: %1.8f\n", best_angle, angle);
#endif
    // should never have two segments with same angle (pt 2)
    if (fabs(best_angle - angle) < ANGLE_EPSILON)
    {
      LogPrintf("WARNING: TraceNext failure near (%1.4f,%1.4f)\n", next_v->x, next_v->y);
      return false;
    }

    if (angle < best_angle)
    {
      best_seg = T;
      best_angle = angle;
    }
  }

  SYS_ASSERT(best_seg);

  trace_seg  = best_seg;
  trace_vert = next_v;

  trace_angles += best_angle;

  return true;
}

static void TraceSegment(merge_segment_c *S, int side)
{
#if 0
DebugPrintf("TraceSegment %p (%1.1f,%1.1f) .. (%1.1f,%1.1f) side:%d\n",
S, S->start->x, S->start->y, S->end->x, S->end->y, side);
#endif
  
  trace_seg  = S;
  trace_vert = S->start;
  trace_side = side;

  trace_angles = 0.0;
 
  int count = 0;

  merge_region_c *R = new merge_region_c();

  do
  {
    if (! TraceNext()) return;

#if 0
DebugPrintf("  CUR SEG %p (%1.1f,%1.1f) .. (%1.1f,%1.1f)\n",
trace_seg,
trace_seg->start->x, trace_seg->start->y,
trace_seg->end->x, trace_seg->end->y);

DebugPrintf("  CUR VERT: %s\n",
(trace_vert == trace_seg->start) ? "start" :
(trace_vert == trace_seg->end) ? "end" : "FUCKED");
#endif

    if ((trace_vert == trace_seg->start) == (side == 0))
    {
      // hit some dead-end or non-returning loop??
      // FIXME: SHOULD.. NOT.. HAPPEN !!
      if (trace_seg->front or trace_seg->back == R)
      {
        LogPrintf("WARNING: TraceSegment failure near (%1.0f,%1.0f) .. (%1.0f,%1.0f)\n",
                  S->start->x, S->start->y, S->end->x, S->end->y);
        return;                  
      }

      trace_seg->front = R;
    }
    else
    {
      // hit some dead-end or non-returning loop??
      // FIXME: SHOULD.. NOT.. HAPPEN !!
      if (trace_seg->back or trace_seg->front == R)
      {
        LogPrintf("WARNING: TraceSegment failure near (%1.0f,%1.0f) .. (%1.0f,%1.0f)\n",
                  S->start->x, S->start->y, S->end->x, S->end->y);
        return;                  
      }

      trace_seg->back = R;
    }

    R->AddSeg(trace_seg);

    count++;

    SYS_ASSERT(count < 9000);
  }
  while (trace_seg != S);

  SYS_ASSERT(count >= 3);

  R->faces_out = (trace_angles / count) > 180.0;

  mug_regions.push_back(R);

#if 0
DebugPrintf("DONE\n\n");
#endif
}

static void Mug_TraceSegLoops(void)
{
  // Algorithm:
  //
  // starting at a untraced seg and a particular vertex of
  // that seg, follow the segs around in the tightest loop
  // possible until we get back to the beginning.  The result
  // will form a 'merged_region' (== a sector in Doom).
  //
  // Note: if the average angle is > 180, then the sector
  //       faces outward (i.e. it's actually an island within
  //       another sector -OR- the edge of the map).

  for (int i = 0; i < (int)mug_segments.size(); i++)
  {
    merge_segment_c *S = mug_segments[i];

    if (! S->front)
      TraceSegment(S, 0);

    if (! S->back)
      TraceSegment(S, 1);
  }
}

static bool GetOppositeSegment(merge_segment_c *S, int side, 
    merge_segment_c **hit, int *hit_side, double along)
{
  // Returns false if result was ambiguous (e.g. the closest
  // segment hit was parallel to the casting line).

  // Algorithm: cast a line (horizontal or vertical, depending
  // on the source segment's orientation) and test all segments
  // which intersect or touch it.

  double lx = MIN(S->start->x, S->end->x);
  double ly = MIN(S->start->y, S->end->y);

  double hx = MAX(S->start->x, S->end->x);
  double hy = MAX(S->start->y, S->end->y);

  double mx = S->start->x + (S->end->x - S->start->x) * along;
  double my = S->start->y + (S->end->y - S->start->y) * along;

  bool cast_vert = (hx-lx) > (hy-ly);

  merge_segment_c *best_seg  = NULL;
  bool       best_vert = false;
  int        best_side = 0;
  double     best_dist = 999999.0;

  for (int t = 0; t < (int)mug_segments.size(); t++)
  {
    merge_segment_c *T = mug_segments[t];

    if (T == S)
      continue;

    if (cast_vert)
    {
      /* vertical cast line */

      double ss = T->start->x - mx;
      double ee = T->end->x   - mx;

      if (MAX(ss, ee) < -EPSILON || MIN(ss, ee) > EPSILON)
        continue;  // no intersection

      // compute distance from S to T
      double dist;

      if (fabs(ss) <= EPSILON)
        dist = T->start->y - my;
      else if (fabs(ee) <= EPSILON)
        dist = T->end->y - my;
      else
      {
        double iy = T->start->y + (T->end->y - T->start->y) * fabs(ss) / fabs(ss - ee);
        dist = iy - my;
      }

      // correct the sign based on 'side' and orientation of S
      if ((S->start->x < S->end->x) == (side == 0))
          dist = -dist;

      if (dist <= EPSILON)
        continue; // intersects on wrong side

      if (dist < best_dist)
      {
        best_dist = dist;
        best_seg  = T;
        best_vert = (fabs(ss) <= EPSILON || fabs(ee) <= EPSILON);
        best_side = side;

        if (S->end->x > S->start->x) best_side ^= 1;
        if (T->end->x < T->start->x) best_side ^= 1;
      }
    }
    else
    {
      /* horizontal cast line */

      double ss = T->start->y - my;
      double ee = T->end->y   - my;

      if (MAX(ss, ee) < -EPSILON || MIN(ss, ee) > EPSILON)
        continue;  // no intersection

      // compute distance from S to T
      double dist;

      if (fabs(ss) <= EPSILON)
        dist = T->start->x - mx;
      else if (fabs(ee) <= EPSILON)
        dist = T->end->x - mx;
      else
      {
        double ix = T->start->x + (T->end->x - T->start->x) * fabs(ss) / fabs(ss - ee);
        dist = ix - mx;
      }

      // correct the sign based on 'side' and orientation of S
      if ((S->start->y < S->end->y) != (side == 0))
          dist = -dist;

      if (dist <= EPSILON)
        continue; // intersects on wrong side

      if (dist < best_dist)
      {
        best_dist = dist;
        best_seg  = T;
        best_vert = (fabs(ss) <= EPSILON || fabs(ee) <= EPSILON);
        best_side = side;

        if (S->end->y > S->start->y) best_side ^= 1;
        if (T->end->y < T->start->y) best_side ^= 1;
      }
    }

  }

  // hitting a vertex is bad (can be ambiguous)
  if (best_vert)
    return false;

  if (best_seg)
  {
    *hit = best_seg;
    *hit_side = best_side;
  }
  else
  {
    *hit = NULL;
    *hit_side = 0;
  }

  return true;
}

static merge_region_c *FindIslandParent(merge_region_c *R)
{
  // there is a small possibility that every segment we test
  // will hit a vertex opposite it.  So when that happens we
  // need to try a different 'along' value.
  static const double along_tries[] =
  {
         0.5, 0.55, 0.45,
    0.6, 0.4, 0.65, 0.35,
    0.7, 0.3, 0.75, 0.25,
    0.8, 0.2, 0.85, 0.15,
    0.9, 0.1, 0.95, 0.05,

    -1 // THE END
  };

  for (int a = 0; along_tries[a] > 0; a++)
  {
    for (int i = 0; i < (int)mug_segments.size(); i++)
    {
      merge_segment_c *S = mug_segments[i];
      merge_segment_c *T;

      int S_side;
      int T_side;

      if (S->front == R)
        S_side = 0;
      else if (S->back == R)
        S_side = 1;
      else
        continue;

      if (! GetOppositeSegment(S, S_side, &T, &T_side, along_tries[a]))
      {
        continue;
      }

      if (! T)
      {
        return NULL;  // edge of map
      }

      merge_region_c *R_opp = (T_side == 0) ? T->front : T->back;

      if (R_opp != R)
        return R_opp;
    }
  }

  Main_FatalError("FindIslandParent: cannot find container!\n");
  return NULL; /* NOT REACHED */
}

static void ReplaceRegion(merge_region_c *R_old, merge_region_c *R_new)
{
  // NOTE: R_new can be NULL
 
  for (unsigned int i = 0; i < R_old->segs.size(); i++)
  {
    merge_segment_c *S = R_old->segs[i];

    if (R_new)
      R_new->AddSeg(S);

    if (S->front == R_old) S->front = R_new;
    if (S->back  == R_old) S->back  = R_new;

    if (S->back && ! S->front)
      S->Flip();
  }
}

static void Mug_RemoveIslands(void)
{
  // Algorithm:
  //
  // For each island (i.e. region->faces_out is true), cast a
  // line outwards from one of the segments and see what we hit.
  // If we hit nothing at all, the region is the edge of the map.
  // If we hit ourselves, need to try another segment.

  for (unsigned int i = 0; i < mug_regions.size(); i++)
  {
    merge_region_c *R = mug_regions[i];
    
    if (R->faces_out)
    {
      merge_region_c *parent = FindIslandParent(R);

      ReplaceRegion(R, parent);

      mug_regions[i] = NULL; // kill it
      delete R;
    }
  }

  // remove the NULL pointers
  std::vector<merge_region_c *>::iterator ENDP;

  ENDP = std::remove(mug_regions.begin(), mug_regions.end(), (merge_region_c*)NULL);

  mug_regions.erase(ENDP, mug_regions.end());
}


//------------------------------------------------------------------------

static bool BrushContainsRegion(csg_brush_c *B, merge_region_c *R)
{
  // fast test for rectangular brushes
  if (B->bflags & BRU_IF_Quad)
  {
    return (R->min_x >= B->min_x - QUANTIZE_GRID) &&
           (R->min_y >= B->min_y - QUANTIZE_GRID) &&
           (R->max_x <= B->max_x + QUANTIZE_GRID) &&
           (R->max_y <= B->max_y + QUANTIZE_GRID);
  }

  // check each vertex of region against each half-plane of brush

  // TODO: optimise by only testing one of a bunch of co-linear sides

  for (unsigned int k=0; k < B->verts.size(); k++)
  {
    brush_vert_c *v1 = B->verts[k];
    brush_vert_c *v2 = B->verts[(k+1) % B->verts.size()];

    merge_vertex_c *m1 = v1->partner;
    merge_vertex_c *m2 = v2->partner;

    // TODO: optimise : pick three/four vertices to test (min-x, max-x, min-y, max-y)

    for (unsigned int j=0; j < R->segs.size(); j++)
    {
      merge_segment_c *S = R->segs[j];

      if (PerpDist(S->start->x, S->start->y, m1->x, m1->y, m2->x, m2->y) > QUANTIZE_GRID)
        return false;

      if (PerpDist(S->end->x, S->end->y, m1->x, m1->y, m2->x, m2->y) > QUANTIZE_GRID)
        return false;
    }
  }

  return true;
}

static void Mug_AssignBrushes(void)
{
  // Algorithm:
  //
  // For each brush, check every region to see if it lies
  // completely within the brush.
  //
  // We optimise this by iterating over the brush list and
  // region list in order of minimum X coordinate.

  // TODO: consider using quadtrees so that vertical separation
  //       can be used to reduce the number of brush/region
  //       checks even further.

  unsigned int j, k;

  for (k=0; k < mug_regions.size(); k++)
    mug_regions[k]->ComputeBBox();

  std::sort(all_brushes.begin(), all_brushes.end(),
            Compare_BrushMinX_pred());

  std::sort(mug_regions.begin(), mug_regions.end(),
            Compare_RegionMinX_pred());

  unsigned int first_reg = 0;

  for (j=0; j < all_brushes.size(); j++)
  {
    csg_brush_c *B = all_brushes[j];

    if (! do_clip_brushes && B->bkind == BKIND_Clip)
      continue;

// unsigned int orig_ff = first_reg;

    for (k=first_reg; k < mug_regions.size(); k++)
    {
      merge_region_c *R = mug_regions[k];

      // check whether bounding boxes _touch_
      if (R->min_x > B->max_x - EPSILON)
        break;

      if (R->max_x < B->min_x + EPSILON)
      {
        if (k == first_reg)
          first_reg++;

        continue;
      }

      if (R->min_y > B->max_y - EPSILON ||
          R->max_y < B->min_y + EPSILON)
        continue;

      SYS_ASSERT(! R->HasBrush(B));

      if (BrushContainsRegion(B, R))
      {
        R->AddBrush(B);
      }
    }

// DebugPrintf("Brush %u/%u : checked %u regions\n", j, all_brushes.size(), k - orig_ff);

  }

  // Double check using f_sides / b_sides
 
  // FIXME
}

static void Mug_DiscoverGaps(void)
{
  // Algorithm:
  // 
  // sort the brushes by ascending z1 values.
  // Hence any gap must occur between two adjacent entries.
  // We also must check the gap is not covered by a previous
  // brush, done by maintaining a ref to the brush with the
  // currently highest z2 value.

  for (unsigned int i = 0; i < mug_regions.size(); i++)
  {
    merge_region_c *R = mug_regions[i];

    std::sort(R->brushes.begin(), R->brushes.end(),
              Compare_BrushZ1_pred());

    if (R->brushes.size() <= 1)
      continue;

    csg_brush_c *high = R->brushes[0];

    for (unsigned int k = 1; k < R->brushes.size(); k++)
    {
      csg_brush_c *A = R->brushes[k];

      // skip the "ephemeral" brushes
      if (high->bkind == BKIND_Liquid || high->bkind == BKIND_Rail ||
          high->bkind == BKIND_Light)
      {
        high = A;
        continue;
      }
      else if (A->bkind == BKIND_Liquid || A->bkind == BKIND_Rail ||
               A->bkind == BKIND_Light)
      {
        continue;
      }

      if (A->b.z > high->t.z + EPSILON)
      {
        // found a gap
        merge_gap_c *gap = new merge_gap_c(R, high, A);

        R->gaps.push_back(gap);

        high = A;
        continue;
      }

      // no gap implies that these two brushes touch/overlap,
      // hence update the highest one.
      
      if (A->t.z > high->t.z)
        high = A;
    }
  }
}


static void MarkNeighbouringGaps(merge_gap_c *B, merge_gap_c *F)
{
  // check if already marked
  std::vector<merge_gap_c *>::iterator GI;

  for (GI = B->neighbors.begin(); GI != B->neighbors.end(); GI++)
    if (*GI == F)
      return;

  B->neighbors.push_back(F);
  F->neighbors.push_back(B);
}

static void Mug_GapNeighbors(void)
{
  // TODO: optimise this by only checking each region-region pair once

  for (unsigned int i = 0; i < mug_segments.size(); i++)
  {
    merge_segment_c *S = mug_segments[i];

    if (! S->back || ! S->front)
      continue;

    SYS_ASSERT(S->back != S->front);

    // gaps are sorted from lowest to highest, hence we can optimise
    // the comparison using a staggered approach.
    unsigned int b_idx = 0;
    unsigned int f_idx = 0;

    while (b_idx < S->back->gaps.size() && f_idx < S->front->gaps.size())
    {
      merge_gap_c *B = S->back ->gaps[b_idx];
      merge_gap_c *F = S->front->gaps[f_idx];

      double B_z1 = B->b_brush->t.z;
      double B_z2 = B->t_brush->b.z;

      double F_z1 = F->b_brush->t.z;
      double F_z2 = F->t_brush->b.z;

      if (B_z2 < F_z1 + EPSILON)
      {
        b_idx++; continue;
      }
      if (F_z2 < B_z1 + EPSILON)
      {
        f_idx++; continue;
      }

      // overlap found
      MarkNeighbouringGaps(B, F);

      if (F_z2 < B_z2)
        f_idx++;
      else
        b_idx++;
    }
  }
}


static merge_segment_c *ClosestSegmentToPoint(double x, double y, bool *hit_vertex)
{
  // Note: assumes segments are sorted by minimum X
  //
  // Algorithm: cast a line vertically (upwards and downwards) and
  //            see which segments we hit.  Note that the result
  //            might hit at a vertex.

  merge_segment_c *closest_up   = NULL;
  merge_segment_c *closest_down = NULL;

  double up_dist   = 9e9;
  double down_dist = 9e9;

  for (unsigned int i = 0; i < mug_segments.size(); i++)
  {
    merge_segment_c *S = mug_segments[i];

    if (MAX(S->start->x, S->end->x) < x - EPSILON)
      continue;

    if (MIN(S->start->x, S->end->x) > x + EPSILON)
      break;

    // skip vertical segments (prevent division by zero)
    if (fabs(S->start->x - S->end->x) < 2*EPSILON)
      continue;

    double iy = S->start->y + (S->end->y - S->start->y) * (x - S->start->x) / (S->end->x - S->start->x);
    double dist = iy - y;

    if (dist >= 0)
    {
      if (! closest_up || dist < up_dist)
      {
        closest_up = S;
        up_dist = dist;
      }
    }
    else
    {
      dist = -dist;

      if (! closest_down || dist < down_dist)
      {
        closest_down = S;
        down_dist = dist;
      }
    }
  }

  *hit_vertex = false;

  if (closest_up &&
      fabs(x - closest_up->start->x) > EPSILON &&
      fabs(x - closest_up->end  ->x) > EPSILON)
  {
    return closest_up;
  }

  if (closest_down &&
      fabs(x - closest_down->start->x) > EPSILON &&
      fabs(x - closest_down->end  ->x) > EPSILON)
  {
    return closest_down;
  }

  *hit_vertex = true;

  return closest_up ? closest_up : closest_down;
}


merge_region_c *CSG2_FindRegionForPoint(double x, double y)
{
  // it is possible that we hit vertices both up and down, so
  // for that case we need to try a slightly moved point.
  static const double along_tries[13] =
  {
    0.0,  +0.05, -0.05,  +0.10, -0.10,
          +0.15, -0.15,  +0.20, -0.20,
          +0.25, -0.25,  +0.35, -0.35
  };

  for (int a = 0; a < 13; a++)
  {
    double xx = x + along_tries[a];

    bool hit_vertex;

    merge_segment_c *S = ClosestSegmentToPoint(xx, y, &hit_vertex);

    if (! S)
    {
      if (a == 0)
        return NULL; // outside map?

      continue;
    }

    if (hit_vertex)
      continue;

    // determine side
    double perp = PerpDist(xx, y, S->start->x, S->start->y, S->end->x, S->end->y);

    // kludge for sitting on a one-sided line
    if (fabs(perp) < 0.2 && ! S->back)
      return S->front;

    merge_region_c *R = (perp < 0) ? S->back : S->front;

    return R;
  }

  return NULL;
}


static merge_gap_c *FindGapForPoint(merge_region_c *R, double x, double y, double z)
{
  for (unsigned int k = 0; k < R->gaps.size(); k++)
  {
    merge_gap_c *gap = R->gaps[k];

    // allow some leeway
    double z1 = (gap->b_brush->b.z + gap->b_brush->t.z) / 2.0;
    double z2 = (gap->t_brush->b.z + gap->t_brush->t.z) / 2.0;

    if (z1 < z && z < z2)
      return gap;
  }

  return NULL; // not found
}

static void Mug_PlaceEntities(void)
{
  /* sort segments in order of minimum X coordinate */
  std::sort(mug_segments.begin(), mug_segments.end(),
            Compare_SegmentMinX_pred());

  for (unsigned int i = 0; i < all_entities.size(); i++)
  {
    entity_info_c *E = all_entities[i];

    merge_region_c *R = CSG2_FindRegionForPoint(E->x, E->y);

    if (! R || R->gaps.size() == 0)
    {
      // TODO: error for important entities (esp. Players)
      LogPrintf("WARNING: cannot find region for entity '%s' @ (%1.0f,%1.0f)\n",
                E->name.c_str(), E->x, E->y);
      continue;
    }

    merge_gap_c *gap = FindGapForPoint(R, E->x, E->y, E->z);

    if (! gap)
    {
      LogPrintf("WARNING: entity '%s' is inside solid @ (%1.0f,%1.0f,%1.0f)\n",
                E->name.c_str(), E->x, E->y, E->z);
      gap = R->gaps[0];
    }

    gap->entities.push_back(E);

    gap->reachable = true;
  }
}


static void Mug_FillUnusedGaps(void)
{
  // Algorithm: spread the 'reachable' flag from each gap to
  //            every neighbour, until it cannot spread any
  //            further.  Then all gaps without the flag are
  //            unreachable and should be filled.

  // TODO: a lua mechanism to force the reachable flag
  int changes;

  do
  {
    changes = 0;

    for (unsigned int i = 0; i < mug_regions.size(); i++)
    {
      merge_region_c *R = mug_regions[i];

      for (unsigned int k = 0; k < R->gaps.size(); k++)
      {
        merge_gap_c *G = R->gaps[k];

        if (! G->reachable)
          continue;

        for (unsigned int n = 0; n < G->neighbors.size(); n++)
        {
          merge_gap_c *H = G->neighbors[n];

          if (! H->reachable)
          {
            H->reachable = true;
            changes++;
          }
        }
      }
    }
  } while (changes > 0);

  // statistics
  int gap_total  = 0;
  int gap_filled = 0;

  for (unsigned int i = 0; i < mug_regions.size(); i++)
  {
    merge_region_c *R = mug_regions[i];

    for (unsigned int k = 0; k < R->gaps.size(); k++)
    {
      merge_gap_c *G = R->gaps[k];

      gap_total++;

      if (G->reachable)
        continue;

      gap_filled++;

      delete G;
      R->gaps[k] = NULL;
    }

    // remove the NULL pointers
    std::vector<merge_gap_c *>::iterator ENDP =
         std::remove(R->gaps.begin(), R->gaps.end(), (merge_gap_c*)NULL);
    R->gaps.erase(ENDP, R->gaps.end());
  }

  if (gap_filled == gap_total)
  {
    Main_FatalError("CSG2: all gaps were unreachable (no entities?)\n");
  }

  LogPrintf("CSG2: filled %d gaps (of %d total)\n", gap_filled, gap_total);
}


void CSG2_MergeAreas(bool do_clips)
{
  // this takes all the brushes, figures out what OVERLAPS
  // (on the 2D map), and performs the CSG operations to create
  // new brushes for the overlapping parts [NOT REALLY NEW BRUSHES].
  //
  // also figures out which brushes are TOUCHING, and ensures
  // there are vertices where needed (at 'T' junctions).

  // Algorithm:
  //   (1) create segments and vertices for every line
  //   (2) check seg against every other seg for overlap/T-junction
  //   (3) create regions from segs, remove islands
  //   (4) assign brushes to the regions
  //   (5) find the gaps and their neighbors
  //   (6) place every entity into a gap
  //   (7) remove gaps which no entity can reach

  do_clip_brushes = do_clips;

  QUANTIZE_GRID = 0.1;

  ClearVertexHash();

  for (unsigned int j=0; j < all_brushes.size(); j++)
  {
    Mug_MakeSegments(all_brushes[j]);
  }

  CSG2_UpdateBounds(false /* three_d */);

  Mug_FindOverlaps();
  Mug_TraceSegLoops();
  Mug_RemoveIslands();

  Mug_AssignBrushes();

  Mug_DiscoverGaps();
  Mug_GapNeighbors();

  Mug_PlaceEntities();
  Mug_FillUnusedGaps();

  CSG2_UpdateBounds(true /* three_d */);
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
