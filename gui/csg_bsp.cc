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


class seg_1S_c
{
public:
  merge_segment_c *seg;

  int side;

public:
  // TODO
};


class csg_seg_group_c
{
public:
  csg_seg_group_c *left;
  csg_seg_group_c *right;

  std::vector<seg_1S_c> segs;

public:
  // TODO
};


#define partition_c  merge_segment_c



static void DivideOneSeg(...)
{
  // TODO !!
}


static void DivideSegs(csg_seg_group_c *node, partition_c *party)
{
  for (int i = 0; i < (int)node->segs.size(); i++)
  {
    DivideOneSeg(node->segs[i], party, node->left, node->right);
  }

  node->segs.clear();
}


static void AddMiniSegs(...)
{
  // TODO !!
}


static partition_c * ChoosePartition(csg_seg_group_c *node)
{
  if (node->segs.empty())
    return NULL;

  // TODO !!
}


static void Split(csg_seg_group_c *node)
{
  partition_c *party = ChoosePartition(node);

  if (! party)
    return;

  node->left  = new csg_seg_group_c();
  node->right = new csg_seg_group_c();

  DivideSegs(node, party);

  int cut_list;  // TODO

  AddMiniSegs(cut_list, party, node->left, node->right);

  Split(node->left); 
  Split(node->right); 
}


void CSG_BSP()
{
  // Setup()

  csg_seg_group_c *root = CreateSegGroup();

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
