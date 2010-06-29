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


class region_c;


class snag_c
{
public:
  double x1, y1;
  double x2, y2;

  region_c *front;

  snag_c *partner;

  std::vector<brush_vert_c *> sides;

public:
  // side = 0 for outside of brush, 1 for inside
  snag_c(csg_brush_C *P, int side, brush_vert_c *start, brush_vert_c *end) :
      x1(start->x), y1(start->y), x2(end->x), y2(end->y),
      front(NULL), partner(NULL), sides()
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

  ~snag_c()
  { }
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


static void DivideOneSnag(snag_c *S, partition_c *party,
                          region_c *back, region_c *front)
{
  // TODO !!
}


static void DivideSnags(region_c *R, partition_c *party)
{
  for (int i = 0; i < (int)R->snags.size(); i++)
  {
    DivideOneSnag(R->snags[i], party, R->back, R->front);
  }

  R->snags.clear();
}


static void AddMiniSnags(...)
{
  // TODO !!
}


static partition_c * ChoosePartition(region_c *R)
{
  if (R->snags.empty())
    return NULL;

  // FIXME: ChoosePartition

  return R->snags[0];
}


static void Split(region_c *R)
{
  partition_c *party = ChoosePartition(R);

  if (! party)
    return;

  R->back  = new region_c();
  R->front = new region_c();

  DivideSnags(R, party);

  int cut_list;  // TODO

  AddMiniSnags(cut_list, party, R->back, R->front);

  Split(R->back); 
  Split(R->front); 
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
