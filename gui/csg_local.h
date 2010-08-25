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


#define SNAG_EPSILON  0.001


/***** CLASSES ****************/

class partition_c;
class region_c;
class gap_c;


class snag_c
{
public:
  double x1, y1;
  double x2, y2;

  bool mini;

  partition_c * on_node;

  region_c *region;  // only valid AFTER MergeRegions()

  snag_c *partner;  // only valid AFTER HandleOverlaps()

  std::vector<brush_vert_c *> sides;

  // quantized along values, used for overlap detection
  int q_along1;
  int q_along2;

  // used by CSG DOOM code
  bool seen;

private:
  snag_c(const snag_c& other);

public:
  snag_c(brush_vert_c *side, double _x1, double _y1, double _x2, double _y2);

  snag_c(double _x1, double _y1, double _x2, double _y2, partition_c *part);

  ~snag_c();

  double Length() const;

  snag_c * Cut(double ix, double iy);

  void CalcAlongs();

  // this is for the MiniMap code, returns true if brushes are the same
  // on both sides.  CSG_SortBrushes() must have been called already.
  bool SameSides() const;

  void TransferSides(snag_c *other);

  // brush side finding functions, return NULL if not found
  brush_vert_c * FindOneSidedVert(double z);
  brush_vert_c * FindBrushVert(const csg_brush_c *B);
};


class region_c
{
public:
  std::vector<snag_c *> snags;

  std::vector<csg_brush_c *> brushes;

  std::vector<csg_entity_c *> entities;

  std::vector<gap_c *> gaps;

  csg_brush_c *liquid;

  // used by DOOM and QUAKE Clipping (etc)
  int index;

public:
  region_c();

  region_c(const region_c& other);

  ~region_c();

  void AddSnag(snag_c *S);
  bool HasSnag(snag_c *S) const;
  bool RemoveSnag(snag_c *S);

  void AddBrush(csg_brush_c *P);
  void RemoveBrush(int index);

  void AddGap(gap_c *G);
  void RemoveGap(int index);

  int TestSide(partition_c *P);

  void MergeOther(region_c *other);

  void GetBounds(double *x1, double *y1, double *x2, double *y2);
  void GetMidPoint(double *mid_x, double *mid_y);

  void SortBrushes();

  // this requires CSG_SortBrushes() to have been called earlier
  bool HasSameBrushes(const region_c *other) const;

  void ClockwiseSnags();
};


class gap_c
{
public:
  csg_brush_c *bottom;
  csg_brush_c *top;

  bool reachable;

  std::vector<gap_c *> neighbors;

public:
  gap_c(csg_brush_c *B, csg_brush_c *T);

  ~gap_c();

  void AddNeighbor(gap_c *N);
  bool HasNeighbor(gap_c *N) const;
};


/***** VARIABLES ****************/

extern std::vector<region_c *> all_regions;


/***** FUNCTIONS ****************/

void CSG_BSP(double grid, bool is_clip_hull = false);


#endif /* __OBLIGE_CSG_LOCAL_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
