//------------------------------------------------------------------------
//  LEVEL building - QUAKE 1 BSP
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
#include "hdr_ui.h"

#include "lib_file.h"
#include "lib_util.h"

#include "csg_poly.h"
#include "csg_doom.h"
#include "csg_quake.h"

#include "q1_structs.h"

#include "g_glbsp.h"
#include "g_image.h"
#include "g_lua.h"

#include "main.h"


// TODO


class qFace_c
{
public:
  int foo;
 
public:
   qFace_c(  ) { }
  ~qFace_c() { }
};


class qSide_c
{
public:
  merge_segment_c *seg;

  int side;  // 0 is front, 1 is back
 
public:
  qSide_c(merge_segment_c * _seg, int _side) : seg(_seg), side(_side)
  { }

  ~qSide_c()
  { }
};


class qLeaf_c
{
public:
  int contents;

  std::vector<qFace_c *> faces;

  std::list<qSide_c *> sides;

public:
  qLeaf_c() : contents(CONTENTS_EMPTY), faces(), sides()
  { }

  ~qLeaf_c()
  {
    // TODO: delete faces and sides
  }
};


class qNode_c
{
public:
  // ture if this node splits the tree by Z
  // (with a horizontal split plane)
  bool z_splitter;
  
  double z;

  // normal splitting planes are vertical, and here are the
  // coordinates.
  double x1, y1;
  double x2, y2;

  qLeaf_c *front_l;  // one of this is non-NULL
  qNode_c *front_n;

  qLeaf_c *back_l;  // one of this is non-NULL
  qNode_c *back_n;

public:
  qNode_c()
  { }

  ~qNode_c()
  {
    // TODO: delete child nodes & leaves
  }

};


static qNode_c * PartitionXY(qLeaf_c *leaf)
{
  XXX = FindPartition(XXX);

  qNode_c *node = new qNode_c();

  DoSplit(node, leaf);

  if (! node->front_l->ConvexXY())
  {
    node->front_n = PartitionXY(node->front_l);

    // ???  delete node->front_l
    node->front_l = NULL;
  }

  if (! node->back_l->ConvexXY())
  {
    node->back_n = PartitionXY(node->back_l);

    // ???  delete node->back_l
    node->back_l = NULL;
  }
}

static void PartitionZ(qNode_c *node)
{
}


void Quake1_BuildBSP( void )
{
  // INPUTS:
  //   all the stuff created by CSG_MergeAreas
  //
  // OUTPUTS:
  //   a BSP tree consisting of nodes, leaves and faces

  // ALGORITHM:
  //   1. create a qSide list from every segment
  //   2. while list is not yet convex:
  //      (a) find a splitter side --> create qNode
  //      (b) split list into front and back
  //      (c) recursively handle front/back lists
  //   3. perform Z splitting


  qLeaf_c *begin = new qLeaf_c();

  for (unsigned int i = 0; i < mug_segments.size(); i++)
  {
    merge_segment_c *S = mug_segments[i];

    if (S->front)
      begin->AddSide(S, 0);

    if (S->back)
      begin->AddSide(S, 1);
  }


  qNode_c *root = PartitionXY(begin);

  PartitionZ(root);

}



//--- editor settings ---
// vi:ts=2:sw=2:expandtab
