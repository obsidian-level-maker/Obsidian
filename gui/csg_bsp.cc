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


#define SNAG_EPSILON  0.001


/***** CLASSES ******************/

class region_c;
class snag_c;


class partition_c
{
public:
  double x1, y1;
  double x2, y2;

public:
  partition_c(double _x1, double _y1, double _x2, double _y2) :
      x1(_x1), y1(_y1), x2(_x2), y2(_y2)
  { }

  partition_c(const snag_c *S);

  ~partition_c()
  { }
};


class snag_c
{
public:
  double x1, y1;
  double x2, y2;

  bool mini;

  partition_c * on_node;

  region_c *where;  // only valid AFTER MergeRegions()

  snag_c *partner;  // only valid AFTER HandleOverlaps()

  std::vector<brush_vert_c *> sides;

  // quantized along values, used for overlap detection
  int q_along1;
  int q_along2;

private:
  snag_c(const snag_c& other) :
      x1(other.x1), y1(other.y1), x2(other.x2), y2(other.y2),
      mini(other.mini), on_node(other.on_node),
      where(other.where), partner(NULL),
      sides()
  {
    // copy sides
    for (unsigned int i = 0 ; i < other.sides.size() ; i++)
      sides.push_back(other.sides[i]);
  }

public:
  snag_c(brush_vert_c *start, brush_vert_c *end, brush_vert_c *side) :
      x1(start->x), y1(start->y), x2(end->x), y2(end->y),
      mini(false), on_node(NULL), where(NULL), partner(NULL),
      sides()
  {
    if (Length() < SNAG_EPSILON)
      Main_FatalError("Line loop contains zero-length line! (%1.2f %1.2f)\n", x1, y1);

    sides.push_back(side);
  }

  snag_c(double _x1, double _y1, double _x2, double _y2, partition_c *part) :
      x1(_x1), y1(_y1), x2(_x2), y2(_y2),
      mini(true), on_node(part), where(NULL), partner(NULL),
      sides()
  { }

  ~snag_c()
  { }

  double Length() const
  {
    return ComputeDist(x1,y1, x2,y2);
  }

  snag_c * Cut(double ix, double iy)
  {
    snag_c *T = new snag_c(*this);

    x2 = ix; T->x1 = ix;
    y2 = iy; T->y1 = iy;

    return T;
  }

  void CalcAlongs()
  {
    SYS_ASSERT(on_node);

    double a1 = AlongDist(x1, y1, on_node->x1,on_node->y1, on_node->x2,on_node->y2);
    double a2 = AlongDist(x2, y2, on_node->x1,on_node->y1, on_node->x2,on_node->y2);

    a1 /= SNAG_EPSILON;
    a2 /= SNAG_EPSILON;

    q_along1 = I_ROUND(a1);
    q_along2 = I_ROUND(a2);
  }
};


class region_c
{
public:
  std::vector<snag_c *> snags;

  std::vector<csg_brush_c *> brushes;

public:
  region_c() : snags(), brushes()
  { }

  region_c(const region_c& other) : snags(), brushes()
  {
    for (unsigned int i = 0 ; i < other.brushes.size() ; i++)
      brushes.push_back(other.brushes[i]);
  }

  ~region_c()
  { }

  void AddSnag(snag_c *S)
  {
    snags.push_back(S);
  }

  bool HasSnag(snag_c *S) const
  {
    for (unsigned int i = 0 ; i < snags.size() ; i++)
      if (snags[i] == S)
        return true;

    return false;
  }

  bool RemoveSnag(snag_c *S)
  {
    for (unsigned int i = 0 ; i < snags.size() ; i++)
    {
      if (snags[i] == S)
      {
        snags[i] = snags.back();
        snags.pop_back();
        return true;
      }
    }

    return false;
  }

  void AddBrush(csg_brush_c *P)
  {
    brushes.push_back(P);
  }

  int TestSide(partition_c *P);

  void MergeOther(region_c *other)
  {
    unsigned int i;

    // TODO: snags and brushes should never be duplicated by a merge,
    //       however for robustness we should check and skip them.

    for (i = 0 ; i < other->snags.size() ; i++)
      AddSnag(other->snags[i]);

    for (i = 0 ; i < other->brushes.size() ; i++)
      AddBrush(other->brushes[i]);

    other->snags.clear();
    other->brushes.clear();
  }

  void GetBounds(double *x1, double *y1, double *x2, double *y2)
  {
    if (snags.empty())
    {
      *x1 = *x2 = *y1 = *y2 = 0;
      return;
    }

    *x1 = *y1 = +9e9;
    *x2 = *y2 = -9e9;

    for (unsigned int i = 0 ; i < snags.size() ; i++)
    {
      snag_c *S = snags[i];

      *x1 = MIN(*x1, MIN(S->x1, S->x2));
      *y1 = MIN(*y1, MIN(S->y1, S->y2));

      *x2 = MAX(*x1, MAX(S->x1, S->x2));
      *y2 = MAX(*y1, MAX(S->y1, S->y2));
    }
  }

  void GetMidPoint(double *mid_x, double *mid_y)
  {
    *mid_x = *mid_y = 0;

    if (snags.empty())
      return;

    for (unsigned int i = 0 ; i < snags.size() ; i++)
    {
      snag_c *S = snags[i];

      *mid_x += S->x1 + S->x2;
      *mid_y += S->y1 + S->y2;
    }

    double total = 2 * snags.size();

    *mid_x /= total;
    *mid_y /= total;
  }

  void SortBrushes();

  bool HasSameBrushes(const region_c *other) const
  {
    // NOTE WELL: assumes brushes have been sorted

    if (brushes.size() != other->brushes.size())
      return false;

    for (unsigned int i = 0 ; i < brushes.size() ; i++)
      if (brushes[i] != other->brushes[i])
        return false;

    return true;
  }

  void ClockwiseSnags()
  {
    if (snags.size() < 2)
      return;

    int i;
    int total = (int)snags.size();

    // determine angle of each snag's starting vertex
    double * angles = new double[total];

    double mid_x, mid_y;

    GetMidPoint(&mid_x, &mid_y);

    for (i = 0 ; i < total ; i++)
    {
      snag_c *S = snags[i];

      angles[i] = CalcAngle(mid_x, mid_y, S->x1, S->y1);
    }

    i = 0;

    const double ANG_EPSILON = 0.0001;

    while (i+1 < total)
    {
      snag_c *A = snags[i];
      snag_c *B = snags[i+1];

      if (angles[i] < angles[i+1] - ANG_EPSILON)
      {
        // swap 'em
        snags[i] = B; snags[i+1] = A;

        std::swap(angles[i], angles[i+1]);

        // bubble down
        if (i > 0) i--;
      }
      else
      {
        // bubble up
        i++;
      }
    }
  }
};


partition_c::partition_c(const snag_c *S) :
    x1(S->x1), y1(S->y1), x2(S->x2), y2(S->y2)
{ }


struct csg_brush_ptr_Compare
{
  inline bool operator() (const csg_brush_c *A, const csg_brush_c *B) const
  {
    return A < B;
  }
};

struct snag_on_node_Compare
{
  inline bool operator() (const snag_c *A, const snag_c *B) const
  {
    return A->on_node < B->on_node;
  }
};


void region_c::SortBrushes()
{
  std::sort(brushes.begin(), brushes.end(), csg_brush_ptr_Compare());
}



/***** VARIABLES ******************/

static bool do_clip_brushes;

static std::vector<partition_c *> all_partitions;

static std::vector<snag_c *> all_snags;

// first region is always a dummy
static std::vector<region_c *> all_regions;



//------------------------------------------------------------------------

static void CreateRegion(std::vector<region_c *> & group, csg_brush_c *P)
{
  SYS_ASSERT(P);

  if (! do_clip_brushes && P->bkind == BKIND_Clip)
    return;

  region_c *R = new region_c;

  all_regions.push_back(R);

  R->AddBrush(P);

  // NOTE: brush sides go ANTI-clockwise, region snags go CLOCKWISE,
  //       hence we need to flip them here.

  int total = (int)P->verts.size();

  for (int k = total-1 ; k >= 0 ; k--)
  {
    int k2 = (k + total - 1) % total;

    brush_vert_c *v1 = P->verts[k];
    brush_vert_c *v2 = P->verts[k2];

    snag_c *S = new snag_c(v1, v2, v2);

    all_snags.push_back(S);

    R->AddSnag(S);
  }

  group.push_back(R);
}


static void MoveOntoLine(partition_c *part, double *x, double *y)
{
  double along = AlongDist(*x, *y, part->x1,part->y1, part->x2,part->y2);

  AlongCoord(along, part->x1,part->y1, part->x2,part->y2, x, y);
}


int region_c::TestSide(partition_c *part)
{
  bool has_front = false;
  bool has_back  = false;

  for (unsigned int i = 0 ; i < snags.size() ; i++)
  {
    snag_c *S = snags[i];
    
    double a = PerpDist(S->x1,S->y1, part->x1,part->y1, part->x2,part->y2);
    double b = PerpDist(S->x2,S->y2, part->x1,part->y1, part->x2,part->y2);

    int a_side = (a < -SNAG_EPSILON) ? -1 : (a > SNAG_EPSILON) ? +1 : 0;
    int b_side = (b < -SNAG_EPSILON) ? -1 : (b > SNAG_EPSILON) ? +1 : 0;

    if (a_side == 0 && b_side == 0)
    {
      S->on_node = part;
    }

    if (a_side > 0 || b_side > 0) has_front = true;
    if (a_side < 0 || b_side < 0) has_back  = true;

    // adjust vertices which sit "nearly" on the line
//!!!!!!    if (a_side == 0) MoveOntoLine(part, &S->x1, &S->y1);
//!!!!!!    if (b_side == 0) MoveOntoLine(part, &S->x2, &S->y2);
  }

  if (has_back && has_front)
    return 0;

  return has_back ? -1 : +1;
}


static void DivideOneSnag(snag_c *S, partition_c *part,
                          region_c *front, region_c *back,
                          double *along_min, double *along_max)
{
	// get relationship of lines to each other
	double a = PerpDist(S->x1,S->y1, part->x1,part->y1,part->x2,part->y2);
	double b = PerpDist(S->x2,S->y2, part->x1,part->y1,part->x2,part->y2);

	int a_side = (a < -SNAG_EPSILON) ? -1 : (a > SNAG_EPSILON) ? +1 : 0;
	int b_side = (b < -SNAG_EPSILON) ? -1 : (b > SNAG_EPSILON) ? +1 : 0;

  // THIS SHOULD NOT HAPPEN
  if (a_side == 0 && b_side == 0)
  {
    // TODO: a softer landing
    Main_FatalError("DivideOneSnag: region contains snag along partition line!\n");

#if 0
		// this snag runs along the same line as the partition.
		// check whether it goes in the same direction or the opposite.
    S->on_node = true;

    // FIXME: is this correct??
    if (S->partner)
      S->partner->on_node = true;

		if (VectorSameDir(part->x2 - part->x1, part->y2 - part->y1,
                      S->x2 - S->x1, S->y2 - S->y1))
		{
      front->AddSnag(S);
		}
		else
		{
      back->AddSnag(S);
		}
		return;
#endif
  }


  // intersection stuff  -- FIXME: duplicated code
  if (a_side != b_side)
  {
    double ix, iy;

    CalcIntersection(S->x1, S->y1, S->x2, S->y2,
                     part->x1, part->y1, part->x2, part->y2,
                     &ix, &iy);

    double along = AlongDist(ix, iy, part->x1, part->y1, part->x2, part->y2);

    *along_min = MIN(*along_min, along);
    *along_max = MAX(*along_max, along);
  }

	// completely on front side?
	if (a_side >= 0 && b_side >= 0)
	{
    front->AddSnag(S);
		return;
	}

	// completely on back side?
	if (a_side <= 0 && b_side <= 0)
	{
    back->AddSnag(S);
		return;
	}

	// when we reach here, we have a and b non-zero and opposite sign,
	// hence this snag will be cut by the partition line.

	SYS_ASSERT(a_side == -b_side);

	double ix, iy;

	CalcIntersection(S->x1, S->y1, S->x2, S->y2,
                   part->x1, part->y1, part->x2, part->y2,
                   &ix, &iy);

  snag_c *T = S->Cut(ix, iy);

  all_snags.push_back(T);

	if (a_side < 0)
	{
     back->AddSnag(S);
    front->AddSnag(T);
	}
	else
	{
    front->AddSnag(S);
     back->AddSnag(T);
	}
}


static void DivideOneRegion(region_c *R, partition_c *part,
                            std::vector<region_c *> & front,
                            std::vector<region_c *> & back)
{
  int side = R->TestSide(part);

  if (side > 0)
  {
    front.push_back(R);
    return;
  }
  else if (side < 0)
  {
    back.push_back(R);
    return;
  }

  // --- region needs to be split ---

  region_c *N = new region_c(*R);

  all_regions.push_back(N);

  // iterate over a swapped-out version of the region's snags
  // (so we can safely add certain ones back into R->snags)
  std::vector<snag_c *> local_snags;

  std::swap(R->snags, local_snags);

  // compute intersection points
  double along_min =  9e9;
  double along_max = -9e9;

  for (unsigned int i = 0 ; i < local_snags.size() ; i++)
  {
    snag_c *S = local_snags[i];

    DivideOneSnag(S, part, R, N, &along_min, &along_max);
  }

  front.push_back(R);
   back.push_back(N);

  // --- add the mini snags ---

  SYS_ASSERT(along_max > along_min + SNAG_EPSILON);

  {
    double x1, y1;
    double x2, y2;

    AlongCoord(along_min, part->x1,part->y1, part->x2,part->y2, &x1, &y1);
    AlongCoord(along_max, part->x1,part->y1, part->x2,part->y2, &x2, &y2);

    snag_c *front_S = new snag_c(x1,y1, x2,y2, part);
    snag_c * back_S = new snag_c(x2,y2, x1,y1, part);

    all_snags.push_back(front_S);
    all_snags.push_back(back_S);

    R->snags.push_back(front_S);
    N->snags.push_back(back_S);
  }
}


static void MergeRegions(std::vector<region_c *> & group)
{
  region_c *R = group[0];

  for (unsigned int i = 1 ; i < group.size() ; i++)
  {
    R->MergeOther(group[i]);
  }

  // can now set the 'where' field of snags

  for (unsigned int k = 0 ; k < R->snags.size() ; k++)
    R->snags[k]->where = R;

  // snags themselves get merged/etc in HandleOverlaps()
}


static partition_c * AddPartition(const snag_c *S)
{
  all_partitions.push_back(new partition_c(S));

  return all_partitions.back();
}

static partition_c * AddPartition(double x1, double y1, double x2, double y2)
{
  all_partitions.push_back(new partition_c(x1, y1, x2, y2));

  return all_partitions.back();
}


static void GetGroupBounds(std::vector<region_c *> & group,
                           double *min_x, double *min_y,
                           double *max_x, double *max_y)
{
  *min_x = *min_y = +9e9;
  *max_x = *max_y = -9e9;

  for (unsigned int k = 0 ; k < group.size() ; k++)
  {
    double x1, y1, x2, y2;

    group[k]->GetBounds(&x1, &y1, &x2, &y2);

    *min_x = MIN(*min_x, x1);
    *min_y = MIN(*min_y, y1);

    *max_x = MAX(*max_x, x1);
    *max_y = MAX(*max_y, y1);
  }
}


static partition_c * ChoosePartition(std::vector<region_c *> & group)
{
  // do seed-wise binary subdivision thang
  // FIXME: EXPLAIN THIS SHITE

#define CHUNK_SIZE  384.0

  double gx1, gy1, gx2, gy2;

  GetGroupBounds(group, &gx1, &gy1, &gx2, &gy2);

  int sx1 = floor(gx1 / CHUNK_SIZE + SNAG_EPSILON);
  int sy1 = floor(gy1 / CHUNK_SIZE + SNAG_EPSILON);
  int sx2 =  ceil(gx2 / CHUNK_SIZE - SNAG_EPSILON);
  int sy2 =  ceil(gy2 / CHUNK_SIZE - SNAG_EPSILON);

  int sw  = sx2 - sx1;
  int sh  = sy2 - sy1;

fprintf(stderr, "bounds (%1.5f %1.5f) .. (%1.5f %1.5f)\n", gx1, gy1, gx2, gy2);
fprintf(stderr, " sx/sy (%d,%d) .. (%d,%d) = %dx%d\n",  sx1, sy1, sx2, sy2, sw, sh);

  if ((sw >= 2 && gy2 > gy1+1) || 
      (sh >= 2 && gx2 > gx1+1))
  {
    if (sw >= sh)
    {
      double px = (sx1 + sw/2) * CHUNK_SIZE;
      return AddPartition(px, gy1, px, gy2);
    }
    else
    {
      double py = (sy1 + sh/2) * CHUNK_SIZE;
      return AddPartition(gx1, py, gx2, py);
    }
  }


  snag_c *best = NULL;

  for (unsigned int i = 0 ; i < group.size() ; i++)
  {
    region_c *R = group[i];

    for (unsigned int k = 0 ; k < R->snags.size() ; k++)
    {
      snag_c *S = R->snags[k];

      if (! S->on_node)
      {
        // FIXME !!!! choose properly
        //            (prefer horizontal/vertical which splits bbox well)

        if (! best || (best->x1 != best->x2 && best->y1 != best->y2))
          best = S;
      }
    }
  }

  if (! best)
    return NULL;

fprintf(stderr, "best = %p\n", best);
  return AddPartition(best);
}


static void SplitGroup(std::vector<region_c *> & group)
{
  if (group.empty())
    return;

  // Note: there is no explicit check for convexitiy.  We keep going until
  //       every snag has been on a partition.  This means that a convex
  //       region will usually get be "split" multiple times where
  //       everything goes to the front and nothing to the back.
  //
  partition_c *part = ChoosePartition(group);

  if (part)
  {
    fprintf(stderr, "Partition: (%1.2f %1.2f) --> (%1.2f %1.2f)\n",
            part->x1, part->y1, part->x2, part->y2);

    // divide the group
    std::vector<region_c *> front;
    std::vector<region_c *> back;

    for (unsigned int i = 0 ; i < group.size() ; i++)
    {
      DivideOneRegion(group[i], part, front, back);
    }

    // recursively handle each side
    SplitGroup(front); 
    SplitGroup(back); 

    // input group has been consumed now 
  }
  else
  {
    // at here, we have a leaf group which is convex,
    // hence merge all the regions into one.

    MergeRegions(group);
  }
}


//------------------------------------------------------------------------

static bool MergeSnags(snag_c *A, snag_c *B)
{
  SYS_ASSERT(A->where);
  SYS_ASSERT(A->where == B->where);

  if (! B->mini)
    A->mini = false;

  B->where->RemoveSnag(B);

  B->where = NULL;  // mark as unused

  return true;
}


static bool PartnerSnags(snag_c *A, snag_c *B)
{
  A->partner = B;
  B->partner = A;

  // mere partnering is not significant (won't need an extra pass)
  return false;
}


static bool SplitSnag(snag_c *S, double ix, double iy,
                      std::vector<snag_c *> & overlap_list)
{
  snag_c *T = S->Cut(ix, iy);

  all_snags.push_back(T);

  S->where->AddSnag(T);

  overlap_list.push_back(T);

  S->CalcAlongs();
  T->CalcAlongs();

  return true;
}


static bool TestOverlap(std::vector<snag_c *> & list, int i, int k)
{
  snag_c *A = list[i];
  snag_c *B = list[k];

  if (! A || ! B)
    return false;

  int a_min = MIN(A->q_along1, A->q_along2);
  int a_max = MAX(A->q_along1, A->q_along2);

  int b_min = MIN(B->q_along1, B->q_along2);
  int b_max = MAX(B->q_along1, B->q_along2);

  if (a_min >= b_max || a_max <= b_min)
    return false;

  // Note: it's possible one of the new (split off) snags is still
  //       overlapping another one.  This will be detected and handled
  //       in a future pass.

  if (B->q_along1 > a_min && B->q_along1 < a_max)
    return SplitSnag(A, B->x1, B->y1, list);

  if (B->q_along2 > a_min && B->q_along2 < a_max)
    return SplitSnag(A, B->x2, B->y2, list);

  if (A->q_along1 > b_min && A->q_along1 < b_max)
    return SplitSnag(B, A->x1, A->y1, list);

  if (A->q_along2 > b_min && A->q_along2 < b_max)
    return SplitSnag(B, A->x2, A->y2, list);

  // to get here, the snags must be directly overlapping.

  SYS_ASSERT(a_min == b_min);
  SYS_ASSERT(a_max == b_max);

  // same direction?
  if (A->q_along1 == B->q_along1)
  {
    list[k] = NULL;  // remove B from the list

    return MergeSnags(A, B);
  }
  else
  {
    return PartnerSnags(A, B);
  }
}


static void ProcessOverlapList(std::vector<snag_c *> & overlap_list)
{
  partition_c *part = overlap_list[0]->on_node;

  fprintf(stderr, "ProcessOverlapList: %u snags\n", overlap_list.size());

  for (unsigned int i = 0 ; i < overlap_list.size() ; i++)
    overlap_list[i]->CalcAlongs();

  // TODO: sort list by MIN(q_along), take advantage of that

  int changes;

  do
  {
    changes = 0;

for (int z = 0 ; z < (int)overlap_list.size() ; z++)
  fprintf(stderr, "    snag %p : (%1.0f %1.0f) --> (%1.0f %1.0f)  partner %p\n",
          overlap_list[z],
          overlap_list[z] ? overlap_list[z]->x1 : 0,
          overlap_list[z] ? overlap_list[z]->y1 : 0,
          overlap_list[z] ? overlap_list[z]->x2 : 0,
          overlap_list[z] ? overlap_list[z]->y2 : 0,
          overlap_list[z] ? overlap_list[z]->partner : NULL);

    // Note that new snags may get added (due to splits) while we are
    // iterating over them.  Removed snags become NULL in the list.

    for (int i = 0   ; i < (int)overlap_list.size() ; i++)
    for (int k = i+1 ; k < (int)overlap_list.size() ; k++)
    {
      if (TestOverlap(overlap_list, i, k))
        changes++;
    }

    fprintf(stderr, "  %d changes\n", changes);

  } while (changes > 0);
}


static void HandleOverlaps()
{
  // process each set of snags which lie on the same partition
  // (determined by sorting the snags by their 'on_node' pointer).

  // !!!! FIXME: collect 'all_snags' now (from all_regions)

  std::sort(all_snags.begin(), all_snags.end(), snag_on_node_Compare());

  unsigned int i, k;
  unsigned int total = all_snags.size();

  for (i = 0 ; i < total ; i = k+1)
  {
    k = i;

    while (k+1 < total && all_snags[k+1]->on_node == all_snags[k]->on_node)
      k++;

fprintf(stderr, "ON NODE %p : %u snags\n", all_snags[i]->on_node, k-i+1);

    if (k > i && all_snags[i]->on_node)
    {

      // copy into a new list, a place where split pieces can go
      std::vector<snag_c *> overlap_list;

      for ( ; i <= k ; i++)
        overlap_list.push_back(all_snags[i]);

      ProcessOverlapList(overlap_list);
    }
  }
}


static void AddBoundingRegion(std::vector<region_c *> & group)
{
  double map_x1, map_y1;
  double map_x2, map_y2;

  GetGroupBounds(group, &map_x1, &map_y1, &map_x2, &map_y2);

  SYS_ASSERT(map_x1 < map_x2);
  SYS_ASSERT(map_y1 < map_y2);

  // make the coords integers
  map_x1 = floor(map_x1); map_x2 = ceil(map_x2);
  map_y1 = floor(map_y1); map_y2 = ceil(map_y2);

  // create the dummy region
  region_c *R = new region_c;

  all_regions.push_back(R);

  snag_c *snags[4];

  snags[0] = new snag_c(map_x1, map_y1, map_x1, map_y2, NULL);
  snags[1] = new snag_c(map_x1, map_y2, map_x2, map_y2, NULL);
  snags[2] = new snag_c(map_x2, map_y2, map_x2, map_y1, NULL);
  snags[3] = new snag_c(map_x2, map_y1, map_x1, map_y1, NULL);

  for (int n = 0 ; n < 4 ; n++)
  {
    R->snags.push_back(snags[n]);

    all_snags.push_back(snags[n]);
  }

  group.push_back(R);
}


void CSG_BSP()
{
  all_partitions.clear();
  all_snags.clear();
  all_regions.clear();

  std::vector<region_c *> root_group;

  for (unsigned int i=0; i < all_brushes.size(); i++)
    CreateRegion(root_group, all_brushes[i]);

  // create a rectangle region around whole map
  AddBoundingRegion(root_group);

  SplitGroup(root_group);

  HandleOverlaps();

  for (unsigned int i=0; i < all_regions.size(); i++)
  {
    all_regions[i]->SortBrushes();
    all_regions[i]->ClockwiseSnags();
  }

fprintf(stderr, "\n");

  // FIXME: free stuff
}


//------------------------------------------------------------------------
//   TEMPORARY TEST CRUD
//------------------------------------------------------------------------

#include "dm_wad.h"

static std::map<int, int> test_vertices;

int TestVertex(snag_c *S, int which)
{
  int A1 = (rand() & 7) - 4;
  int A2 = (rand() & 7) - 4;
  int A3 = (rand() & 7) - 4;
  int A4 = (rand() & 7) - 4;

  double x = which ? (S->x2 + A1) : (S->x1 + A2);
  double y = which ? (S->y2 + A3) : (S->y1 + A4);

  int ix = I_ROUND(x);
  int iy = I_ROUND(y);

  int id = (iy << 16) + ix;

  if (test_vertices.find(id) != test_vertices.end())
    return test_vertices[id];

  int vert = DM_NumVertexes();

  test_vertices[id] = vert;

  DM_AddVertex(ix, iy);

  return vert;
}


void CSG_TestRegions_Doom(void)
{
  // for debugging only: each region_c becomes a single sector.

  CSG_BSP();

  test_vertices.clear();

  unsigned int i, k;

  int line_id = 0;


  for (i = 0 ; i < all_regions.size() ; i++)
  {
    region_c *R = all_regions[i];

    const char *flat = "FWATER1";

    if (R->brushes.size() > 0)
    {
      csg_brush_c *B = R->brushes[0];

      flat = B->t.face.getStr("tex", "FLAT10");
    }
 
    int sec_id = DM_NumSectors();

    DM_AddSector(0,flat, 144,flat, (int)R->brushes.size(),0,(int)R->snags.size());

    DM_AddSidedef(sec_id, "-", "-", "-", 0, 0);

    for (k = 0 ; k < R->snags.size() ; k++)
    {
      snag_c *S = R->snags[k];

if (line_id == 7322)
{
fprintf(stderr, "LINE #%d  SNAG %p  REGION %p / %p  (%s)\n", line_id, S, S->where, R, S->mini ? "MINI" : "normal");

fprintf(stderr, "  coords: (%1.0f %1.0f) --> (%1.0f %1.0f)\n",
        S->x1, S->y1, S->x2, S->y2);

fprintf(stderr, "  on_node %p  (%1.0f %1.0f) --> (%1.0f %1.0f)\n", S->on_node,
  S->on_node ? S->on_node->x1 : 0, S->on_node ? S->on_node->y1 : 0,
  S->on_node ? S->on_node->x2 : 0, S->on_node ? S->on_node->y2 : 0);

fprintf(stderr, "  q_alongs: %d %d\n", S->q_along1, S->q_along2);
}


      DM_AddLinedef(TestVertex(S, 0), TestVertex(S, 1),
                    sec_id, -1,
                    S->partner ? 1 : 0, 1 /*impassible*/, 0,
                    NULL /* args */);
      line_id++;
    }
  }
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
