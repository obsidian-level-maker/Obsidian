//------------------------------------------------------------------------
//  2.5D CSG : LOCAL DEFS
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

#ifndef __OBLIGE_CSG_LOCAL_H__
#define __OBLIGE_CSG_LOCAL_H__


/***** CLASSES ****************/

class partition_c;
class region_c;


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
  snag_c(const snag_c& other);

public:
  snag_c(brush_vert_c *side, double _x1, double _y1, double _x2, double _y2);

  snag_c(double _x1, double _y1, double _x2, double _y2, partition_c *part);

  ~snag_c();

  double Length() const;

  snag_c * Cut(double ix, double iy);

  void CalcAlongs();
};


class region_c
{
public:
  std::vector<snag_c *> snags;

  std::vector<csg_brush_c *> brushes;

  std::vector<entity_info_c *> entities;

  // regions with same brushes will have same equiv_id
  // (only valid AFTER CSG_SimpleCoalesce)
  int equiv_id;

public:
  region_c();

  region_c(const region_c& other);

  ~region_c();

  void AddSnag(snag_c *S);
  bool HasSnag(snag_c *S) const;
  bool RemoveSnag(snag_c *S);

  void AddBrush(csg_brush_c *P);

  int TestSide(partition_c *P);

  void MergeOther(region_c *other);

  void GetBounds(double *x1, double *y1, double *x2, double *y2);
  void GetMidPoint(double *mid_x, double *mid_y);

  void SortBrushes();

  bool HasSameBrushes(const region_c *other) const;

  void ClockwiseSnags();
};


/***** VARIABLES ****************/

extern std::vector<region_c *> all_regions;


/***** FUNCTIONS ****************/

void CSG_BSP(double grid);
void CSG_SimpleCoalesce();


#endif /* __OBLIGE_CSG_LOCAL_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
