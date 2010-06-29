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


#define SNAG_EPSILON  0.01


class region_c;


class snag_c
{
public:
  double x1, y1;
  double x2, y2;

  bool mini;

  bool on_node;

  region_c *where;

  snag_c *partner;

  std::vector<brush_vert_c *> sides;

private:
  snag_c(const snag_c& other)
      x1(other.x1), y1(other.y1), x2(other.x2), y2(other.y2),
      mini(other.mini), on_node(other.on_node),
      where(other.where), partner(NULL), sides()
  {
    // FIXME: copy sides
  }

public:
  // side = 0 for outside of brush, 1 for inside
  snag_c(csg_brush_C *P, int side, brush_vert_c *start, brush_vert_c *end) :
      x1(start->x), y1(start->y), x2(end->x), y2(end->y),
      mini(false), on_node(false), where(NULL), partner(NULL), sides()
  {
    if (side == 0)
    {
      // FIXME !!!!  add side
    }

  // FIXME check for zero-length lines
//!!!  if (start == end)
//!!!    Main_FatalError("Line loop contains zero-length line! (%1.2f, %1.2f)\n",
//!!!                    start->x, start->y);
  }

  snag_c(double _x1, double _y1, double _x2, double _y2) :
      x1(_x1), y1(_y1), x2(_x2), y2(_y2),
      mini(true), on_node(true), where(NULL), partner(NULL), sides()
  { }

  ~snag_c()
  { }

  snag_c *Cut(double ix, double iy)
  {
    snag_c *T = new snag_c(*this);

    x2 = ix ; T->x1 = ix
    y2 = iy ; T->y1 = iy

    if (partner)
    {
      snag_c *SP = partner;
      snag_c *TP = new snag_c(*partner);

      SP->x1 = ix ; TP->x2 = ix
      SP->y1 = iy ; TP->y2 = iy

      SYS_ASSERT(SP->partner == this);

       T->partner = TP;
      TP->partner = T;

      SYS_ASSERT(T->where);

      where->AddSnag(T2);
    }
  }
};

#define partition_c  snag_c


class region_c
{
public:
  std::vector<snag_c *> snags;

  // for BSP stuff
  region_c *back;
  region_c *front;

public:
  region_c() : snags(), back(NULL), front(NULL)
  { }

  ~region_c()
  { }

  void AddSnag(snag_c *S)
  {
    snags.push_back(S);    

    S->where = this;
  }
};


static bool do_clip_brushes;


//------------------------------------------------------------------------

static void AddSnags(region_c *R, csg_brush_c *P)
{
  SYS_ASSERT(P);

  if (! do_clip_brushes && P->bkind == BKIND_Clip)
    return;

  for (int k=0; k < (int)P->verts.size(); k++)
  {
    brush_vert_c *v1 = P->verts[k];
    brush_vert_c *v2 = P->verts[(k+1) % (int)P->verts.size()];

    snag_c *A = new snag_c(P, 0, v1, v2);
    snag_c *B = new snag_c(P, 1, v2, v1);

    A->partner = B;
    B->partner = A;

    R->AddSnag(A);
    R->AddSnag(B);
  }
}


static region_c * InitialRegion()
{
  region_c *R = new region_c();

  for (unsigned int j=0; j < all_brushes.size(); j++)
  {
    AddSnags(R, all_brushes[j]);
  }

  return R;
}


static void MoveOntoLine(partition_c *part, double *x, double *y)
{
  double len = ComputeDist(part->x1, part->y1, part->x2, part->y2);

  double dx = (part->x2 - part->x1) / len;
  double dy = (part->y2 - part->y1) / len;

  double along = AlongDist(*x, *y, part->x1,part->y1,part->x2,part->y2);

  *x = part->x1 + along * dx;
  *y = part->y1 + along * dy;
}


static void DivideOneSnag(snag_c *S, partition_c *part,
                          region_c *back, region_c *front)
{
	/* get state of lines' relation to each other */
	float a = PerpDist(S->x1,S->y1, part->x1,part->y1,part->x2,part->y2);
	float a = PerpDist(S->x2,S->y2, part->x1,part->y1,part->x2,part->y2);

	int a_side = (a < -SNAG_EPSILON) ? -1 : (a > SNAG_EPSILON) ? +1 : 0;
	int b_side = (b < -SNAG_EPSILON) ? -1 : (b > SNAG_EPSILON) ? +1 : 0;

  /* adjust vertices which sit "nearly" on the line */
  if (a_side == 0) MoveOntoLine(part, &S->x1, &S->y1);
  if (b_side == 0) MoveOntoLine(part, &S->x2, &S->y2);

	/* check for being on the same line */
	if (a_side == 0 && b_side == 0)
	{
		// this snag runs along the same line as the partition.  check
		// whether it goes in the same direction or the opposite.
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

	/* check for right side */
	if (a_side >= 0 && b_side >= 0)
	{
    front->AddSnag(S);
		return;
	}

	/* check for left side */
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


static void DivideSnags(region_c *R, partition_c *part)
{
  // Note that new snags may get added (due to splits) while we are
  // iterating over them.

  for (int i = 0; i < (int)R->snags.size(); i++)
  {
    DivideOneSnag(R->snags[i], part, R->back, R->front);
  }

  R->snags.clear();
}


static void AddMiniSnags(region_c *R, partition_c *part)
{
  // this adds two "mini-snags" along the partition, with a very
  // long length.  Eventually they will get divided up and/or
  // merged with any overlapping snags (partition line included),
  // and the stray bits will get discarded.

  double len = ComputeDist(part->x1, part->y1, part->x2, part->y2);

  double dx = (part->x2 - part->x1) / len;
  double dy = (part->y2 - part->y1) / len;

  double x1 = part->x1 - dx * 64000;
  double y1 = part->y1 - dy * 64000;

  double x2 = part->x1 + dx * 64000;
  double y2 = part->y1 + dy * 64000;

  snag_c *A = new snag_c(x1, y1, x2, y2); 
  snag_c *B = new snag_c(x2, y2, x1, y1); 

  A->partner = B;
  B->partner = A;

  R->AddSnag(A);
  R->AddSnag(B);
}


static partition_c * ChoosePartition(region_c *R)
{
  partition_c *best = NULL;

  for (int i = (int)R->snags.size()-1; i >= 0; i--)
  {
    partition_c *part = R->snags[i];

    if (! part->on_node)
    {
      best = part;
      break;  // FIXME: choose best properly
    }
  }

  return best;
}


static void HandleOverlaps(region_c *R)
{
  // FIXME
}


static void TrimMiniSnags(region_c *R)
{
  // FIXME

  // removes any stray mini-snags, i.e. ones lying outside of the
  // convex polygon formed by the snags in this region.

}


static void ClockwiseOrder(region_c *R)
{
  // FIXME
}


static void Split(region_c *R)
{
  partition_c *part = ChoosePartition(R);

  if (part)
  {
    AddMiniSnags(R, part);

    R->back  = new region_c();
    R->front = new region_c();

    DivideSnags(R, part);

    Split(R->back); 
    Split(R->front); 
  }

  if (R->snags.empty())
    return;

  HandleOverlaps(R);

  TrimMiniSnags(R);

  ClockwiseOrder(R);

  // all_regions.push_back(R);
}


void CSG_BSP()
{
  // Setup()

  region_c *root = InitialRegion();

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
