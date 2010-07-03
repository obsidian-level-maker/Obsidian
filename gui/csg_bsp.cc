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


#define SNAG_EPSILON  1e-4


class region_c;


class snag_c
{
public:
  double x1, y1;
  double x2, y2;

  bool on_node;

  snag_c *partner;  // NULL if not a mini snag

  region_c *where;

  std::vector<brush_vert_c *> sides;

private:
  snag_c(const snag_c& other) :
      x1(other.x1), y1(other.y1), x2(other.x2), y2(other.y2),
      on_node(other.on_node), partner(NULL), 
      where(other.where), sides()
  {
    // copy sides
    for (unsigned int i = 0 ; i < other.sides.size() ; i++)
      sides.push_back(other.sides[i]);
  }

public:
  snag_c(brush_vert_c *start, brush_vert_c *end, brush_vert_c *side) :
      x1(start->x), y1(start->y), x2(end->x), y2(end->y),
      on_node(false), partner(NULL), where(NULL), sides()
  {
    if (Length() < SNAG_EPSILON)
      Main_FatalError("Line loop contains zero-length line! (%1.2f %1.2f)\n", x1, y1);

    sides.push_back(side);
  }

  snag_c(double _x1, double _y1, double _x2, double _y2) :
      x1(_x1), y1(_y1), x2(_x2), y2(_y2),
      on_node(true), where(NULL), partner(NULL), sides()
  { }

  ~snag_c()
  { }

  double Length() const
  {
    return ComputeDist(x1,y1, x2,y2);
  }

  snag_c * Cut(double ix, double iy);
};

#define partition_c  snag_c


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

    S->where = this;
  }

  bool WhatSide(partition_c *P) const;

  void Split(partition_c *P);
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


snag_c * snag_c::Cut(double ix, double iy)
{
  snag_c *T = new snag_c(*this);

  x2 = ix; T->x1 = ix;
  y2 = iy; T->y1 = iy;

  if (partner)
  {
    snag_c *SP = partner;
    snag_c *TP = new snag_c(*partner);

    SP->x1 = ix; TP->x2 = ix;
    SP->y1 = iy; TP->y2 = iy;

    SYS_ASSERT(SP->partner == this);

     T->partner = TP;
    TP->partner = T;

    SYS_ASSERT(T->where);

    where->AddSnag(TP);
  }

  return T;
}


static bool do_clip_brushes;


//------------------------------------------------------------------------

bool region_c::WhatSide(partition_c *P) const
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

    if (a_side < 0 || b_side < 0) has_back  = true;
    if (a_side > 0 || b_side > 0) has_front = true;

    if (has_back && has_front)
      return 0;
  }

  return has_back ? -1 : +1;
}


void region_c::Split(double x1, double y1, double x2, double y2)
{
  region_c *N = new region_c(this);

  snag_c *front_snag = new snag_c(x1,y1, x2,y2);
  snag_c * back_snag = new snag_c(x2,y2, x1,y1);

  front_snag->partner =  back_snag;
   back_snag->partner = front_snag;
 
  ...
}


void region_c::AddIntersection(partition_c *P)
{
  double along_min =  9e9;
  double along_max = -9e9;

  for (unsigned int i = 0 ; i < snags.size() ; i++)
  {
    snag_c *S = snags[i];
    
    double a = PerpDist(S->x1,S->y1, part->x1,part->y1, part->x2,part->y2);
    double b = PerpDist(S->x2,S->y2, part->x1,part->y1, part->x2,part->y2);

    int a_side = (a < -SNAG_EPSILON) ? -1 : (a > SNAG_EPSILON) ? +1 : 0;
    int b_side = (b < -SNAG_EPSILON) ? -1 : (b > SNAG_EPSILON) ? +1 : 0;

    if (a_side == b_side)
      continue;

    double ix, iy;

    CalcIntersection(S->x1, S->y1, S->x2, S->y2,
                     part->x1, part->y1, part->x2, part->y2,
                     &ix, &iy);

    double along = AlongDist(ix, iy, part->x1, part->y1, part->x2, part->y2);

    along_min = MIN(along_min, along);
    along_max = MAX(along_max, along);
  }

  // should NOT get here unless region was splittable
  SYS_ASSERT(along_max > along_min + SNAG_EPSILON);

  {
    double x1, y1;
    double x2, y2;

    AlongCoord(along_min, part->x1,part->y1, part->x2,part->y2, &x1, &y1);
    AlongCoord(along_max, part->x1,part->y1, part->x2,part->y2, &x2, &y2);

    Split(x1, y1, x2, y2);
  }
}


static void CreateRegion(group_c *G, csg_brush_c *P)
{
  SYS_ASSERT(P);

  if (! do_clip_brushes && P->bkind == BKIND_Clip)
    return;

  region_c *R = new region_c();

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


static void DivideOneSnag(region_c *R, partition_c *part,
                            group_c *front, group_c *back)
{
	// get relationship of lines to each other
	double a = PerpDist(S->x1,S->y1, part->x1,part->y1,part->x2,part->y2);
	double b = PerpDist(S->x2,S->y2, part->x1,part->y1,part->x2,part->y2);

	int a_side = (a < -SNAG_EPSILON) ? -1 : (a > SNAG_EPSILON) ? +1 : 0;
	int b_side = (b < -SNAG_EPSILON) ? -1 : (b > SNAG_EPSILON) ? +1 : 0;

  // adjust vertices which sit "nearly" on the line
  if (a_side == 0) MoveOntoLine(part, &S->x1, &S->y1);
  if (b_side == 0) MoveOntoLine(part, &S->x2, &S->y2);

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
                            group_c *front, group_c *back)
{
  // FIXME: mark snags as "on_node"

  int side = R->WhatSide(part);

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

  // region needs to be split

    region_c *RB = R->Split(part);

    front->regions.push_back(R);
     back->regions.push_back(RB);
  }
}




static void DivideGroup(group_c *G, partition_c *part)
{
  G->front = new group_c();
  G->back  = new group_c();

  for (unsigned int i = 0 ; i < G->regions.size() ; i++)
  {
    region_c *R = G->regions[i];

    DivideOneRegion(R, part, G->front, G->back);
  }

  G->regions.clear();
}


static void AddMiniSnags(region_c *R, partition_c *part)
{
  // this adds four "mini-snags" along the partition, with a very
  // long length.  Half is before the partition (on the line) and half
  // is after it.  Eventually they will get divided up and/or merged
  // with any overlapping snags, and the stray bits will get trimmed.

  double len = ComputeDist(part->x1, part->y1, part->x2, part->y2);

  double dx = (part->x2 - part->x1) / len;
  double dy = (part->y2 - part->y1) / len;

  // before...
  double x1 = part->x1 - dx * 64000;
  double y1 = part->y1 - dy * 64000;

  snag_c *F1 = new snag_c(x1, y1, part->x1, part->y1); 
  snag_c *B1 = new snag_c(part->x1, part->y1, x1, y1); 

  F1->partner = B1;
  B1->partner = F1;

  R->AddSnag(F1);
  R->AddSnag(B1);

  // after...
  double x2 = part->x2 + dx * 64000;
  double y2 = part->y2 + dy * 64000;

  snag_c *F2 = new snag_c(part->x2, part->y2, x2, y2); 
  snag_c *B2 = new snag_c(x2, y2, part->x2, part->y2); 

  F2->partner = B2;
  B2->partner = F2;

  R->AddSnag(F2);
  R->AddSnag(B2);
}


static partition_c * ChoosePartition(group_c *G)
{
  // FIXME !!! do seed-wise binary subdivision thang

  partition_c *best = NULL;

  for (unsigned int i = 0 ; i < G->regions.size() ; i++)
  for (unsigned int k = 0 ; k < R->snags.size()   ; k++)
  {
    partition_c *part = G->regions[i]->snags[k];

    if (! part->on_node)
    {
      // FIXME !!!! choose properly
      if (! best)
        best = part;
    }
  }

  return best;
}


static void TestOverlap(region_c *R, snag_c *A, snag_c *B)
{
  // The BSP partitioning has taken care of splitting snags which
  // cross over each other.  Hence all this function needs to do
  // is handle the "on same line" cases.

  // ensure A is shorter than B
  if (A->Length() > B->Length())
  {
    std::swap(A, B);
  }
  
  double p1 = PerpDist(A->x1,A->y1, B->x1,B->y1, B->x2,B->y2);
  double p2 = PerpDist(A->x2,A->y2, B->x1,B->y1, B->x2,B->y2);

	int side1 = (p1 < -SNAG_EPSILON) ? -1 : (p1 > SNAG_EPSILON) ? +1 : 0;
	int side2 = (p2 < -SNAG_EPSILON) ? -1 : (p2 > SNAG_EPSILON) ? +1 : 0;

  if (! (side1 == 0 and side2 == 0))
    return;

  // FIXME: overlap stuff....
}


static void HandleOverlaps(region_c *R)
{
  // Note that new snags may get added (due to splits) while we are
  // iterating over them.

  for (int i = 0   ; i < (int)R->snags.size() ; i++)
  for (int k = i+1 ; k < (int)R->snags.size() ; k++)
  {
    TestOverlap(R, R->snags[i], R->snags[k]);
  }
}



static void Split(group_c *G)
{
  partition_c *part = ChoosePartition(G);

  if (part)
  {
    DivideGroup(G, part);

    Split(G->back); 
    Split(G->front); 
  }

  HandleOverlaps(R);

  // all_regions.push_back(R);
}


void CSG_BSP()
{
  group_c *root = new group_c();

  for (unsigned int i=0; i < all_brushes.size(); i++)
  {
    CreateRegion(root,all_brushes[i]);
  }

  Split(root);
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
