//------------------------------------------------------------------------
//  LEVEL : Level structures & read/write functions.
//------------------------------------------------------------------------
//
//  GL-Node Viewer (C) 2004-2007 Andrew Apted
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

#ifndef __NODEVIEW_LEVEL_H__
#define __NODEVIEW_LEVEL_H__

#include <vector>


class node_c;


class side_c
{
public:
  double x1, y1;
  double x2, y2;

  bool miniseg;
  
   side_c();
  ~side_c();
};


class leaf_c
{
public:
  std::vector<side_c *> sides;

  // approximate middle point
  double mid_x;
  double mid_y;

   leaf_c();
  ~leaf_c();

  void CalcMid();
};


typedef struct bbox_s
{
  double minx, miny;
  double maxx, maxy;
}
bbox_t;


class child_c
{
public:
  // child node or subsector (one must be NULL)
  node_c *node;
  leaf_c *leaf;

  // child bounding box  [NOT USED!]
  bbox_t bounds;

   child_c();
  ~child_c();
};


class node_c
{
public:
  const char *name;

  double x1, y1;
  double x2, y2;

  // right & left children  (front and back)
  child_c front;
  child_c back;

   node_c();
  ~node_c();

  void CalcMids();
};


extern node_c * qk_root_node;
extern leaf_c * qk_solid_leaf;


/* ----- function prototypes ----------------------- */

// load all level data for the current level
void LoadLevel(const char *filename);

// free all level data
void FreeLevel(void);

void LevelGetBounds(double *lx, double *ly, double *hx, double *hy);

#endif /* __NODEVIEW_LEVEL_H__ */
