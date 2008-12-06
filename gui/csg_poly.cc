//------------------------------------------------------------------------
//  2.5D Constructive Solid Geometry
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

#include <algorithm>

#include "lib_util.h"
#include "main.h"

#include "csg_main.h"
#include "g_lua.h"
#include "ui_dialog.h"


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

merge_segment_c * merge_vertex_c::FindSeg(merge_vertex_c *other)
{
  for (unsigned int j=0; j < segs.size(); j++)
    if (segs[j]->Match(this, other))
      return segs[j];

  return NULL;  // not found
}
 

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
  merge_vertex_c *tmp_V = start; start = end; end = tmp_V;

  merge_region_c *tmp_R = front; front = back; back = tmp_R;

  std::swap(f_sides, b_sides);
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


static std::vector<merge_segment_c *> mug_new_segs;

static int mug_changes = 0;


static merge_vertex_c *Mug_AddVertex(double x, double y)
{
  // check if already present (FIXME: OPTIMISE !!)

  for (int i=0; i < (int)mug_vertices.size(); i++)
    if (mug_vertices[i]->Match(x, y))
      return mug_vertices[i];

  merge_vertex_c * V = new merge_vertex_c(x, y);

  mug_vertices.push_back(V);

  return V;
}

static merge_segment_c *Mug_AddSegment(merge_vertex_c *start, merge_vertex_c *end)
{
  SYS_ASSERT(start != end);

  // check if already present
  merge_segment_c *S = start->FindSeg(end);

  if (S)
  {
//  SYS_ASSERT(end->FindSeg(start) == S);
    return S;
  }

// SYS_ASSERT(! end->FindSeg(start));

///--- for (int i=0; i < (int)mug_segments.size(); i++)
///--- if (mug_segments[i]->Match(start, end))
///--- Main_FatalError("FUCK!!!!\n");

  S = new merge_segment_c(start, end);

  // check for zero-length lines
  double dist = MAX(fabs(start->x - end->x), fabs(start->y - end->y));

  if (dist < EPSILON*2)
      Main_FatalError("Line loop contains zero-length line! (%1.1f,%1.1f)\n",
             start->x, start->y);
 
  mug_segments.push_back(S);

  start->AddSeg(S);
  end  ->AddSeg(S);

  return S;
}

static void Mug_MakeSegments(csg_brush_c *P)
{
  for (int k=0; k < (int)P->verts.size(); k++)
  {
    area_vert_c *v1 = P->verts[k];
    area_vert_c *v2 = P->verts[(k+1) % (int)P->verts.size()];

    merge_vertex_c *new_v1 = Mug_AddVertex(v1->x, v1->y);
    merge_vertex_c *new_v2 = Mug_AddVertex(v2->x, v2->y);

    // swap vertices so that segment faces inward
    Mug_AddSegment(new_v2, new_v1);

    // associate the new vertex with the area_vert
    v1->partner = new_v1;
    v2->partner = new_v2;
  }
}

static void Mug_SplitSegment(merge_segment_c *S, merge_vertex_c *V)
{
#if 0  // DEBUG CHECK
  {
    double d1 = MAX(fabs(S->start->x - V->x), fabs(S->start->y - V->y));
    double d2 = MAX(fabs(S->end  ->x - V->x), fabs(S->end  ->y - V->y));

    if (d1 < EPSILON || d2 < EPSILON)
    {
      Main_FatalError("INTERNAL ERROR: Mug_SplitSegment bad split point\n"
           "Segment = (%1.5f %1.5f) .. (%1.5f %1.5f)\n"
           "Vertex  = (%1.5f %1.5f)\n",
           S->start->x, S->start->y, S->end->x, S->end->y, V->x, V->y);
    }
  }
#endif
  
  merge_segment_c *NS = new merge_segment_c(V, S->end);

  S->end = V;

  mug_new_segs.push_back(NS);

  // update join info

  NS->end->ReplaceSeg(S, NS);

  V->AddSeg(S);
  V->AddSeg(NS);

  mug_changes++;
}

struct SegDead_pred
{
  inline bool operator() (const merge_segment_c *S) const
  {
    return ! S->start;
  }
};

static void Mug_AdjustList(void)
{
  /* Removes dead segs and Appends new segs */

  std::vector<merge_segment_c *>::iterator ENDP;

  ENDP = std::remove_if(mug_segments.begin(), mug_segments.end(), SegDead_pred());

#if 0
fprintf(stderr, ".. %d new segments, %d dead ones\n",
       (int)mug_new_segs.size(), (int)(mug_segments.end() - ENDP));
#endif

  mug_segments.erase(ENDP, mug_segments.end());


  while (mug_new_segs.size() > 0)
  {
    merge_segment_c *S = mug_new_segs.back();

    mug_new_segs.pop_back();
    mug_segments.push_back(S);
  }
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
    return A->z1 < B->z1;
  }
};


static void Mug_OverlapPass(void)
{
  /* sort segments in order of minimum X coordinate */
  std::sort(mug_segments.begin(), mug_segments.end(),
            Compare_SegmentMinX_pred());

  for (int i=0; i < (int)mug_segments.size(); i++)
  {
    merge_segment_c *A = mug_segments[i];

    for (int k=i+1; k < (int)mug_segments.size(); k++)
    {
      merge_segment_c *B = mug_segments[k];

      // skip deleted segments
      if (! A->start) break;
      if (! B->start) continue;

      double ax1 = A->start->x;
      double ay1 = A->start->y;
      double ax2 = A->end->x;
      double ay2 = A->end->y;

      double bx1 = B->start->x;
      double by1 = B->start->y;
      double bx2 = B->end->x;
      double by2 = B->end->y;

#if 1 // normal code
      if (MIN(bx1, bx2) > MAX(ax1, ax2)+EPSILON)
        break;
#else // non-sorted method (TESTING only)
      if (MIN(bx1, bx2) > MAX(ax1, ax2)+EPSILON ||
          MIN(ax1, ax2) > MAX(bx1, bx2)+EPSILON)
        continue;
#endif

      if (MIN(by1, by2) > MAX(ay1, ay2)+EPSILON ||
          MIN(ay1, ay2) > MAX(by1, by2)+EPSILON)
        continue;

      /* to get here, the bounding boxes must touch or overlap.
       * now we perform the line-line intersection test.
       */

///fprintf(stderr, "\nA = (%1.4f %1.4f) .. (%1.4f %1.4f)\n", ax1,ay1, ax2,ay2);
///fprintf(stderr,   "B = (%1.4f %1.4f) .. (%1.4f %1.4f)\n", bx1,by1, bx2,by2);

      double ap1 = PerpDist(ax1,ay1, bx1,by1, bx2,by2);
      double ap2 = PerpDist(ax2,ay2, bx1,by1, bx2,by2);

      double bp1 = PerpDist(bx1,by1, ax1,ay1, ax2,ay2);
      double bp2 = PerpDist(bx2,by2, ax1,ay1, ax2,ay2);

      // does A cross B-extended-to-infinity?
      if ((ap1 >  EPSILON && ap2 >  EPSILON) ||
          (ap1 < -EPSILON && ap2 < -EPSILON))
        continue;

      // does B cross A-extended-to-infinity?
      if ((bp1 >  EPSILON && bp2 >  EPSILON) ||
          (bp1 < -EPSILON && bp2 < -EPSILON))
        continue;

      // check if on the same line
      if (fabs(bp1) <= EPSILON && fabs(bp2) <= EPSILON)
      {
#if 1
        // total overlap (same start + end points) ?
        if (A->Match(B))
        {
          B->Kill();
          mug_changes++;
          continue;
        }
#endif
        // find vertices that split a segment
        double a1_along = 0.0;
        double a2_along = AlongDist(ax2,ay2, ax1,ay1, ax2,ay2);
        double b1_along = AlongDist(bx1,by1, ax1,ay1, ax2,ay2);
        double b2_along = AlongDist(bx2,by2, ax1,ay1, ax2,ay2);

        if (b1_along > a1_along+EPSILON && b1_along < a2_along-EPSILON)
          Mug_SplitSegment(A, B->start);

        else if (b2_along > a1_along+EPSILON && b2_along < a2_along-EPSILON)
          Mug_SplitSegment(A, B->end);

        else if (a1_along > b1_along+EPSILON && a1_along < b2_along-EPSILON)
          Mug_SplitSegment(B, A->start);

        else if (a2_along > b1_along+EPSILON && a2_along < b2_along-EPSILON)
          Mug_SplitSegment(B, A->end);

        continue;
      }

      // check for sharing a single vertex
      // Note: **RELYING** on the fact that all vertices are unique
      if (A->start->Match(B->start) || A->start->Match(B->end) ||
          A->end  ->Match(B->start) || A->end  ->Match(B->end))
        continue;

      // check for T junction
      if (fabs(bp1) <= EPSILON)
      {
        Mug_SplitSegment(A, B->start);
        continue;
      }
      else if (fabs(bp2) <= EPSILON)
      {
        Mug_SplitSegment(A, B->end);
        continue;
      }
      else if (fabs(ap1) <= EPSILON)
      {
        Mug_SplitSegment(B, A->start);
        continue;
      }
      else if (fabs(ap2) <= EPSILON)
      {
        Mug_SplitSegment(B, A->end);
        continue;
      }

      /* pure cross-over */
      
      // add a new vertex at the intersection point
      double along = bp1 / (bp1 - bp2);

      double ix = bx1 + along * (bx2 - bx1);
      double iy = by1 + along * (by2 - by1);

#if 0
fprintf(stderr, ".. pure cross-over at (%1.2f, %1.2f)\n", ix, iy);
fprintf(stderr, "   A = (%1.0f,%1.0f) --> (%1.0f,%1.0f)\n", ax1,ay1, ax2,ay2);
fprintf(stderr, "   B = (%1.0f,%1.0f) --> (%1.0f,%1.0f)\n", bx1,by1, bx2,by2);
#endif

      merge_vertex_c * NV = Mug_AddVertex(ix, iy);
      
      Mug_SplitSegment(A, NV);
      Mug_SplitSegment(B, NV);
    }
  }
}

static void Mug_FindOverlaps(void)
{
  int loops = 0;

  do
  {
    SYS_ASSERT(loops < 1000);

    mug_changes = 0;

    Mug_OverlapPass();
    Mug_AdjustList();

    loops++;

  } while (mug_changes > 0);
}


//------------------------------------------------------------------------

static merge_segment_c *trace_seg;
static merge_vertex_c  *trace_vert;

static int    trace_side;
static double trace_angles;

static void TraceNext(void)
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
    SYS_ASSERT(fabs(angle) > ANGLE_EPSILON);

    if (angle < 0)
      angle += 360.0;

    SYS_ASSERT(angle > -ANGLE_EPSILON);
    SYS_ASSERT(angle < 360.0 + ANGLE_EPSILON);

    // should never have two segments with same angle (pt 2)
    SYS_ASSERT(fabs(best_angle - angle) > ANGLE_EPSILON);

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
}

static void TraceSegment(merge_segment_c *S, int side)
{
#if 0
fprintf(stderr, "TraceSegment (%1.1f,%1.1f) .. (%1.1f,%1.1f) side:%d\n",
S->start->x, S->start->y,
S->end->x, S->end->y, side);
#endif
  
  merge_region_c *R = new merge_region_c();

  mug_regions.push_back(R);


  trace_seg  = S;
  trace_vert = S->start;
  trace_side = side;

  trace_angles = 0.0;
 
  int count = 0;

  do
  {
    TraceNext();

#if 0
fprintf(stderr, "  CUR SEG (%1.1f,%1.1f) .. (%1.1f,%1.1f)\n",
trace_seg->start->x, trace_seg->start->y,
trace_seg->end->x, trace_seg->end->y);

fprintf(stderr, "  CUR VERT: %s\n",
(trace_vert == trace_seg->start) ? "start" :
(trace_vert == trace_seg->end) ? "end" : "FUCKED");
#endif

    if ((trace_vert == trace_seg->start) == (side == 0))
    {
      // TODO: this assert indicates we hit some dead-end or
      //       non-returning loop.  Make it a mere WARNING.
      SYS_ASSERT(! trace_seg->front);
      trace_seg->front = R;

      R->AddSeg(trace_seg);
    }
    else
    {
      SYS_ASSERT(! trace_seg->back);
      trace_seg->back = R;

      R->AddSeg(trace_seg);
    }

    count++;

    SYS_ASSERT(count < 9000);
  }
  while (trace_seg != S);

  SYS_ASSERT(count >= 3);

  R->faces_out = (trace_angles / count) > 180.0;

//fprintf(stderr, "DONE\n\n");
}

static void Mug_TraceSegLoops(void)
{
  // Algorithm:
  //
  // starting at a untraced seg and a particular vertex of
  // that seg, follow the segs around in the tightest loop
  // possible until we get back to the beginning.  The result
  // will form a 'merged_area' (i.e. a "sector" for Doom).
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
    0.5, 0.7, 0.3, 0.6, 0,4,
    0,8, 0.2, 0.9, 0.1,

    0.55, 0.45, 0.65, 0.35, 0.75, 0.25,
    0.85, 0.15, 0.95, 0.05,

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

static merge_segment_c *FindAlongSeg(merge_vertex_c *v1, merge_vertex_c *v2)
{
  double v_angle = CalcAngle(v1->x, v1->y, v2->x, v2->y);

  for (unsigned int k = 0; k < v1->segs.size(); k++)
  {
    merge_segment_c *S = v1->segs[k];

    merge_vertex_c *other = S->Other(v1);

    double s_angle = CalcAngle(v1->x, v1->y, other->x, other->y);

    double diff = fabs(v_angle - s_angle);
    
    if (diff <= ANGLE_EPSILON)
      return S;

    // handle corner cases where one angle is very close to 0 and
    // the other angle is very close to 360.
    if (diff >= 360.0 - ANGLE_EPSILON)
      return S;
  }

  // Note: we can't ignore this problem, otherwise the boundary
  //       of the brush could remain open, and hence the brush
  //       would be spread into every region -- NOT GOOD!
  Main_FatalError("CSG2: cannot find segment (angle:%1.1f @ %1.0f,%1.0f)!\n",
                  v_angle, v1->x, v1->y);

  return NULL;  // not found
}

static void MarkBoundaryRegions(csg_brush_c *P, std::vector<merge_region_c *> & regions)
{
  for (int k=0; k < (int)P->verts.size(); k++)
  {
    area_vert_c *v1 = P->verts[k];
    area_vert_c *v2 = P->verts[(k+1) % (int)P->verts.size()];

    SYS_ASSERT(v1->partner);
    SYS_ASSERT(v2->partner);

    double along = 0;

    merge_vertex_c *V = v1->partner;

    while (V != v2->partner)
    {
      merge_segment_c *S = FindAlongSeg(V, v2->partner);
      if (! S)
        break;

      if (S->start == V)
        S->b_sides.push_back(v1);
      else
        S->f_sides.push_back(v1);

      merge_region_c *R = (S->start == V) ? S->back : S->front;

      if (R && ! R->HasBrush(P))
      {
        R->AddBrush(P);

        regions.push_back(R);
      }

      S->border_of = P;

      V = S->Other(V);
    }
  }
}

static void MarkInnerRegions(csg_brush_c *P, std::vector<merge_region_c *> & regions)
{
  int loops = 0;

  for (;;)
  {
    SYS_ASSERT(loops < 100);

    std::vector<merge_region_c *> new_regs;

    for (unsigned k = 0; k < regions.size(); k++)
    {
      merge_region_c *R = regions[k];

      for (unsigned j = 0; j < R->segs.size(); j++)
      {
        merge_segment_c *S = R->segs[j];

        if (! (S->front && S->back))
          continue;

        // contain the virus
        if (S->border_of == P)
          continue;

        bool got_back  = S->back ->HasBrush(P);
        bool got_front = S->front->HasBrush(P);

        if (got_back != got_front)
        {
          merge_region_c *R = got_back ? S->front : S->back;

          R->AddBrush(P);

          new_regs.push_back(R);
        }
      }
    }

    // stop when it cannot spread any further
    if (new_regs.size() == 0)
      return;

    loops++;

    std::swap(regions, new_regs);
  }
}

static void Mug_AssignAreas(void)
{
  // Algorithm:

  // For each brush, iterate over each line in the loop.
  // Since vertices are never removed (only added), we will
  // always be able to find the first vertex of each line.
  // Check each segment along the line and mark the merge_region_c
  // on the correct side as belonging to our brush.
  // 
  // BUT WAIT, THERE'S MORE!
  //
  // The above logic will not find regions that are fully inside
  // the brush (no vertices touching the outer line loop).
  // However it is sufficient to simply "spread" the brush
  // from each "infected" merge_region_c to every neighbour as
  // long as the crossing segment is not part of the csg_brush_c
  // boundary.

  for (unsigned int j=0; j < all_brushes.size(); j++)
  {
    csg_brush_c *P = all_brushes[j];

    std::vector<merge_region_c *> regions;

    MarkBoundaryRegions(P, regions);

    MarkInnerRegions(P, regions);
  }
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

      if (A->z1 > high->z2 + EPSILON)
      {
        // found a gap
        merge_gap_c *gap = new merge_gap_c(R, high, A);

        R->gaps.push_back(gap);

        high = A;
        continue;
      }

      // no gap implies that these two brushes touch/overlap,
      // hence update the highest one.
      
      if (A->z2 > high->z2)
        high = A;
    }
  }
}


static void MarkNeighbouringGaps(merge_gap_c *B, merge_gap_c *F)
{
  // check if already marked
  std::vector<merge_gap_c *>::iterator GI;

  for (GI = B->neighbours.begin(); GI != B->neighbours.end(); GI++)
    if (*GI == F)
      return;

  B->neighbours.push_back(F);
  F->neighbours.push_back(B);
}

static void Mug_GapNeighbours(void)
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

      double B_z1 = B->b_brush->z2;
      double B_z2 = B->t_brush->z1;

      double F_z1 = F->b_brush->z2;
      double F_z2 = F->t_brush->z1;

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
    if (fabs(S->start->x - S->end->x) < EPSILON*4)
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

static merge_region_c *FindRegionForPoint(double x, double y)
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

bool CSG2_PointInSolid(double x, double y)
{
  merge_region_c *R = FindRegionForPoint(x, y);

  return ! (R && R->gaps.size() > 0);
}


static merge_gap_c *FindGapForPoint(merge_region_c *R, double x, double y, double z)
{
  for (unsigned int k = 0; k < R->gaps.size(); k++)
  {
    merge_gap_c *gap = R->gaps[k];

    // allow some leeway
    double z1 = (gap->b_brush->z1 + gap->b_brush->z2) / 2.0;
    double z2 = (gap->t_brush->z1 + gap->t_brush->z2) / 2.0;

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

    merge_region_c *R = FindRegionForPoint(E->x, E->y);

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

        for (unsigned int n = 0; n < G->neighbours.size(); n++)
        {
          merge_gap_c *H = G->neighbours[n];

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


void CSG2_MergeAreas(void)
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
  //   (5) find the gaps and their neighbours
  //   (6) place every entity into a gap
  //   (7) remove gaps which no entity can reach

  mug_new_segs.clear(); // should be empty, but just in case

  for (unsigned int j=0; j < all_brushes.size(); j++)
  {
    csg_brush_c *P = all_brushes[j];
    SYS_ASSERT(P);

    Mug_MakeSegments(P);
  }

  Mug_FindOverlaps();
  Mug_TraceSegLoops();
  Mug_RemoveIslands();

  Mug_AssignAreas();

  Mug_DiscoverGaps();
  Mug_GapNeighbours();

  Mug_PlaceEntities();
  Mug_FillUnusedGaps();
}



//--- editor settings ---
// vi:ts=2:sw=2:expandtab
