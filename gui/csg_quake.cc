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

#include "csg_main.h"
#include "csg_local.h"
#include "csg_quake.h"

#include "q1_main.h"
#include "q1_structs.h"


#define FACE_MAX_SIZE  240

#define LIGHT_INDOOR   64
#define LIGHT_OUTDOOR  100


extern void Q1_CreateSubModels(qLump_c *L, int first_face, int first_leaf);



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



//------------------------------------------------------------------------
//  FACE STUFF
//------------------------------------------------------------------------


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


#if 0
static void BuildFloorFace(dface_t& raw_face, rFace_c *F, rNode_c *N)
{
  bool is_ceil = (F->kind == rFace_c::CEIL) ? true : false;
  bool flipped;

  double z = F->z;

  raw_face.planenum = BSP_AddPlane(0, 0, z,
                                   0, 0, is_ceil ? -1 : +1, &flipped);
  raw_face.side = flipped ? 1 : 0;


  const char *texture = F->face->getStr("tex", "missing");

  int flags = CalcTextureFlag(texture);

  double s[4] = { 1.0, 0.0, 0.0, 0.0 };
  double t[4] = { 0.0, 1.0, 0.0, 0.0 };

  raw_face.texinfo = Q1_AddTexInfo(texture, flags, s, t);

  raw_face.styles[0] = 0xFF;  // no lightmap
  raw_face.styles[1] = 0xFF;
  raw_face.styles[2] = 0xFF;
  raw_face.styles[3] = 0xFF;

  raw_face.lightofs = -1;  // no lightmap

  
  rWindingVerts_c *UU = F->UU;

  // FIXME: need at least 3 verts
  int v_num = UU->count;

  double min_x = +9e9; double max_x = -9e9;
  double min_y = +9e9; double max_y = -9e9;


  // add the edges [anti-clockwise if flipped]

  for (int pos = 0; pos < v_num; pos++)
  {
    int p1;
    int p2;

    if (flipped)
    {
      p1 = (v_num*2 - pos)     % v_num;
      p2 = (v_num*2 - pos - 1) % v_num;
    }
    else
    {
      p1 = pos;
      p2 = (pos + 1) % v_num;
    }

    Q1_AddEdge(UU->x[p1], UU->y[p1], z,
               UU->x[p2], UU->y[p2], z, &raw_face);

    min_x = MIN(min_x, UU->x[pos]);
    min_y = MIN(min_y, UU->y[pos]);
    max_x = MAX(max_x, UU->x[pos]);
    max_y = MAX(max_y, UU->y[pos]);
  }


  if (! (flags & TEX_SPECIAL))
  {
    int ext_W, ext_H;

    GetExtents(min_x, min_y, max_x, max_y, &ext_W, &ext_H);

    static int foo; foo++;
    raw_face.styles[0] = 0; // (foo & 3); //!!!!!

    raw_face.lightofs = 60*17*17;  //!!!! FIXME
  }
}
#endif


#if 0
static void BuildWallFace(dface_t& raw_face, rFace_c *F, rNode_c *N)
{
  rSide_c *S = F->side;

///  merge_gap_c *gap = R->gaps.at(F->gap);

  double z1 = F->z1;
  double z2 = F->z2;


  bool flipped;

  raw_face.planenum = BSP_AddPlane(S->x1, S->y1, 0,
                                   (S->y2 - S->y1), (S->x1 - S->x2), 0,
                                   &flipped);

  raw_face.side = flipped ? 1 : 0;


  const char *texture = F->face->getStr("tex", "missing");

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

    raw_face.lightofs = 80*17*17; //!!!! FIXME
  }
}
#endif


//------------------------------------------------------------------------

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
      snag(other->snag), on_node(other->on_node),
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

public:
  quake_group_c() : sides()
  { }

  ~quake_group_c()
  { }

  void AddSide(quake_side_c *S)
  {
    sides.push_back(S);
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

///---  void StoreVerts(std::vector<quake_vertex_c> & winding)
///---  {
///---    for (unsigned int i = 0 ; i < sides.size() ; i++)
///---    {
///---      quake_side_c *S = sides[i];
///---
///---      winding.push_back(quake_vertex_c(S->x1, S->y1, 0));
///---    }
///---  }

};


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


static void CreateSides(quake_group_c & group)
{
fprintf(stderr, "CREATE SIDES\n");
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
fprintf(stderr, "New Side: %p %s (%1.0f %1.0f) .. (%1.0f %1.0f)\n",
        S, S->TwoSided() ? "2S" : "1S",
        S->x1, S->y1, S->x2, S->y2);

      group.AddSide(S);
    }
  }

fprintf(stderr, "\n");
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

  local_sides.swap(group.sides);

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

  MergeIntersections(cut_list);

  CreateMiniSides(cut_list, node, part, front, back);
}


static bool FindPartition_XY(quake_group_c & group, quake_side_c *part)
{
  quake_side_c *poss = NULL;
  quake_side_c *best = NULL;

  for (unsigned int i = 0 ; i < group.sides.size() ; i++)
  {
    quake_side_c *S = group.sides[i];

    if (S->on_node)
      continue;

    poss = S;

    // MUST choose 2-sided snag BEFORE any 1-sided snag

    if (S->TwoSided())
    {
      best = S; break;  // !!!!! FIXME: decide properly
    }
  }

  if (! poss)
    return false;

  if (! best)
    best = poss;

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


void quake_face_c::CopyWinding(const std::vector<quake_vertex_c> winding,
                               const quake_plane_c *plane,
                               bool reverse)
{
  for (unsigned int i = 0 ; i < winding.size() ; i++)
  {
    unsigned int k = reverse ? (winding.size() - 1 - i) : i;
    
    const quake_vertex_c& V = winding[k];

    double z = plane->z;  // TODO: support slopes

    verts.push_back(quake_vertex_c(V.x, V.y, z));
  }
}


static void FlatToPlane(quake_plane_c *plane, const gap_c *G, bool is_ceil)
{
  // FIXME: support slopes !!

  plane->x  = plane->y  = 0;
  plane->nx = plane->ny = 0;

  plane->z  = is_ceil ? G->top->b.z : G->bottom->t.z;
  plane->nz = +1;

  /// NOT NEEDED (YET) : plane->Normalize();
}


static quake_face_c * CreateFloorFace(quake_plane_c *plane, const gap_c *G, bool is_ceil,
                                      std::vector<quake_vertex_c> & winding)
                        
{
  FlatToPlane(plane, G, is_ceil);

  quake_face_c *F = new quake_face_c;

  F->node_side = is_ceil ? 1 : 0;

  F->CopyWinding(winding, plane, is_ceil);

  csg_property_set_c *face_props = is_ceil ? &G->top->b.face : &G->bottom->t.face;

  F->texture = face_props->getStr("tex", "missing");

  return F;
}


static quake_face_c * CreateWallFace(quake_side_c *S, csg_brush_c *brush,
                                     float z1, float z2)
{
  quake_face_c *F = new quake_face_c();

  F->node_side = S->node_side;

  // FIXME: F->AddVert(x, y, z)

  F->verts.push_back(quake_vertex_c(S->x1, S->y1, z1));
  F->verts.push_back(quake_vertex_c(S->x1, S->y1, z2));
  F->verts.push_back(quake_vertex_c(S->x2, S->y2, z2));
  F->verts.push_back(quake_vertex_c(S->x2, S->y2, z1));

  csg_property_set_c *face_props = &brush->verts[0]->face; //!!!! FIXME

  F->texture = face_props->getStr("tex", "missing");

  return F;
}


static void CreateWallFaces(quake_group_c & group, quake_leaf_c *leaf,
                            gap_c *G)
{
  float f1 = G->bottom->t.z;
  float c1 = G->top   ->b.z;

  for (unsigned int i = 0 ; i < group.sides.size() ; i++)
  {
    quake_side_c *S = group.sides[i];
    quake_face_c *F;

    SYS_ASSERT(S->on_node);

    if (! S->snag)  // "mini sides" never have faces
      continue;

    if (S->TwoSided())
    {
      gap_c *G2 = S->snag->partner->region->gaps[0];

      float f2 = G2->bottom->t.z;
      float c2 = G2->top   ->b.z;

      if (f2 > f1 + 0.1)
      {
        F = CreateWallFace(S, G2->bottom, f1, f2);

        leaf->AddFace(F);
        S->on_node->AddFace(F);
      }

      if (c2 < c1 - 0.1)
      {
        F = CreateWallFace(S, G2->top, c2, c1);

        leaf->AddFace(F);
        S->on_node->AddFace(F);
      }
    }
    else
    {
      F = CreateWallFace(S, G->bottom, f1, c1); //!!!! FIXME

      leaf->AddFace(F);
      S->on_node->AddFace(F);
    }
  }
}


static quake_node_c * CreateLeaf(gap_c * G, quake_group_c & group,
                                 std::vector<quake_vertex_c> & winding,
                                 quake_bbox_c & bbox,
                                 quake_node_c * prev_N,
                                 quake_leaf_c * prev_L)
{
  quake_leaf_c *leaf = new quake_leaf_c(CONTENTS_EMPTY);

  CreateWallFaces(group, leaf, G);

  quake_node_c *F_node = new quake_node_c;
  quake_node_c *C_node = new quake_node_c;

  quake_face_c *F_face = CreateFloorFace(&F_node->plane, G, false, winding);
  quake_face_c *C_face = CreateFloorFace(&C_node->plane, G, true,  winding);

  F_node->AddFace(F_face);
  C_node->AddFace(C_face);

  leaf->AddFace(F_face);
  leaf->AddFace(C_face);

  // copy bbox and update Z (with a hack for slopes)

  leaf->bbox = bbox;

  leaf->bbox.mins[2] = F_face->verts[0].z;
  leaf->bbox.maxs[2] = C_face->verts[0].z;

  if (G->bottom->t.slope) leaf->bbox.mins[2] = G->bottom->b.z;
  if (G->top   ->b.slope) leaf->bbox.maxs[2] = G->top   ->t.z;

  // floor and ceiling node planes both face upwards

  C_node->front_N = prev_N;
  C_node->front_L = prev_L;

  F_node->front_N = C_node;

  C_node->back_L = leaf;
  F_node->back_L = qk_solid_leaf;

  return F_node;
}


static quake_node_c * Partition_Z(quake_group_c & group)
{
  region_c *R = group.sides[0]->snag->region;

  SYS_ASSERT(R);
  SYS_ASSERT(R->gaps.size() > 0);

  quake_bbox_c bbox;

  std::vector<quake_vertex_c> winding;

  CollectWinding(group, winding, bbox);

  quake_node_c *cur_node = NULL;
  quake_leaf_c *cur_leaf = qk_solid_leaf;

  for (int i = (int)R->gaps.size()-1 ; i >= 0 ; i--)
  {
    cur_node = CreateLeaf(R->gaps[i], group, winding, bbox,
                          cur_node, cur_leaf);
    cur_leaf = NULL;
  }

  SYS_ASSERT(cur_node);

  return cur_node;
}


static quake_node_c * Partition_Group(quake_group_c & group)
{
  // this function "returns" either a node OR a leaf via the
  // parameters with the same name.

  SYS_ASSERT(! group.sides.empty());

  quake_side_c part;
  quake_plane_c p_plane;

  if (FindPartition_XY(group, &part))
  {
    part.ToPlane(&p_plane);

    quake_node_c * new_node = new quake_node_c(p_plane);

    // divide the group
    quake_group_c front;
    quake_group_c back;

    Split_XY(group, new_node, &part, front, back);

    // the front should never be empty
    SYS_ASSERT(! front.sides.empty());

    new_node->front_N = Partition_Group(front);

    if (back.sides.empty())
      new_node->back_L = qk_solid_leaf;
    else
      new_node->back_N = Partition_Group(back);

    // input group has been consumed now 

    return new_node;
  }
  else
  {
    return Partition_Z(group);
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


static void Quake_BSP()
{
  qk_solid_leaf = new quake_leaf_c(CONTENTS_SOLID);


  quake_group_c GROUP;

  CreateSides(GROUP);

  qk_bsp_root = Partition_Group(GROUP);

  SYS_ASSERT(qk_bsp_root);


  int cur_node = 0;
  int cur_leaf = 0;

  AssignIndexes(qk_bsp_root, &cur_node, &cur_leaf);


  //??  MakeFaces(qk_bsp_root);
}



void Q1_CreateModel(void)
{
#if 0
  rSideFactory_c::FreeAll();
  all_windings.clear();

// fprintf(stderr, "Q1_BuildBSP...\n");
  OLD_Q1_BuildBSP();

  qLump_c *lump = BSP_NewLump(LUMP_MODELS);

  memset(&model, 0, sizeof(model));

  q1_total_nodes = 0;
  q1_total_leafs = 0;  // does not include the solid leaf
  q1_total_faces = 0;

  q1_total_mark_surfs = 0;
  q1_total_surf_edges = 0;
  q1_total_clusters   = 0;

  q1_nodes = BSP_NewLump(LUMP_NODES);
  q1_leafs = BSP_NewLump(LUMP_LEAFS);
  q1_faces = BSP_NewLump(LUMP_FACES);

  q_mark_surfs = BSP_NewLump(LUMP_MARKSURFACES);
  q_surf_edges = BSP_NewLump(LUMP_SURFEDGES);

// fprintf(stderr, "Second Pass...\n");
  SecondPass(R_ROOT);

  AssignIndexes(R_ROOT);
  AssignClusters(R_ROOT);  // needs bboxes from AssignIndexes

  LogPrintf("render hull: %d nodes, %d leafs, %d clusters\n",
          q1_total_nodes, q1_total_leafs, q1_total_clusters);

  if (q1_total_nodes >= MAX_MAP_NODES)
    Main_FatalError("Quake1 build failure: exceeded limit of %d NODES\n",
                    MAX_MAP_NODES);

  if (q1_total_leafs >= MAX_MAP_LEAFS)
    Main_FatalError("Quake1 build failure: exceeded limit of %d LEAFS\n",
                    MAX_MAP_LEAFS);

  WriteSolidLeaf();

// fprintf(stderr, "Write Nodes...\n");
  WriteNodes(R_ROOT);

  if (q1_total_faces >= MAX_MAP_FACES)
    Main_FatalError("Quake1 build failure: exceeded limit of %d FACES\n",
                    MAX_MAP_FACES);

  model.numfaces = q1_total_faces;


  // set model bounding box
  model.mins[0] = bounds_x1;  model.maxs[0] = bounds_x2;
  model.mins[1] = bounds_y1;  model.maxs[1] = bounds_y2;
  model.mins[2] = bounds_z1;  model.maxs[2] = bounds_z2;

  model.origin[0] = 0;
  model.origin[1] = 0;
  model.origin[2] = 0;


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

// fprintf(stderr, "DONE.\n");

  // there is no need to delete the lumps from BSP_NewLump()
  // since is handled by the q_common.c code.
#endif
}



void CSG_QUAKE_Build()
{
  if (main_win)
    main_win->build_box->Prog_Step("CSG");

  CSG_BSP(1.0);

  CSG_MakeMiniMap();

  if (main_win)
    main_win->build_box->Prog_Step("BSP");

  Quake_BSP();
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
