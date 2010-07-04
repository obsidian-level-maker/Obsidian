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

#define partition_c  snag_c


class region_c;


class snag_c
{
public:
  double x1, y1;
  double x2, y2;

  bool mini;
  bool on_node;

  snag_c *partner;  // NULL if not a mini snag

  std::vector<brush_vert_c *> sides;

  // quantized along values, used for overlap detection
  int q_along1;
  int q_along2;

private:
  snag_c(const snag_c& other) :
      x1(other.x1), y1(other.y1), x2(other.x2), y2(other.y2),
      mini(other.mini), on_node(other.on_node),
      partner(NULL), /// where(other.where),
      sides()
  {
    // copy sides
    for (unsigned int i = 0 ; i < other.sides.size() ; i++)
      sides.push_back(other.sides[i]);
  }

public:
  snag_c(brush_vert_c *start, brush_vert_c *end, brush_vert_c *side) :
      x1(start->x), y1(start->y), x2(end->x), y2(end->y),
      mini(false), on_node(false), partner(NULL), /// where(NULL),
      sides()
  {
    if (Length() < SNAG_EPSILON)
      Main_FatalError("Line loop contains zero-length line! (%1.2f %1.2f)\n", x1, y1);

    sides.push_back(side);
  }

  snag_c(double _x1, double _y1, double _x2, double _y2) :
      x1(_x1), y1(_y1), x2(_x2), y2(_y2),
      mini(true), on_node(true), partner(NULL), /// where(NULL),
      sides()
  { }

  ~snag_c()
  { }

  double Length() const
  {
    return ComputeDist(x1,y1, x2,y2);
  }

  void Cut(double ix, double iy, snag_c **S2, snag_c **T2);

  void CalcAlongs(partition_c *part)
  {
    double a1 = AlongDist(x1, y1, part->x1,part->y1, part->x2,part->y2);
    double a2 = AlongDist(x2, y2, part->x1,part->y1, part->x2,part->y2);

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

///---  S->where = this;
  }

  bool HasSnag(snag_c *S) const
  {
    for (unsigned int i = 0 ; i < snags.size() ; i++)
      if (snags[i] == S)
        return true;

    return false;
  }

  bool TestSide(partition_c *P);

};


class group_c
{
public:
  std::vector<region_c *> regions;

  // for BSP stuff
  group_c *front;
  group_c *back;

public:
  group_c() : regions(), front(NULL), back(NULL)
  { }

  ~group_c()
  { }

  void AddRegion(region_c *R)
  {
    regions.push_back(R);
  }
};


static bool PartnerSnags(snag_c *A, snag_c *B)
{
  A->partner = B;
  B->partner = A;
}


void snag_c::Cut(double ix, double iy, snag_c **S2, snag_c **T2)
{
  *S2 = new snag_c(*this);
  *T2 = NULL;

  x2 = ix; (*S2)->x1 = ix;
  y2 = iy; (*S2)->y1 = iy;

  if (partner)
  {
    snag_c *T1 = partner;

    SYS_ASSERT(T1->partner == this);

    *T2 = new snag_c(*T1);

    T1->x1 = ix; (*T2)->x2 = ix;
    T2->y1 = iy; (*T2)->y2 = iy;

    PartnerSnags(T1, *T2);
  }
}


static bool do_clip_brushes;

static std::vector<snag_c *> overlap_list;

// first region is always a dummy
static std::vector<region_c *> all_regions;



//------------------------------------------------------------------------

static void CreateRegion(group_c *G, csg_brush_c *P)
{
  SYS_ASSERT(P);

  if (! do_clip_brushes && P->bkind == BKIND_Clip)
    return;

  region_c *R = new region_c;

  all_regions.push_back(R);

  // NOTE: brush sides go ANTI-clockwise, region snags go CLOCKWISE,
  //       hence we need to flip them here.

  int total = (int)P->verts.size();

  for (int k = total-1 ; k >= 0 ; k--)
  {
    int k2 = (k + total - 1) % total;

    brush_vert_c *v1 = P->verts[k];
    brush_vert_c *v2 = P->verts[k2];

    snag_c *S = new snag_c(v1, v2, v2);

    R->AddSnag(S);
  }

  G->AddRegion(R);
}


static void MoveOntoLine(partition_c *part, double *x, double *y)
{
  double along = AlongDist(*x, *y, part->x1,part->y1, part->x2,part->y2);

  AlongCoord(along, part->x1,part->y1, part->x2,part->y2, x, y);
}


bool region_c::TestSide(partition_c *part)
{
  bool has_back  = false;
  bool has_front = false;

  for (unsigned int i = 0 ; i < snags.size() ; i++)
  {
    snag_c *S = snags[i];
    
    double a = PerpDist(S->x1,S->y1, part->x1,part->y1, part->x2,part->y2);
    double b = PerpDist(S->x2,S->y2, part->x1,part->y1, part->x2,part->y2);

    int a_side = (a < -SNAG_EPSILON) ? -1 : (a > SNAG_EPSILON) ? +1 : 0;
    int b_side = (b < -SNAG_EPSILON) ? -1 : (b > SNAG_EPSILON) ? +1 : 0;

    if (a_side == 0 && b_side == 0)
    {
      S->on_node = true;
      overlap_list.push_back(S);
    }

    if (a_side < 0 || b_side < 0) has_back  = true;
    if (a_side > 0 || b_side > 0) has_front = true;

    // adjust vertices which sit "nearly" on the line
    if (a_side == 0) MoveOntoLine(part, &S->x1, &S->y1);
    if (b_side == 0) MoveOntoLine(part, &S->x2, &S->y2);
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
  SYS_ASSERT(! (a_side == 0 && b_side == 0));

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

#if 0
	// on the same line?
	if (a_side == 0 && b_side == 0)
	{
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
	}
#endif

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

  snag_c *S2;
  snag_c *T2;

  S->Cut(ix, iy, &S2, &T2);

  S->x2 = ix; T->x1 = ix;
  S->y2 = iy; T->y1 = iy;

	if (a_side < 0)
	{
     back->AddSnag(S);
    front->AddSnag(S2);
	}
	else
	{
    front->AddSnag(S);
     back->AddSnag(S2);
	}

  if (T2) SHIT.
}


static void DivideOneRegion(region_c *R, partition_c *part,
                            group_c *front, group_c *back)
{
  int side = R->TestSide(part);

  if (side > 0)
  {
    front->regions.push_back(R);
    return;
  }
  else if (side < 0)
  {
    back->regions.push_back(R);
    return;
  }

  // --- region needs to be split ---

  region_c *N = new region_c(*R);

  all_regions.push_back(N);

  // iterate over a swapped-out version of the region's snags
  // (so we can safely add certain ones into R->snags)
  region_c *dummy = all_regions[0]l

  std::swap(R->snags, dummy->snags);

  // compute intersection points
  double along_min =  9e9;
  double along_max = -9e9;

  for (unsigned int i = 0 ; i < dummy->snags.size() ; i++)
  {
    snag_c *S = dummy->snags[i];
    dummy->snags[i] = NULL;

    DivideOneSnag(S, part, R, N, &along_min, &along_max);
  }

  dummy->snags.clear();

  front->regions.push_back(R);
   back->regions.push_back(N);

  // --- add the mini snags ---

  SYS_ASSERT(along_max > along_min + SNAG_EPSILON);

  {
    double x1, y1;
    double x2, y2;

    AlongCoord(along_min, part->x1,part->y1, part->x2,part->y2, &x1, &y1);
    AlongCoord(along_max, part->x1,part->y1, part->x2,part->y2, &x2, &y2);

    snag_c *front_snag = new snag_c(x1,y1, x2,y2);
    snag_c * back_snag = new snag_c(x2,y2, x1,y1);

    PartnerSnags(front_snag, back_snag);

    R->snags.push_back(front_snag);
    N->snags.push_back(back_snag);

    overlap_list.push_back(front_snag);
    overlap_list.push_back(back_snag);
  }
}


static void DivideGroup(group_c *G, partition_c *part)
{
  G->front = new group_c;
  G->back  = new group_c;

  for (unsigned int i = 0 ; i < G->regions.size() ; i++)
  {
    region_c *R = G->regions[i];

    DivideOneRegion(R, part, G->front, G->back);
  }

  G->regions.clear();
}


static partition_c * ChoosePartition(group_c *G)
{
  // FIXME !!! do seed-wise binary subdivision thang

  partition_c *best = NULL;

  for (unsigned int i = 0 ; i < G->regions.size() ; i++)
  {
    region_c *R = G->regions[i];

    for (unsigned int k = 0 ; k < R->snags.size()   ; k++)
    {
      partition_c *part = G->regions[i]->snags[k];

      if (! part->on_node)
      {
        // FIXME !!!! choose properly
        //            (prefer horizontal/vertical which splits bbox well)
        if (! best)
          best = part;
      }
    }
  }

  return best;
}


static bool SplitSnag(snag_c *S, double ix, double iy, partition_c *part)
{
  snag_c *T = new snag_c(*S);

  

  S->where->AddSnag(T);

  overlap_list.push_back(T);

  S->CalcAlongs(part);
  T->CalcAlongs(part);

  return true;
}


static bool MergeSnags(snag_c *A, snag_c *B)
{
  // TODO: a better way!

  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c *R = all_regions[i];

    for (unsigned int k = 0 ; k < R->snags.size() ; k++)
    {
      if (R->snags[k] == B)
          R->snags[k] = A;
    }
  }

  // TODO: delete B  (or similar)
}


static bool TestOverlap(partition_c *part, std::vector<snag_c *> & list,
                        int i, int k)
{
  snag_c *A = list[i];
  snag_c *B = list[k];

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
    return SplitSnag(A, B->x1, B->y1, part, list);

  if (B->q_along2 > a_min && B->q_along2 < a_max)
    return SplitSnag(A, B->x2, B->y2, part, list);

  if (A->q_along1 > b_min && A->q_along1 < b_max)
    return SplitSnag(B, A->x1, A->y1, part, list);

  if (A->q_along2 > b_min && A->q_along2 < b_max)
    return SplitSnag(B, A->x2, A->y2, part, list);

  // to get here, the snags must be directly overlapping.
  // MERGE TIME!

  SYS_ASSERT(a_min == b_min);
  SYS_ASSERT(a_max == b_max);

  // same direction?
  if (A->q_along1 == B->q_along1)
  {
    MergeSnags(A, B);

    list[k] = NULL;  // remove B from the list

    return true;
  }

  PartnerSnags(A, B);
  return false;
}


static void HandleOverlaps(partition_c *part)
{
  for (unsigned int i = 0 ; i < overlap_list.size() ; i++)
    overlap_list[i]->CalcAlongs();

  // FIXME: sort list by MIN(q_along), take advantage of that

  int changes;

  do
  {
    changes = 0;

    // Note that new snags may get added (due to splits) while we are
    // iterating over them.  Removed snags become NULL in the list.

    for (int i = 0   ; i < (int)overlap_list.size() ; i++)
    for (int k = i+1 ; k < (int)overlap_list.size() ; k++)
    {
      snag_c *A = overlap_list[i];
      snag_c *B = overlap_list[k];

      if (! A || ! B)
        continue;

      if (TestOverlap(part, overlap_list, i, k))
        changes++;
    }

    fprintf(stderr, "  HandleOverlaps: %d changes\n", changes);

  } while (changes > 0);
}


static void Split(group_c *G)
{
  partition_c *part = ChoosePartition(G);

  if (part)
  {
    fprintf(stderr, "Partition: (%1.2f %1.2f) --> (%1.2f %1.2f)\n",
            part->x1, part->y1, part->x2, part->y2);

    overlap_list.clear();

    DivideGroup(G, part);

    HandleOverlaps(part);

    // recursively handle each side
    Split(G->back); 
    Split(G->front); 
  }
}


void CSG_BSP()
{
  all_regions.clear();

  all_regions.push_back(new region_c);

  group_c *root = new group_c;

  for (unsigned int i=0; i < all_brushes.size(); i++)
  {
    CreateRegion(root,all_brushes[i]);
  }

  Split(root);

  // FIXME: free stuff
}


//------------------------------------------------------------------------

void CSG_Quantize()
{
}


//------------------------------------------------------------------------

void CSG_Merge()
{
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
