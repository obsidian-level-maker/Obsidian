//------------------------------------------------------------------------
//  CSG : QUAKE I and II
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

#include <algorithm>

#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "lib_file.h"
#include "lib_util.h"

#include "main.h"
#include "m_lua.h"

#include "q_common.h"
#include "q_light.h"
#include "q_vis.h"

#include "csg_main.h"
#include "csg_local.h"
#include "csg_quake.h"


#define FACE_MAX_SIZE  240


#if 0

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
#endif



// an "intersection" remembers the vertex that touches a BSP divider
// line (especially a new vertex that is created at a seg split).

// Note: two points can exist in the intersection list with
//       the same along value but different dirs.
typedef struct
{
  // how far along the partition line the vertex is.
  // bigger value are further along the partition line.
  double along;

  // quantized along value
  int q_dist;

  // direction that miniseg will touch, +1 for further along
  // the partition, and -1 for backwards on the partition.
  // The values +2 and -2 indicate REMOVED points.
  int dir;

  // this is only set after MergeIntersections().
  double next_along;
}
intersect_t;


struct intersect_qdist_Compare
{
  inline bool operator() (const intersect_t& A, const intersect_t& B) const
  {
    if (A.q_dist != B.q_dist)
      return A.q_dist < B.q_dist;

    return A.dir < B.dir;
  }
};


static void AddIntersection(std::vector<intersect_t> & cut_list,
                            double along, int dir)
{
  intersect_t new_cut;

  new_cut.along = along;
  new_cut.q_dist = I_ROUND(along * 21.6f);
  new_cut.dir = dir;
  new_cut.next_along = -1e30;

  cut_list.push_back(new_cut);
}


static void MergeIntersections(std::vector<intersect_t> & cut_list)
{
  if (cut_list.empty())
    return;

  // move input vector contents into a temporary vector, which we
  // sort and iterate over.  Valid intersections then get pushed
  // back into the input vector.

  std::vector<intersect_t> local_cuts;

  local_cuts.swap(cut_list);

  std::sort(local_cuts.begin(), local_cuts.end(),
            intersect_qdist_Compare());

  std::vector<intersect_t>::iterator A, B;

  A = local_cuts.begin();

  while (A != local_cuts.end())
  {
    if (A->dir != +1)
    {
      A++; continue;
    }

    B = A; B++;

    if (B == local_cuts.end())
      break;

    // this handles multiple +1 entries and also ensures
    // that the +2 "remove" entry kills a +1 entry.
    if (A->q_dist == B->q_dist)
    {
      A++; continue;
    }

    if (B->dir != -1)
    {
      DebugPrintf("WARNING: bad pair in intersection list\n");

      A = B; continue;
    }

    // found a viable intersection!
    A->next_along = B->along;

    cut_list.push_back(*A);

    B++; A = B; continue;
  }
}


//------------------------------------------------------------------------
//  NEW LOGIC
//------------------------------------------------------------------------

quake_node_c * qk_bsp_root;
quake_leaf_c * qk_solid_leaf;

std::vector<quake_face_c *>     qk_all_faces;
std::vector<quake_mapmodel_c *> qk_all_mapmodels;


class quake_side_c
{
public:
  snag_c *snag;

  quake_node_c * on_node;

  int node_side;  // 0 = front, 1 = back

  double x1, y1;
  double x2, y2;

public:
  // this is only for partitions
  quake_side_c() : snag(NULL), on_node(NULL), node_side(-1)
  { }

  quake_side_c(snag_c *S) :
      snag(S), on_node(NULL), node_side(-1),
      x1(S->x1), y1(S->y1), x2(S->x2), y2(S->y2)
  { }

  quake_side_c(const quake_side_c *other) :
      snag(other->snag), on_node(other->on_node), node_side(other->node_side),
      x1(other->x1), y1(other->y1), x2(other->x2), y2(other->y2)
  { }

  // make a "mini side"
  quake_side_c(quake_node_c *node, int _node_side,
               const quake_side_c *part,
               double along1, double along2) :
      snag(NULL), on_node(node), node_side(_node_side)
  {
    double sx, sy;
    double ex, ey;

    AlongCoord(along1, part->x1,part->y1, part->x2,part->y2, &sx, &sy);
    AlongCoord(along2, part->x1,part->y1, part->x2,part->y2, &ex, &ey);

    x1 = sx; y1 = sy;
    x2 = ex; y2 = ey;
  }

  ~quake_side_c()
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

    if (! snag->partner->region)
      return false;

    if (snag->partner->region->gaps.empty())
      return false;

    return true;
  }

  void ToPlane(quake_plane_c *plane)
  {
    plane->x = x1;
    plane->y = y1;
    plane->z = 0;

    plane->nx = (y2 - y1);
    plane->ny = (x1 - x2);
    plane->nz = 0;

    plane->Normalize();
  }
};


class quake_group_c
{
public:
  std::vector<quake_side_c *> sides;

  std::vector<csg_brush_c *> brushes;

public:
  quake_group_c() : sides(), brushes()
  { }

  ~quake_group_c()
  { }

  void AddSide(quake_side_c *S)
  {
    sides.push_back(S);
  }

  void AddBrush(csg_brush_c *B)
  {
    brushes.push_back(B);
  }

  bool IsEmpty() const
  {
    return sides.empty();
  }

  void CalcMid(double *mid_x, double *mid_y) const
  {
    SYS_ASSERT(! IsEmpty());

    *mid_x = 0;
    *mid_y = 0;

    for (unsigned int i = 0 ; i < sides.size() ; i++)
    {
      *mid_x += sides[i]->x1;
      *mid_y += sides[i]->y1;
    }

    *mid_x /= (double)sides.size();
    *mid_y /= (double)sides.size();
  }

  void GetGroupBounds(double *min_x, double *min_y,
                      double *max_x, double *max_y) const
  {
    *min_x = +9e9;  *max_x = -9e9;
    *min_y = +9e9;  *max_y = -9e9;

    for (unsigned int i = 0 ; i < sides.size() ; i++)
    {
      const quake_side_c *S = sides[i];

      double x1 = MIN(S->x1, S->x2);
      double y1 = MIN(S->y1, S->y2);
      double x2 = MAX(S->x1, S->x2);
      double y2 = MAX(S->y1, S->y2);

      *min_x = MIN(*min_x, x1);
      *min_y = MIN(*min_y, y1);
      *max_x = MAX(*max_x, x2);
      *max_y = MAX(*max_y, y2);
    }
  }
};


double quake_plane_c::CalcDist() const
{
  return (x * (double)nx) + (y * (double)ny) + (z * (double)nz);
}


void quake_plane_c::Flip()
{
  nx = -nx;
  ny = -ny;
  nz = -nz;
}


void quake_plane_c::Normalize()
{
  double len = sqrt(nx*nx + ny*ny + nz*nz);

  if (len > 0.000001)
  {
    nx /= len;
    ny /= len;
    nz /= len;
  }
}


void quake_leaf_c::AddFace(quake_face_c *F)
{
  faces.push_back(F);
}


void quake_leaf_c::AddSolid(csg_brush_c *B)
{
  solids.push_back(B);
}


quake_node_c::quake_node_c(const quake_plane_c& P) :
    plane(P),
    front_N(NULL), front_L(NULL),
     back_N(NULL),  back_L(NULL),
    faces(), index(-1)
{ }


void quake_node_c::AddFace(quake_face_c *F)
{
  F->node = this;

  faces.push_back(F);
}


int quake_node_c::CountNodes() const
{
  int count = 1;

  if (front_N) count += front_N->CountNodes();
  if ( back_N) count +=  back_N->CountNodes();

  return count;
}


int quake_node_c::CountLeafs() const
{
  int count = 0;

  if (front_N)
    count += front_N->CountLeafs();
  else if (front_L != qk_solid_leaf)
    count += 1;

  if (back_N)
    count += back_N->CountLeafs();
  else if (back_L != qk_solid_leaf)
    count += 1;

  return count;
}


quake_mapmodel_c::quake_mapmodel_c() :
    x1(0), y1(0), z1(0),
    x2(0), y2(0), z2(0),
    x_face(), y_face(), z_face(),
    firstface(0), numfaces(0), numleafs(0),
    light(64)
{
  for (int i = 0 ; i < 6 ; i++)
    nodes[i] = 0;
}


quake_mapmodel_c::~quake_mapmodel_c()
{ }


static void CreateSides(quake_group_c & group)
{
  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c *R = all_regions[i];

    if (R->gaps.empty())
      continue;

    for (unsigned int k = 0 ; k < R->snags.size() ; k++)
    {
      snag_c *snag = R->snags[k];

      region_c *N = snag->partner ? snag->partner->region : NULL;

      if (N && R->HasSameBrushes(N))
        continue;

      quake_side_c *S = new quake_side_c(snag);

      group.AddSide(S);
#if 0
fprintf(stderr, "New Side: %p %s (%1.0f %1.0f) .. (%1.0f %1.0f)\n",
        S, S->TwoSided() ? "2S" : "1S",
        S->x1, S->y1, S->x2, S->y2);
#endif
    }
  }
}


static void CreateBrushes(quake_group_c & group)
{
  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c *R = all_regions[i];

    for (unsigned int k = 0 ; k < R->brushes.size() ; k++)
    {
      csg_brush_c *B = R->brushes[k];

      if (B->bflags & BRU_IF_Seen)
        continue;

      if (B->bkind == BKIND_Solid || B->bkind == BKIND_Clip ||
          B->bkind == BKIND_Sky)
      {
        group.AddBrush(R->brushes[k]);

        B->bflags |= BRU_IF_Seen;
      }
    }
  }
}


static void CreateMiniSides(std::vector<intersect_t> & cut_list,
                            quake_node_c *node,
                            const quake_side_c *part,
                            quake_group_c & front, quake_group_c & back)
{
  for (unsigned int i = 0 ; i < cut_list.size() ; i++)
  {
    double along1 = cut_list[i].along;
    double along2 = cut_list[i].next_along;

    SYS_ASSERT(along1 < along2);

    quake_side_c *F = new quake_side_c(node, 0, part, along1, along2);
    quake_side_c *B = new quake_side_c(node, 1, part, along2, along1);

    front.AddSide(F);
     back.AddSide(B);
  }
}


static int Brush_TestSide(const csg_brush_c *B, const quake_side_c *part) 
{
  bool on_front = false;
  bool on_back  = false;

  for (unsigned int i = 0 ; i < B->verts.size() ; i++)
  {
    brush_vert_c * V = B->verts[i];

    double d = PerpDist(V->x,V->y, part->x1,part->y1, part->x2,part->y2);

    if (d >  Q_EPSILON) on_front = true;
    if (d < -Q_EPSILON) on_back  = true;

    // early out
    if (on_front && on_back)
      return 0;
  }

  return on_back ? -1 : +1;
}


static quake_side_c * SplitSideAt(quake_side_c *S, float new_x, float new_y)
{
  quake_side_c *T = new quake_side_c(S);

  S->x2 = T->x1 = new_x;
  S->y2 = T->y1 = new_y;

  return T;
}


// what: 0 for start, 1 for end
static inline double P_Along(const quake_side_c *p, const quake_side_c *S, int what)
{
  if (what == 0)
    return AlongDist(S->x1, S->y1, p->x1, p->y1, p->x2, p->y2);
  else
    return AlongDist(S->x2, S->y2, p->x1, p->y1, p->x2, p->y2);
}


static void Split_XY(quake_group_c & group,
                     quake_node_c *node, const quake_side_c *part,
                     quake_group_c & front, quake_group_c & back)
{
  std::vector<intersect_t> cut_list;

  std::vector<quake_side_c *> local_sides;
  std::vector<csg_brush_c  *> local_brushes;

  local_sides.  swap(group.sides);
  local_brushes.swap(group.brushes);

  for (unsigned int k = 0 ; k < local_sides.size() ; k++)
  {
    quake_side_c *S = local_sides[k];

    // get relationship of this side to the partition line
    double a = PerpDist(S->x1, S->y1,
                        part->x1,part->y1, part->x2,part->y2);

    double b = PerpDist(S->x2, S->y2,
                        part->x1,part->y1, part->x2,part->y2);

    int a_side = (a < -Q_EPSILON) ? -1 : (a > Q_EPSILON) ? +1 : 0;
    int b_side = (b < -Q_EPSILON) ? -1 : (b > Q_EPSILON) ? +1 : 0;

    if (a_side == 0 && b_side == 0)
    {
      // side sits on the partition
      S->on_node = node;

      if (VectorSameDir(part->x2 - part->x1, part->y2 - part->y1,
                        S->x2 - S->x1, S->y2 - S->y1))
      {
        front.AddSide(S);

        S->node_side = 0;

        // +2 and -2 mean "remove"
        AddIntersection(cut_list, P_Along(part, S, 0), +2);
        AddIntersection(cut_list, P_Along(part, S, 1), -2);
      }
      else
      {
        back.AddSide(S);

        S->node_side = 1;

        AddIntersection(cut_list, P_Along(part, S, 0), -2);
        AddIntersection(cut_list, P_Along(part, S, 1), +2);
      }
      continue;
    }

    if (a_side >= 0 && b_side >= 0)
    {
      front.AddSide(S);

      if (a_side == 0)
        AddIntersection(cut_list, P_Along(part, S, 0), -1);
      else if (b_side == 0)
        AddIntersection(cut_list, P_Along(part, S, 1), +1);

      continue;
    }

    if (a_side <= 0 && b_side <= 0)
    {
      back.AddSide(S);

      if (a_side == 0)
        AddIntersection(cut_list, P_Along(part, S, 0), +1);
      else if (b_side == 0)
        AddIntersection(cut_list, P_Along(part, S, 1), -1);

      continue;
    }

    /* need to split it */

    // determine the intersection point
    double along = a / (a - b);

    double ix = S->x1 + along * (S->x2 - S->x1);
    double iy = S->y1 + along * (S->y2 - S->y1);

    quake_side_c *T = SplitSideAt(S, ix, iy);

    front.AddSide((a > 0) ? S : T);
     back.AddSide((a > 0) ? T : S);

    AddIntersection(cut_list, P_Along(part, T, 0), a_side);
  }

  for (unsigned int n = 0 ; n < local_brushes.size() ; n++)
  {
    csg_brush_c *B = local_brushes[n];

    int side = Brush_TestSide(B, part);

    if (side <= 0)  back.AddBrush(B);
    if (side >= 0) front.AddBrush(B);
  }

  MergeIntersections(cut_list);

  CreateMiniSides(cut_list, node, part, front, back);
}


static bool FindPartition_XY(quake_group_c & group, quake_side_c *part,
                             qCluster_c ** reached_cluster)
{
  if (! *reached_cluster)
  {
    // seed-based sub-division party trick
    //
    // When the group extends (horizontally or vertically) into more
    // than a single seed, we need to split the group along a seed
    // boundary.  This is not really for the sake of speed, but for
    // the sake of the Visibility algorithm.

    double gx1, gy1, gx2, gy2;

    group.GetGroupBounds(&gx1, &gy1, &gx2, &gy2);

    int sx1 = floor(gx1 / CLUSTER_SIZE + SNAG_EPSILON);
    int sy1 = floor(gy1 / CLUSTER_SIZE + SNAG_EPSILON);
    int sx2 =  ceil(gx2 / CLUSTER_SIZE - SNAG_EPSILON);
    int sy2 =  ceil(gy2 / CLUSTER_SIZE - SNAG_EPSILON);

    int sw  = sx2 - sx1;
    int sh  = sy2 - sy1;

// fprintf(stderr, "bounds (%1.5f %1.5f) .. (%1.5f %1.5f)\n", gx1, gy1, gx2, gy2);
// fprintf(stderr, " sx/sy (%d,%d) .. (%d,%d) = %dx%d\n",  sx1, sy1, sx2, sy2, sw, sh);

    if (sw >= 2 || sh >= 2)
    {
      if (sw >= sh)
      {
        part->x1 = (sx1 + sw/2) * CLUSTER_SIZE;
        part->y1 = gy1;
        part->x2 = part->x1;
        part->y2 = MAX(gy2, gy1+4);
      }
      else
      {
        part->x1 = gx1;
        part->y1 = (sy1 + sh/2) * CLUSTER_SIZE;
        part->x2 = MAX(gx2, gx1+4);
        part->y2 = part->y1;
      }

      return true;
    }

    // we have now reached a cluster
    if (sw <= 1 && sh <= 1)
    {
      int cx = sx1 - cluster_X;
      int cy = sy1 - cluster_Y;

      SYS_ASSERT(0 <= cx && cx < cluster_W);
      SYS_ASSERT(0 <= cy && cy < cluster_H);

      *reached_cluster = qk_clusters[cy * cluster_W + cx];

      SYS_ASSERT(*reached_cluster);
    }
  }

  // inside a single cluster : find a side normally

  quake_side_c *poss1 = NULL;
  quake_side_c *poss2 = NULL;

  for (unsigned int i = 0 ; i < group.sides.size() ; i++)
  {
    quake_side_c *S = group.sides[i];

    if (S->on_node)
      continue;

    bool axis_aligned = (S->x1 == S->x2) || (S->y1 == S->y2);

    // MUST choose 2-sided snag BEFORE any 1-sided snag

    if (! S->TwoSided())
    {
      if (! poss1 || axis_aligned)
        poss1 = S;

      continue;
    }

    poss2 = S;

    // we prefer an axis-aligned node
    if (axis_aligned)
    {
      break;  // look no further
    }
  }

  quake_side_c *best = poss2 ? poss2 : poss1;

  if (! best)
    return false;

  part->x1 = best->x1;  part->y1 = best->y1;
  part->x2 = best->x2;  part->y2 = best->y2;

  return true;
}


struct floor_angle_Compare
{
  double *angles;

   floor_angle_Compare(double *p) : angles(p) { }
  ~floor_angle_Compare() { }

  inline bool operator() (int A, int B) const
  {
    return angles[A] < angles[B];
  }
};


static void CollectWinding(quake_group_c & group,
                           std::vector<quake_vertex_c> & winding,
                           quake_bbox_c & bbox)
{
  // result is CLOCKWISE when looking DOWN at the winding

  int v_num = (int)group.sides.size();

  SYS_ASSERT(v_num >= 3);

  double mid_x, mid_y;

  group.CalcMid(&mid_x, &mid_y);

  // determine angles, then sort

  std::vector<double> angles (v_num);
  std::vector<int>    mapping(v_num);

  for (int a = 0 ; a < v_num ; a++)
  {
    quake_side_c *S = group.sides[a];

    angles[a]  = 0 - CalcAngle(mid_x, mid_y, S->x1, S->y1);
    mapping[a] = a;
  }

  std::sort(mapping.begin(), mapping.end(),
            floor_angle_Compare(&angles[0]));

  // grab sorted vertices

  bbox.Begin();

  for (int i = 0 ; i < v_num ; i++)
  {
    int k = mapping[i];

    quake_side_c *S = group.sides[k];

    winding.push_back(quake_vertex_c(S->x1, S->y1, 0));

    // we don't handle bounding Z here
    bbox.Add_X(S->x1);
    bbox.Add_Y(S->y1);
  }

  bbox.End();
}


void quake_face_c::AddVert(float x, float y, float z)
{
  verts.push_back(quake_vertex_c(x, y, z));
}


void quake_face_c::CopyWinding(const std::vector<quake_vertex_c> winding,
                               const quake_plane_c *plane,
                               bool reverse)
{
  for (unsigned int i = 0 ; i < winding.size() ; i++)
  {
    unsigned int k = reverse ? (winding.size() - 1 - i) : i;
    
    const quake_vertex_c& V = winding[k];

    double z = plane->z;  // TODO: support slopes

    AddVert(V.x, V.y, z);
  }
}


void quake_face_c::SetupMatrix(const quake_plane_c *plane)
{
  s[0] = s[1] = s[2] = s[3] = 0;
  t[0] = t[1] = t[2] = t[3] = 0;
  
  if (fabs(plane->nx) > 0.5)
  {
    s[1] = 1;  // PLANE_X
    t[2] = 1;
  }
  else if (fabs(plane->ny) > 0.5)
  {
    s[0] = 1;  // PLANE_Y
    t[2] = 1;
  }
  else
  {
    s[0] = 1;  // PLANE_Z
    t[1] = 1;
  }
}


void quake_face_c::ST_Bounds(double *min_s, double *min_t,
                             double *max_s, double *max_t)
{
  *min_s = +9e9;  *max_s = -9e9;
  *min_t = +9e9;  *max_t = -9e9;

  for (unsigned int i = 0 ; i < verts.size() ; i++)
  {
    quake_vertex_c& V = verts[i];

    double ss = s[0] * V.x + s[1] * V.y + s[2] * V.z + s[3];
    double tt = t[0] * V.x + t[1] * V.y + t[2] * V.z + t[3];

    *min_s = MIN(*min_s, ss);  *max_s = MAX(*max_s, ss);
    *min_t = MIN(*min_t, tt);  *max_t = MAX(*max_t, tt);
  }

  if (*min_s > *max_s) *min_s = *max_s = 0;
  if (*min_t > *max_t) *min_t = *max_t = 0;
}


static void FlatToPlane(quake_plane_c *plane, const gap_c *G, bool is_ceil)
{
  // FIXME: support slopes !!

  plane->x  = plane->y  = 0;
  plane->nx = plane->ny = 0;

  plane->z  = is_ceil ? G->top->b.z : G->bottom->t.z;
  plane->nz = +1;

  plane->Normalize();
}


static void CreateFloorFace(quake_node_c *node, quake_leaf_c *leaf,
                            const gap_c *G, bool is_ceil,
                            std::vector<quake_vertex_c> & winding)
                        
{
  FlatToPlane(&node->plane, G, is_ceil);

  quake_face_c *F = new quake_face_c;

  F->node_side = is_ceil ? 1 : 0;

  F->CopyWinding(winding, &node->plane, is_ceil);

  csg_property_set_c *face_props = is_ceil ? &G->top->b.face : &G->bottom->t.face;

  F->texture = face_props->getStr("tex", "missing");

  F->SetupMatrix(&node->plane);

  node->AddFace(F);
  leaf->AddFace(F);

  qk_all_faces.push_back(F);
}


static void DoCreateWallFace(quake_node_c *node, quake_leaf_c *leaf,
                             quake_side_c *S, brush_vert_c *bvert,
                             float z1, float z2)
{
  quake_face_c *F = new quake_face_c();

  F->node_side = S->node_side;

  F->AddVert(S->x1, S->y1, z1);
  F->AddVert(S->x1, S->y1, z2);
  F->AddVert(S->x2, S->y2, z2);
  F->AddVert(S->x2, S->y2, z1);

  csg_property_set_c *face_props = &bvert->face;

  F->texture = face_props->getStr("tex", "missing");

  F->SetupMatrix(&node->plane);

  node->AddFace(F);
  leaf->AddFace(F);

  qk_all_faces.push_back(F);
}


static void CreateWallFace(quake_node_c *node, quake_leaf_c *leaf,
                           quake_side_c *S, brush_vert_c *bvert,
                           float z1, float z2)
{
  SYS_ASSERT(z2 > z1 + Z_EPSILON);

  // split faces if too tall
  int pieces = 1;

  while ((z2 - z1) / pieces > FACE_MAX_SIZE)
    pieces++;

  if (pieces > 1)
  {
    for (int i = 0 ; i < pieces ; i++)
    {
      DoCreateWallFace(node, leaf, S, bvert,
                       z1 + (z2 - z1) * (i  ) / pieces,
                       z1 + (z2 - z1) * (i+1) / pieces);
    }
  }
  else
  {
    DoCreateWallFace(node, leaf, S, bvert, z1, z2);
  }
}


static void CreateWallFaces(quake_group_c & group, quake_leaf_c *leaf,
                            gap_c *G)
{
  float f1 = G->bottom->t.z;
  float c1 = G->top   ->b.z;

  for (unsigned int i = 0 ; i < group.sides.size() ; i++)
  {
    quake_side_c *S = group.sides[i];

    SYS_ASSERT(S->on_node);

    if (! S->snag)  // "mini sides" never have faces
      continue;

    SYS_ASSERT(S->node_side >= 0);

    if (S->TwoSided())
    {
      region_c *back = S->snag->partner->region;

      unsigned int numgaps = back->gaps.size();

      // k is not really a gap number here, but the solids in-between
      for (unsigned int k = 0 ; k <= numgaps ; k++)
      {
        csg_brush_c *B;
        float bz, tz;

        if (k < numgaps)
        {
          B = back->gaps[k]->bottom;

          tz = B->t.z;
          bz = (k == 0) ? -EXTREME_H : back->gaps[k-1]->top->b.z;
        }
        else
        {
          B = back->gaps[k-1]->top;

          bz = B->b.z;
          tz = EXTREME_H;
        }

        if (tz < f1 + Z_EPSILON) continue;
        if (bz > c1 - Z_EPSILON) break;

        bz = MAX(bz, f1);
        tz = MIN(tz, c1);

        brush_vert_c *bvert = NULL;
        
        if (S->snag->partner)
          bvert = S->snag->partner->FindBrushVert(B);

        // fallback to something safe
        if (! bvert)
          bvert = B->verts[0];

        CreateWallFace(S->on_node, leaf, S, bvert, bz, tz);
      }
    }
    else
    {
      brush_vert_c *bvert = NULL;

      // Note: the brush sides we are interested in are on the OPPOSITE
      //       side of the snag, since regions are created from _inward_
      //       facing snags (but brush sides face _outward_).
      if (S->snag->partner)
        bvert = S->snag->partner->FindOneSidedVert((f1 + c1) / 2.0);

      // fallback to something safe
      if (! bvert)
        bvert = G->bottom->verts[0];

      CreateWallFace(S->on_node, leaf, S, bvert, f1, c1);
    }
  }
}


void quake_leaf_c::BBoxFromSolids()
{
  bbox.Begin();

  for (unsigned int i = 0 ; i < solids.size() ; i++)
  {
    csg_brush_c *B = solids[i];

    bbox.Add_Z(B->t.z);
    bbox.Add_Z(B->b.z);

    for (unsigned int k = 0 ; k < B->verts.size() ; k++)
    {
      brush_vert_c * V = B->verts[k];

      bbox.Add_X(V->x);
      bbox.Add_Y(V->y);
    }
  }

  bbox.End();
}


static quake_leaf_c * Solid_Leaf(quake_group_c & group)
{
  // Quake 1 and related games simply have a single solid leaf
  if (qk_game == 1)
    return qk_solid_leaf;

  // optimisation -- VALID ???
  if (group.brushes.empty())
    return qk_solid_leaf;

  quake_leaf_c *leaf = new quake_leaf_c(MEDIUM_SOLID);

  for (unsigned int i = 0 ; i < group.brushes.size() ; i++)
  {
    csg_brush_c *B = group.brushes[i];

    leaf->AddSolid(B);
  }

  leaf->BBoxFromSolids();

  return leaf;
}


static quake_leaf_c * Solid_Leaf(gap_c *gap, int is_ceil)
{
  if (qk_game == 1)
    return qk_solid_leaf;

  quake_leaf_c *leaf = new quake_leaf_c(MEDIUM_SOLID);

  // TODO: add _all_ solid brushes in floor/ceiling

  leaf->AddSolid(is_ceil ? gap->top : gap->bottom);

  leaf->BBoxFromSolids();

  return leaf;
}


static quake_node_c * CreateLeaf(gap_c * G, quake_group_c & group,
                                 std::vector<quake_vertex_c> & winding,
                                 quake_bbox_c & bbox,
                                 quake_node_c * prev_N,
                                 quake_leaf_c * prev_L,
                                 csg_brush_c *liquid)
{
  quake_leaf_c *leaf = new quake_leaf_c(MEDIUM_AIR);

  CreateWallFaces(group, leaf, G);

  quake_node_c *F_node = new quake_node_c;
  quake_node_c *C_node = new quake_node_c;

  CreateFloorFace(F_node, leaf, G, false, winding);
  CreateFloorFace(C_node, leaf, G, true,  winding);

  // copy bbox and update Z (with a hack for slopes)

  leaf->bbox = bbox;

  leaf->bbox.mins[2] = G->bottom->t.z;
  leaf->bbox.maxs[2] = G->top->b.z;

  if (G->bottom->t.slope) leaf->bbox.mins[2] = G->bottom->b.z;
  if (G->top   ->b.slope) leaf->bbox.maxs[2] = G->top->t.z;

  if (liquid && leaf->bbox.maxs[2] < liquid->t.z + 0.1)
  {
    leaf->medium = MEDIUM_WATER;

    if (qk_game == 2)
      leaf->AddSolid(liquid);
  }

  // floor and ceiling node planes both face upwards

  C_node->front_N = prev_N;
  C_node->front_L = prev_L;

  F_node->front_N = C_node;

  C_node->back_L = leaf;
  F_node->back_L = Solid_Leaf(G, 0);

  return F_node;
}


static quake_node_c * Partition_Z(quake_group_c & group, qCluster_c *cluster)
{
//@@@@@@@@@@@2 cluster

  SYS_ASSERT(group.sides[0]->snag);  // FIXME can fail due to partitioning

  region_c *R = group.sides[0]->snag->region;

  SYS_ASSERT(R);
  SYS_ASSERT(R->gaps.size() > 0);

  quake_bbox_c bbox;

  std::vector<quake_vertex_c> winding;

  CollectWinding(group, winding, bbox);

  quake_node_c *cur_node = NULL;
  quake_leaf_c *cur_leaf = Solid_Leaf(R->gaps.back(), 1);

  for (int i = (int)R->gaps.size()-1 ; i >= 0 ; i--)
  {
    cur_node = CreateLeaf(R->gaps[i], group, winding, bbox,
                          cur_node, cur_leaf, R->liquid);
    cur_leaf = NULL;
  }

  SYS_ASSERT(cur_node);

  return cur_node;
}


static quake_node_c * Partition_Group(quake_group_c & group,
                                      qCluster_c *reached_cluster = NULL)
{
  SYS_ASSERT(! group.sides.empty());

  quake_side_c part;
  quake_plane_c p_plane;

  if (FindPartition_XY(group, &part, &reached_cluster))
  {
    part.ToPlane(&p_plane);

    quake_node_c * new_node = new quake_node_c(p_plane);

    // divide the group
    quake_group_c front;
    quake_group_c back;

    Split_XY(group, new_node, &part, front, back);

    // the front should never be empty
    SYS_ASSERT(! front.sides.empty());

    new_node->front_N = Partition_Group(front, reached_cluster);

    if (back.sides.empty())
      new_node->back_L = Solid_Leaf(back);
    else
      new_node->back_N = Partition_Group(back, reached_cluster);

    // input group has been consumed now 

    return new_node;
  }
  else
  {
    SYS_ASSERT(reached_cluster);

    return Partition_Z(group, reached_cluster);
  }
}


//------------------------------------------------------------------------

void quake_bbox_c::Begin()
{
  for (int b = 0 ; b < 3 ; b++)
  {
    mins[b] = +9e9;
    maxs[b] = -9e9;
  }
}

void quake_bbox_c::End()
{
  for (int b = 0 ; b < 3 ; b++)
    if (mins[b] > maxs[b])
      mins[b] = maxs[b] = 0;
}


void quake_bbox_c::Add_X(float x)
{
  if (x < mins[0]) mins[0] = x;
  if (x > maxs[0]) maxs[0] = x;
}

void quake_bbox_c::Add_Y(float y)
{
  if (y < mins[1]) mins[1] = y;
  if (y > maxs[1]) maxs[1] = y;
}

void quake_bbox_c::Add_Z(float z)
{
  if (z < mins[2]) mins[2] = z;
  if (z > maxs[2]) maxs[2] = z;
}

void quake_bbox_c::AddPoint(float x, float y, float z)
{
  if (x < mins[0]) mins[0] = x;
  if (x > maxs[0]) maxs[0] = x;

  if (y < mins[1]) mins[1] = y;
  if (y > maxs[1]) maxs[1] = y;

  if (z < mins[2]) mins[2] = z;
  if (z > maxs[2]) maxs[2] = z;
}


void quake_bbox_c::Merge(const quake_bbox_c& other)
{
  for (int b = 0 ; b < 3 ; b++)
  {
    mins[b] = MIN(mins[b], other.mins[b]);
    maxs[b] = MAX(maxs[b], other.maxs[b]);
  }
}


void quake_node_c::ComputeBBox()
{
  // NOTE: assumes bbox of all children (nodes/leafs) are valid

  bbox.Begin();

  if (front_N)
    bbox.Merge(front_N->bbox);
  else if (front_L != qk_solid_leaf)
    bbox.Merge(front_L->bbox);

  if (back_N)
    bbox.Merge(back_N->bbox);
  else if (back_L != qk_solid_leaf)
    bbox.Merge(back_L->bbox);

  bbox.End();
}


static void AssignLeafIndex(quake_leaf_c *leaf, int *cur_leaf)
{
  SYS_ASSERT(leaf);

  if (leaf == qk_solid_leaf)
    return;

  // must add 2 (instead of 1) because leaf #0 is the SOLID_LEAF
  leaf->index = -((*cur_leaf)+2);

  *cur_leaf += 1;
}


static void AssignIndexes(quake_node_c *node, int *cur_node, int *cur_leaf)
{
  node->index = *cur_node;

  *cur_node += 1;

  if (node->front_N)
    AssignIndexes(node->front_N, cur_node, cur_leaf);
  else
    AssignLeafIndex(node->front_L, cur_leaf);

  if (node->back_N)
    AssignIndexes(node->back_N, cur_node, cur_leaf);
  else
    AssignLeafIndex(node->back_L, cur_leaf);

  // determine node's bounding box now
  node->ComputeBBox();
}


#if 0
static void AssignClusterID(rNode_c *node, int cluster)
{
  if (node == SOLID_LEAF)
    return;

  node->cluster = cluster;

  if (node->IsNode())
  {
    AssignClusterID(node->front, cluster);
    AssignClusterID(node->back,  cluster);
  }
}

static void AssignClusters(rNode_c *node)
{
  if (node == SOLID_LEAF)
    return;

  if (node->IsLeaf() || MAX(node->BBoxSizeX(), node->BBoxSizeY()) <= FACE_MAX_SIZE)
  {
    AssignClusterID(node, q1_total_clusters);
    q1_total_clusters += 1;
    return;
  }

  AssignClusters(node->front);
  AssignClusters(node->back);
}
#endif


static void CreateClusters(quake_group_c & group)
{
  QCOM_FreeClusters();

  double min_x, min_y;
  double max_x, max_y;

  group.GetGroupBounds(&min_x, &min_y, &max_x, &max_y);

  QCOM_CreateClusters(min_x, min_y, max_x, max_y);
}


void CSG_QUAKE_Build()
{
  LogPrintf("QUAKE CSG...\n");

  if (main_win)
    main_win->build_box->Prog_Step("CSG");

  CSG_BSP(1.0);

  CSG_MakeMiniMap();

  if (main_win)
    main_win->build_box->Prog_Step("BSP");


  quake_group_c GROUP;

  CreateSides(GROUP);

  if (qk_game == 2)
    CreateBrushes(GROUP);

  CreateClusters(GROUP);


  qk_solid_leaf = new quake_leaf_c(MEDIUM_SOLID);

  qk_bsp_root = Partition_Group(GROUP);

  SYS_ASSERT(qk_bsp_root);

  int cur_node = 0;
  int cur_leaf = 0;

  AssignIndexes(qk_bsp_root, &cur_node, &cur_leaf);
}


//------------------------------------------------------------------------

extern int Grab_Properties(lua_State *L, int stack_pos,
                           csg_property_set_c *props,
                           bool skip_xybt = false);

int Q1_add_mapmodel(lua_State *L)
{
  // LUA: q1_add_mapmodel(info, x1,y1,z1, x2,y2,z2)
  //
  // info is a table containing:
  //   x_face  : face table for X sides
  //   y_face  : face table for Y sides
  //   z_face  : face table for top and bottom

  quake_mapmodel_c *model = new quake_mapmodel_c;

  model->x1 = luaL_checknumber(L, 2);
  model->y1 = luaL_checknumber(L, 3);
  model->z1 = luaL_checknumber(L, 4);

  model->x2 = luaL_checknumber(L, 5);
  model->y2 = luaL_checknumber(L, 6);
  model->z2 = luaL_checknumber(L, 7);

  if (lua_type(L, 1) != LUA_TTABLE)
  {
    return luaL_argerror(L, 1, "missing table: mapmodel info");
  }

  lua_getfield(L, 1, "x_face");
  lua_getfield(L, 1, "y_face");
  lua_getfield(L, 1, "z_face");

  Grab_Properties(L, -3, &model->x_face);
  Grab_Properties(L, -2, &model->y_face);
  Grab_Properties(L, -1, &model->z_face);

  lua_pop(L, 3);

  qk_all_mapmodels.push_back(model);

  // create model reference (for entity)
  char ref_name[32];
  sprintf(ref_name, "*%u", qk_all_mapmodels.size());

  lua_pushstring(L, ref_name);
  return 1;
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
