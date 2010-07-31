//------------------------------------------------------------------------
//  LEVEL building - QUAKE II NODES
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

#include <algorithm>

#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "lib_file.h"
#include "lib_util.h"
#include "main.h"

#include "csg_main.h"

#include "g_lua.h"

#include "q_common.h"
#include "q2_main.h"
#include "q2_structs.h"


#define CONTENTS_EMPTY  0


#define FACE_MAX_SIZE  240


static bool CRUD_PointInSolid(double x, double y)
{
  merge_region_c *R = CSG2_FindRegionForPoint(x, y);

  return ! (R && R->gaps.size() > 0);
}



class qSide_c;
class qLeaf_c;
class qNode_c;


static void DoAssignFaces(qNode_c *N, qSide_c *S);


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
  qLeaf_c *leaf;

  int index;  // final index into Faces lump

  csg_brush_c *brush;
  csg_face_c *info;

public:
   qFace_c(int _kind = WALL) :
          kind(_kind), side(NULL), leaf(NULL),
          index(-1), brush(NULL), info(NULL)
   { }

  ~qFace_c()
   { }

   qFace_c(int _kind, int _gap, double _z1, double _z2) :
           kind(_kind), z1(_z1), z2(_z2), gap(_gap),
           side(NULL), leaf(NULL), index(-1),
           brush(NULL), info(NULL)
   { }

   qFace_c(const qFace_c *other, qSide_c *new_side) :
           kind(other->kind), z1(other->z1), z2(other->z2),
           gap(other->gap), side(new_side),
           leaf(other->leaf), index(-1),
           brush(other->brush), info(other->info)
   { }
};


class qSide_c
{
public:
  merge_segment_c *seg;  // NULL means "portal"

  int side;  // side of seg : 0 is front, 1 is back

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

  // for SOLID leafs
  std::vector<csg_brush_c *> brushes;

  bool floor_on_node;
  bool ceil_on_node;

public:
  qLeaf_c() : contents(CONTENTS_EMPTY), /* faces(), */ sides(),
              gap(0), numgap(0),
              min_x(0), min_y(0), max_x(0), max_y(0),
              faces(), brushes(),
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
          faces(), brushes(),
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

  qFace_c *GetFloor() const
  {
    for (unsigned int k = 0; k < faces.size(); k++)
    {
      qFace_c *F = faces[k];

      if (F->kind == qFace_c::FLOOR)
        return F;
    }

    return NULL; // not found
  }

  qFace_c *GetCeil() const
  {
    for (unsigned int k = 0; k < faces.size(); k++)
    {
      qFace_c *F = faces[k];

      if (F->kind == qFace_c::CEIL)
        return F;
    }

    return NULL; // not found
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

        if (F->gap != gap)
          continue;

        // check if already there
        for (unsigned int m=0; m < faces.size(); m++)
        {
          SYS_ASSERT(faces[m] != F);
        }

        faces.push_back(F);
        F->leaf = this;
      }
    }
  }
};


class qNode_c
{
public:
  // non-zero if this node splits the tree by Z
  // (with a horizontal upward-facing plane, i.e. dz = 1).
  int dz;

  double z;

  // normal splitting planes are vertical, and here are the
  // coordinates on the map.
  double x,  y;
  double dx, dy;

  qLeaf_c *front_l;  // front space : one of these is non-NULL
  qNode_c *front_n;

  qLeaf_c *back_l;   // back space : one of these is non-NULL
  qNode_c *back_n;

  // NB: faces are managed by qSide_c, we only store copies here
  std::vector<qFace_c *> faces;

public:
  qNode_c(int _dz = 0) : dz(_dz), z(0),
                         x(0), y(0), dx(0), dy(0),
                         front_l(NULL), front_n(NULL),
                         back_l(NULL),  back_n(NULL),
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
    dz = -dz;

    qLeaf_c *tmp_l = front_l; front_l = back_l; back_l = tmp_l;
    qNode_c *tmp_n = front_n; front_n = back_n; back_n = tmp_n;

    dx = -dx;
    dy = -dy;
  }

  void AssignFaces(qSide_c *S, qLeaf_c *back_l = NULL)
  {
    SYS_ASSERT(S->seg); // should never be a portal

    for (unsigned int f = 0; f < S->faces.size(); f++)
    {
      faces.push_back(S->faces[f]);

      if (back_l && S->faces[f]->brush)
        back_l->brushes.push_back(S->faces[f]->brush);
    }
  }
};


static void DoAssignFaces(qNode_c *N, qSide_c *S)
{
  N->AssignFaces(S);
}



//------------------------------------------------------------------------

static qNode_c *Q_ROOT;


static double EvaluatePartition(qLeaf_c *leaf, qSide_c *part)
{
  int back   = 0;
  int front  = 0;
  int splits = 0;

  double pdx = part->x2 - part->x1;
  double pdy = part->y2 - part->y1;

  std::list<qSide_c *>::iterator SI;

  for (SI = leaf->sides.begin(); SI != leaf->sides.end(); SI++)
  {
    qSide_c *S = *SI;

    // FIXME !!!! TEMP HACK ignoring portals
    if (! S->seg)
      continue;

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

DebugPrintf("PARTITION CANDIDATE %p (%1.0f %1.0f)..(%1.0f %1.0f) : %d|%d splits:%d\n",
        part, part->x1, part->y1, part->x2, part->y2,
        back, front, splits);


  if (front == 0 || back == 0)
    return -1;

  // calculate heuristic
  int diff = ABS(front - back);

  double cost = (splits * (splits+1) * 365.0 + diff * 100.0) /
                (double)(front + back);

  // slight preference for axis-aligned planes
  if (! (fabs(pdx) < EPSILON || fabs(pdy) < EPSILON))
    cost += 1.0;

  return cost;
}


static qSide_c * FindPartition(qLeaf_c *leaf)
{
  std::list<qSide_c *>::iterator SI;

  double   best_c = 9e30;
  qSide_c *best_p = NULL;

  int count = 0;

  for (SI = leaf->sides.begin(); SI != leaf->sides.end(); SI++)
  {
    qSide_c *part = *SI;

    // ignore portal sides
    if (! part->seg)
      continue;

    count++;

    // TODO: Optimise for two-sided segments by skipping the back one

    // TODO: skip sides that lie on the same vertical plane

    double cost = EvaluatePartition(leaf, part);

///fprintf(stderr, "--> COST:%1.2f for %p\n", cost, part);

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
fprintf(stderr, "Splitting DIAGONAL side %p length:%1.0f\n", S, S->Length());

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


class intersection_c
{
public:
  enum closed_kind_e
  {
    OPEN   = 0,
    BEFORE = 1,
    AFTER  = 2,
    CLOSED = 3
  };

  int closed;

  double along;  // distance along partition

  double x, y;

public:
   intersection_c() { }
  ~intersection_c() { }
};

struct Compare_Intersection_pred
{
  inline bool operator() (const intersection_c *A, const intersection_c *B) const
  {
    return A->along < B->along;
  }
};

static void AddIntersection(std::vector<intersection_c *>& cut_list,
                            qNode_c *part, double x, double y,
                            int closed = intersection_c::OPEN)
{
  intersection_c *K = new intersection_c();

  K->closed = closed;
  K->x = x;
  K->y = y;

  K->along = AlongDist(x, y,
                       part->x, part->y,
                       part->x + part->dx, part->y + part->dy);

  cut_list.push_back(K);
}

#if 0
static void DumpIntersections(std::vector<intersection_c *>& cut_list)
{
  static const char *closed_names[4] =
  {
    "OPEN", "BEFORE", "AFTER", "CLOSED"
  };

  fprintf(stderr, "INTERSECTIONS:\n");

  for (unsigned int i = 0; i < cut_list.size(); i++)
  {
    intersection_c *K = cut_list[i];

fprintf(stderr, "(%1.1f %1.1f) along:%8.3f closed:%s\n",
        K->x, K->y, K->along,
        (K->closed < 0 || K->closed > 4) ? "?????" :
        closed_names[K->closed]);
  }

fprintf(stderr, "\n");
}
#endif

static void MergeIntersections(std::vector<intersection_c *>& cut_list)
{
  // sort intersections by their position on the partition line,
  // and merge any points at the same location.

  std::sort(cut_list.begin(), cut_list.end(), Compare_Intersection_pred());

///  DumpIntersections(cut_list);

  unsigned int pos = 0;

  while (pos < cut_list.size())
  {
    unsigned int n = 0;  // neighbour count

    double along = cut_list[pos]->along;

    while ( (pos + n + 1) < cut_list.size() &&
            (cut_list[pos+n+1]->along - along) < Q_EPSILON )
    { n++; }

    for (unsigned int i = 1; i <= n; i++)
    {
      cut_list[pos]->closed |= cut_list[pos+i]->closed;

      delete cut_list[pos+i];
      cut_list[pos+i] = NULL;
    }

    pos += (n + 1);
  }

  // remove the NULL pointers
  std::vector<intersection_c *>::iterator ENDP;
  ENDP = std::remove(cut_list.begin(), cut_list.end(), (intersection_c*)NULL);
  cut_list.erase(ENDP, cut_list.end());

///  DumpIntersections(cut_list);
}

static void CreatePortals(std::vector<intersection_c *>& cut_list, 
                          qNode_c *part, qLeaf_c *front_l, qLeaf_c *back_l)
{
  for (unsigned int i = 0; i < cut_list.size()-1; i++)
  {
    intersection_c *K1 = cut_list[i];
    intersection_c *K2 = cut_list[i+1];

    bool k1_open = (K1->closed & intersection_c::AFTER)  ? false : true;
    bool k2_open = (K2->closed & intersection_c::BEFORE) ? false : true;

    if (k1_open != k2_open) // sanity check
    {
      fprintf(stderr, "WARNING: portal mismatch from (%1.1f %1.1f) to (%1.1f %1.1f)\n",
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

    if (CRUD_PointInSolid(mx, my))
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


static qLeaf_c *SolidLeaf(void /* BLAH */)
{
  qLeaf_c *L = new qLeaf_c();

  L->contents = CONTENTS_SOLID;

  L->min_x = L->min_y = -3000;
  L->max_x = L->max_y = +3000;

  return L;
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
      qNode_c * node = new qNode_c();

      node->x = S->x1;
      node->y = S->y1;

      node->dx = S->x2 - S->x1;
      node->dy = S->y2 - S->y1;

      node->back_l = SolidLeaf();

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

        node->AssignFaces(T, node->back_l);

        T->on_node = node;
      }

      Partition_Solid(leaf, &node->front_n, &node->front_l);

      (*out_n) = node;
      return;
    }
  }


  merge_gap_c *gap = leaf->GetGap();

  if (! leaf->ceil_on_node)
  {
      leaf->ceil_on_node = true;

      qNode_c * node = new qNode_c(-1 /* dz */);

      node->z = gap->GetZ2();

      qFace_c *ceil = leaf->GetCeil();
      SYS_ASSERT(ceil);
      node->faces.push_back(ceil);

      node->back_l = SolidLeaf();
      node->back_l->brushes.push_back(gap->t_brush);

      Partition_Solid(leaf, &node->front_n, &node->front_l);

      (*out_n) = node;
      return;
  }


  SYS_ASSERT(! leaf->floor_on_node);
  {
      leaf->floor_on_node = true;
  
      qNode_c * node = new qNode_c(+1 /* dz */);

      node->z = gap->GetZ1();

      qFace_c *floor = leaf->GetFloor();
      SYS_ASSERT(floor);
      node->faces.push_back(floor);

      node->back_l = SolidLeaf();
      node->back_l->brushes.push_back(gap->b_brush);

      // End of the road, folks!
      node->front_l = leaf;

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

    qNode_c *node = new qNode_c(+1 /* dz */);

    // choose height halfway between the two gaps (in the solid)
    node->z = (R->gaps[new_g-1]->GetZ2() + R->gaps[new_g]->GetZ1()) / 2.0;

    top_leaf->numgap = leaf->gap + leaf->numgap - new_g;
        leaf->numgap = new_g - leaf->gap;

    Partition_Z(top_leaf, &node->front_n, &node->front_l);
    Partition_Z(    leaf, &node->back_n,  &node->back_l);

    *out_n = node;
    return;
  }

  SYS_ASSERT(leaf->numgap == 1);

  // create face list for the leaf
  leaf->AssignFaces();


  // create floor and ceiling faces here
  qFace_c * floor = new qFace_c(qFace_c::FLOOR);
  qFace_c * ceil  = new qFace_c(qFace_c::CEIL);

  floor->gap = leaf->gap;
   ceil->gap = leaf->gap;

  floor->leaf = leaf;
   ceil->leaf = leaf;

  leaf->faces.push_back(floor);
  leaf->faces.push_back(ceil);


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
DebugPrintf("LEAF %p IS CONVEX\n", leaf);

    leaf->ComputeBBox();
    
    bool too_big = false;
    
    // faces must not be too large because of the way the Quake
    // texture mapping works.  Here we are abusing the node
    // builder to ensure floor and ceiling faces are OK.
    double l_width  = leaf->max_x - leaf->min_x;
    double l_height = leaf->max_y - leaf->min_y;

    if (l_width > FACE_MAX_SIZE || l_height > FACE_MAX_SIZE)
    {
DebugPrintf("__ BUT TOO BIG: %1.0f x %1.0f\n", l_width , l_height);

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

    node = new qNode_c();

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
    node = new qNode_c();

    node->x = best_p->x1;
    node->y = best_p->y1;

    node->dx = best_p->x2 - node->x;
    node->dy = best_p->y2 - node->y;
  }


DebugPrintf("Using partition (%1.0f,%1.0f) to (%1.2f,%1.2f)\n",
                 node->x, node->y,
                 node->x + node->dx, node->y + node->dy);

  qLeaf_c *front_l = leaf;
  qLeaf_c *back_l  = new qLeaf_c;

  Split_XY(node, front_l, back_l);


  Partition_XY(front_l, &node->front_n, &node->front_l);
  Partition_XY( back_l, &node-> back_n, &node-> back_l);

  *out_n = node;
}


static void DoAddFace(qSide_c *S, csg_brush_c *B, csg_face_c *AF,
                      int gap, double z1, double z2)
{
  SYS_ASSERT(z2 > z1);


DebugPrintf("BRUSH FOR FACE: seg (%1.0f %1.0f) -> (%1.0f %1.0f) z1:%1.0f z2:%1.0f\n",
S->seg->start->x, S->seg->start->y, S->seg->end->x, S->seg->end->y,
z1, z2);
if (! B)
DebugPrintf("--> NONE!\n");
else
DebugPrintf("--> %p z1:%1.0f z2:%1.0f bbox (%1.0f %1.0f) -> (%1.0f %1.0f)\n",
B, B->z1, B->z2, B->min_x, B->min_y, B->max_x, B->max_y);


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

      DoAddFace(S, B, AF, gap, nz1, nz2);
    }

    return;
  }

  qFace_c *F = new qFace_c(qFace_c::WALL, gap, z1, z2);

  F->brush = B;  // might be NULL (ARGH!)
  F->info  = AF;


  S->AddFace(F);
}


static void MakeSide(qLeaf_c *leaf, merge_segment_c *seg, int side)
{
  qSide_c *S = leaf->AddSide(seg, side);

  // create the faces
  merge_region_c *R  = (side == 0) ? seg->front : seg->back;
  merge_region_c *RX = (side == 0) ? seg->back  : seg->front;

  for (unsigned int k = 0; k < R->gaps.size(); k++)
  {
    merge_gap_c *G = R->gaps[k];

    double gz1 = G->GetZ1();
    double gz2 = G->GetZ2();

    // simple case: other side is completely solid
    if (RX == NULL || RX->gaps.size() == 0)
    {
      csg_brush_c *B  = CSG2_FindSideBrush(seg, (gz1+gz2)/2.0, side==1);
      csg_face_c *AF = CSG2_FindSideFace( seg, (gz1+gz2)/2.0, side==1);

      DoAddFace(S, B, AF, k, gz1, gz2);

///fprintf(stderr, "Making face %1.0f..%1.0f gap:%u on one-sided line (%1.0f,%1.0f) - (%1.0f,%1.0f)\n",
///        gz1, gz2, k, S->x1, S->y1, S->x2, S->y2);
      continue;
    }

    // complex case: compare with solids on other side

    for (unsigned m = 0; m <= RX->gaps.size(); m++)
    {
      double sz1 = (m == 0) ? -9e6 : RX->gaps[m-1]->GetZ2();
      double sz2 = (m == RX->gaps.size()) ? +9e6 : RX->gaps[m]->GetZ1();

      if (sz1 < gz1) sz1 = gz1;
      if (sz2 > gz2) sz2 = gz2;

      csg_brush_c *B  = CSG2_FindSideBrush(seg, (sz1+sz2)/2.0, side==1);
      csg_face_c *AF = CSG2_FindSideFace( seg, (sz1+sz2)/2.0, side==1);

      if (sz2 > sz1 + 0.99)  // don't create tiny faces
      {
        DoAddFace(S, B, AF, k, sz1, sz2);

///fprintf(stderr, "Making face %1.0f..%1.0f gap:%u neighbour:%u (%1.0f,%1.0f) - (%1.0f,%1.0f) side:%d\n",
///        sz1, sz2, k, m, S->x1, S->y1, S->x2, S->y2, side);
      }
    }
  }
}



//------------------------------------------------------------------------

static dmodel2_t model;

static qLump_c *q_nodes;
static qLump_c *q_leafs;
static qLump_c *q_faces;
static qLump_c *q_leaf_faces;
static qLump_c *q_leaf_brushes;
static qLump_c *q_surf_edges;

static int total_nodes;
static int total_leafs;
static int total_leaf_faces;
static int total_leaf_brushes;
static int total_surf_edges;


static void DoAddEdge(double x1, double y1, double z1,
                      double x2, double y2, double z2,
                      dface2_t *face, dleaf2_t *raw_lf = NULL)
{
  u16_t v1 = BSP_AddVertex(x1, y1, z1);
  u16_t v2 = BSP_AddVertex(x2, y2, z2);

  if (v1 == v2)
  {
    Main_FatalError("INTERNAL ERROR (Q2 AddEdge): zero length!\n"
                    "coordinate (%1.2f %1.2f %1.2f)\n", x1, y1, z1);
  }

  s32_t edge_idx = BSP_AddEdge(v1, v2);


  edge_idx = LE_S32(edge_idx);

  q_surf_edges->Append(&edge_idx, 4);

  total_surf_edges += 1;

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


static void DoAddSurf(u16_t index, dleaf2_t *raw_lf )
{
    index = LE_U16(index);

    q_leaf_faces->Append(&index, 2);

    total_leaf_faces += 1;

    raw_lf->num_leaffaces += 1;
}

static void DoCollisionBrush(csg_brush_c *A, dleaf2_t *raw_lf)
{
  u16_t index = LE_U16(Q2_AddBrush(A));

  q_leaf_brushes->Append(&index, 2);

  total_leaf_brushes += 1;

  raw_lf->num_leafbrushes += 1;
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
  if (strstr(tex_name, "/sky"))
    return SURF_SKY | SURF_NODRAW;

  return 0;
}

static double DotProduct3(const double *A, const double *B)
{
  return A[0] * B[0] + A[1] * B[1] + A[2] * B[2];
}

static void GetExtents(double min_s, double min_t, double max_s, double max_t,
                       int *ext_W, int *ext_H)
{
  // -AJA- this matches the logic in the QuakeII engine.

  int bmin_s = (int)floor(min_s / 16.0);
  int bmin_t = (int)floor(min_t / 16.0);

  int bmax_s = (int)ceil(max_s / 16.0);
  int bmax_t = (int)ceil(max_t / 16.0);

  *ext_W = MIN(2, bmax_s - bmin_s + 1);
  *ext_H = MIN(2, bmax_t - bmin_t + 1);
}

static void MakeFloorFace(qFace_c *F, qNode_c *N, dface2_t *face)
{
  bool is_ceil = (F->kind == qFace_c::CEIL) ? true : false;

  qLeaf_c *leaf = F->leaf;
  SYS_ASSERT(leaf);

  merge_region_c *R = leaf->GetRegion();
  SYS_ASSERT(R);

  merge_gap_c *gap = R->gaps.at(F->gap);

  double z1 = gap->GetZ1();
  double z2 = gap->GetZ2();

  double z = is_ceil ? z2 : z1;
///fprintf(stderr, "MakeFloorFace: F=%p kind:%d @ z:%1.0f\n", F, F->kind, z);


  // use same plane as node  (FIXME: transfer actual value in)
  face->planenum = BSP_AddPlane(0, 0, z, 0, 0, +1);

  face->side = is_ceil ? 1 : 0;

  const char *texture = is_ceil ? gap->CeilTex() : gap->FloorTex();

  int flags = CalcTextureFlag(texture);

  double s[4] = { 1.0, 0.0, 0.0, 0.0 };
  double t[4] = { 0.0, 1.0, 0.0, 0.0 };

  face->texinfo = Q2_AddTexInfo(texture, flags, 0, s, t);

  face->styles[0] = 0xFF;  // no lightmap
  face->styles[1] = 0xFF;  // fairly bright
  face->styles[2] = 0xFF;
  face->styles[3] = 0xFF;

  face->lightofs = -1;  // no lightmap

  // collect the vertices and sort in clockwise order

  float vert_x[256];
  float vert_y[256];

  int v_num = CollectClockwiseVerts(vert_x, vert_y, leaf, is_ceil);

  double min_x = +9e9; double max_x = -9e9;
  double min_y = +9e9; double max_y = -9e9;


  // add the edges

  face->firstedge = total_surf_edges;
  face->numedges  = 0;

  for (int pos = 0; pos < v_num; pos++)
  {
    int p2 = (pos + 1) % v_num;

    DoAddEdge(vert_x[pos], vert_y[pos], z,
              vert_x[p2 ], vert_y[p2 ], z, face);

    min_x = MIN(min_x, vert_x[pos]);
    min_y = MIN(min_y, vert_y[pos]);
    max_x = MAX(max_x, vert_x[pos]);
    max_y = MAX(max_y, vert_y[pos]);
  }


  // lighting

  if (1) ///### ! (flags & TEX_SPECIAL))
  {
    int ext_W, ext_H;

    GetExtents(min_x, min_y, max_x, max_y, &ext_W, &ext_H);

    static int foo; foo++;
    face->styles[0] = 0; //!!!!!

    face->lightofs = 100; //!!!! Quake1_LightAddBlock(ext_W, ext_H, rand()&0x7F);
  }

}

static void MakeWallFace(qFace_c *F, qNode_c *N, dface2_t *face)
{
  qSide_c *S = F->side;

  merge_region_c *R = S->GetRegion();
  SYS_ASSERT(R);

  qLeaf_c *leaf = F->leaf;
  SYS_ASSERT(leaf);

///  merge_gap_c *gap = R->gaps.at(F->gap);

  double z1 = F->z1;
  double z2 = F->z2;

  // use same plane as node  (FIXME: transfer actual value in)
  face->planenum = BSP_AddPlane(N->x, N->y, 0, N->dy, -N->dx, 0);

  face->side = 0;

  if ( (N->dx * (S->x2 - S->x1) + N->dy * (S->y2 - S->y1)) < 0 )
  {
    face->side = 1;
  }


  const char *texture = "error";

  if (F->info)
    texture = F->info->tex.c_str();
  else if (F->brush)
    texture = F->brush->w_face->tex.c_str();

  int flags = CalcTextureFlag(texture);

  double s[4] = { 0.0, 0.0, 0.0, 0.0 };
  double t[4] = { 0.0, 0.0, 1.0, 0.0 };

  if (fabs(S->x2 - S->x1) > fabs(S->y2 - S->y1))
  {
    s[0] = 1.0;
  }
  else
  {
    s[1] = 1.0;
  }

  face->texinfo = Q2_AddTexInfo(texture, flags, 0, s, t);

  face->styles[0] = 0xFF;  // no lightmap
  face->styles[1] = 0xFF;  // fairly bright
  face->styles[2] = 0xFF;
  face->styles[3] = 0xFF;

  face->lightofs = -1;  // no lightmap

  // add the edges

  face->firstedge = total_surf_edges;
  face->numedges  = 0;

  if (true) // face->side == 0)
  {
    DoAddEdge(S->x1, S->y1, z1,  S->x1, S->y1, z2,  face);
    DoAddEdge(S->x1, S->y1, z2,  S->x2, S->y2, z2,  face);
    DoAddEdge(S->x2, S->y2, z2,  S->x2, S->y2, z1,  face);
    DoAddEdge(S->x2, S->y2, z1,  S->x1, S->y1, z1,  face);
  }
  else
  {
    DoAddEdge(S->x1, S->y1, z2,  S->x1, S->y1, z1,  face);
    DoAddEdge(S->x1, S->y1, z1,  S->x2, S->y2, z1,  face);
    DoAddEdge(S->x2, S->y2, z1,  S->x2, S->y2, z2,  face);
    DoAddEdge(S->x2, S->y2, z2,  S->x1, S->y1, z2,  face);
  }


  if (1) ///###  ! (flags & TEX_SPECIAL))
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

    face->lightofs = 100; //!!!!! Quake1_LightAddBlock(ext_W, ext_H, 0x00|(rand()&0xFF));
  }
}

static void MakeFace(qFace_c *F, qNode_c *N)
{
  dface2_t face;

  if (F->kind == qFace_c::WALL)
    MakeWallFace(F, N, &face);
  else
    MakeFloorFace(F, N, &face);


  // FIXME: fix endianness in face

  u16_t index = model.numfaces++;

  if (index == MAX_MAP_FACES-1)
    Main_FatalError("Quake2 build failure: exceeded limit of %d FACES\n",
                    MAX_MAP_FACES);

  F->index = (int)index;

  q_faces->Append(&face, sizeof(face));
}


static s32_t WriteLeaf(qLeaf_c *leaf, dnode2_t *parent)
{
  dleaf2_t raw_lf;

  raw_lf.contents = leaf->contents;
  raw_lf.area     = 0;

  if (leaf->contents == CONTENTS_SOLID)
    raw_lf.cluster = -1;
  else
    raw_lf.cluster  = 0;

  int b;

  raw_lf.mins[0] = I_ROUND(leaf->min_x)-16;
  raw_lf.mins[1] = I_ROUND(leaf->min_y)-16;
  raw_lf.mins[2] = -2000;  //!!!!

  raw_lf.maxs[0] = I_ROUND(leaf->max_x)+16;
  raw_lf.maxs[1] = I_ROUND(leaf->max_y)+16;
  raw_lf.maxs[2] = 2000;  //!!!!

  raw_lf.first_leafface = total_leaf_faces;
  raw_lf.num_leaffaces  = 0;

  raw_lf.first_leafbrush  = total_leaf_brushes;
  raw_lf.num_leafbrushes  = 0;


  if (leaf->contents == CONTENTS_SOLID)
  {
    // make brushes
    for (unsigned int n = 0; n < leaf->brushes.size(); n++)
    {
      csg_brush_c *B = leaf->brushes[n];

      DoCollisionBrush(B, &raw_lf);
    }
  }
  else
  {
    // make faces
    for (unsigned int n = 0; n < leaf->faces.size(); n++)
    {
      qFace_c *F = leaf->faces[n];

      // should have been in a node already
      SYS_ASSERT(F->index >= 0);

      DoAddSurf(F->index, &raw_lf);
    }
  }


  for (b = 0; b < 3; b++)
  {
    parent->mins[b] = MIN(parent->mins[b], raw_lf.mins[b]);
    parent->maxs[b] = MAX(parent->maxs[b], raw_lf.maxs[b]);
  }


  // FIXME: fix endianness in raw_lf

  s32_t index = total_leafs++;

  if (index >= MAX_MAP_LEAFS)
    Main_FatalError("Quake2 build failure: exceeded limit of %d LEAFS\n",
                    MAX_MAP_LEAFS);

  q_leafs->Append(&raw_lf, sizeof(raw_lf));

  return -(index+1);
}

static s32_t RecursiveWriteNodes(qNode_c *node, dnode2_t *parent)
{
  dnode2_t raw_nd;

  int b;

  if (node->dz)
    raw_nd.planenum = BSP_AddPlane(0, 0, node->z, 0, 0, node->dz);
  else
  {
    raw_nd.planenum = BSP_AddPlane(node->x, node->y, 0,
                                   node->dy, -node->dx, 0);
  }

    // IMPORTANT!! Quake II assumes axis-aligned node planes are positive
    if (raw_nd.planenum & 1)
    {
      node->Flip();
      raw_nd.planenum ^= 1;
    }

  raw_nd.firstface = 0;
  raw_nd.numfaces  = 0;

  for (b = 0; b < 3; b++)
  {
    raw_nd.mins[b] = -3276;
    raw_nd.maxs[b] = +3276;
  }


  // make faces [NOTE: must be done before recursing down]
  for (unsigned int j = 0; j < node->faces.size(); j++)
  {
    qFace_c *F = node->faces[j];

///fprintf(stderr, "node face: %p kind:%d (node %1.4f,%1.4f += %1.4f,%1.4f)\n",
///        F, F->kind, node->x, node->y, node->dx, node->dy);

    SYS_ASSERT(F->index < 0);

    MakeFace(F, node);

    if (j == 0)
      raw_nd.firstface = F->index;
    
    raw_nd.numfaces++;
  }


  if (node->front_n)
    raw_nd.children[0] = RecursiveWriteNodes(node->front_n, &raw_nd);
  else
    raw_nd.children[0] = WriteLeaf(node->front_l, &raw_nd);

  if (node->back_n)
    raw_nd.children[1] = RecursiveWriteNodes(node->back_n, &raw_nd);
  else
    raw_nd.children[1] = WriteLeaf(node->back_l, &raw_nd);


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
  //       in the Quake1 code!).
  //
  //       FIXME: true for QuakeII too ??????

  if (! parent) // is_root
  {
    q_nodes->Prepend(&raw_nd, sizeof(raw_nd));

    return 0;
  }

  s32_t index = total_nodes++;

  if (index >= MAX_MAP_NODES)
    Main_FatalError("Quake2 build failure: exceeded limit of %d NODES\n",
                    MAX_MAP_NODES);

  q_nodes->Append(&raw_nd, sizeof(raw_nd));

  return index;
}


static void CreateDummyLeaf(void)
{
  dleaf2_t raw_lf;

  memset(&raw_lf, 0, sizeof(raw_lf));

  raw_lf.contents = CONTENTS_SOLID;

  q_leafs->Append(&raw_lf, sizeof(raw_lf));

  total_leafs++;
}

static void Q2_BuildBSP(void)
{
  qLeaf_c *begin = new qLeaf_c();

  for (unsigned int i = 0; i < mug_segments.size(); i++)
  {
    merge_segment_c *S = mug_segments[i];

    if (S->front && S->front->gaps.size() > 0)
      MakeSide(begin, S, 0);

    if (S->back && S->back->gaps.size() > 0)
      MakeSide(begin, S, 1);
  }

  // NOTE WELL: we assume at least one partition (hence at least
  //            one node).  The simplest possible map is already a
  //            convex space (no partitions are needed) so in that
  //            case we use an arbitrary splitter plane.

  LogPrintf("\nQ2_BuildBSP BEGUN\n");

  Partition_XY(begin, &Q_ROOT, NULL);
}


void Q2_CreateModel(void)
{
  qLump_c *lump = BSP_NewLump(LUMP_MODELS);

///  dmodel_t model;

  model.firstface = 0;
  model.numfaces  = 0;

  total_leafs = 0;
  total_nodes = 1;  // root node is always first

  total_leaf_faces = 0;
  total_leaf_brushes = 0;
  total_surf_edges = 0;

  q_nodes = BSP_NewLump(LUMP_NODES);
  q_leafs = BSP_NewLump(LUMP_LEAFS);
  q_faces = BSP_NewLump(LUMP_FACES);

  q_leaf_faces   = BSP_NewLump(LUMP_LEAFFACES);
  q_leaf_brushes = BSP_NewLump(LUMP_LEAFBRUSHES);
  q_surf_edges   = BSP_NewLump(LUMP_SURFEDGES);

  CreateDummyLeaf();

  Q2_BuildBSP();

  RecursiveWriteNodes(Q_ROOT, NULL /* parent */);


  // set model bounding box
  model.mins[0] = bounds_x1;  model.maxs[0] = bounds_x2;
  model.mins[1] = bounds_y1;  model.maxs[1] = bounds_y2;
  model.mins[2] = bounds_z1;  model.maxs[2] = bounds_z2;

  model.origin[0] = 0;
  model.origin[1] = 0;
  model.origin[2] = 0;

  model.headnode = 0; // root of drawing BSP


  // FIXME: fix endianness in model

  lump->Append(&model, sizeof(model));
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
