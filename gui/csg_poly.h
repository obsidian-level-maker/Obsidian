//------------------------------------------------------------------------
//  2.5D Constructive Solid Geometry
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006,2007 Andrew Apted
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

#ifndef __OBLIGE_CSG_POLY_H__
#define __OBLIGE_CSG_POLY_H__

#define EPSILON  0.005

#define ANGLE_EPSILON  0.0002


// unset values (handy sometimes)
#define IVAL_NONE  -27777
#define FVAL_NONE  -27777.75f


/* ----- CLASSES ----- */

class merged_area_c;


class slope_points_c
{
public:
  double tz1, tz2;
  double bz1, bz2;

  double x1, y1, x2, y2;

public:
   slope_points_c();
  ~slope_points_c();
};


class area_info_c
{
public:
  int time; // increases for each new solid area

  std::string t_tex;
  std::string b_tex;
  std::string w_tex;  // default

  ///  peg_mode_e  peg;  // default

  /// double y_offset;  // default

  double z1, z2;

  slope_points_c slope;

  int sec_kind, sec_tag;
  int t_light, b_light;

public:
   area_info_c();
  ~area_info_c();
};


class area_side_c
{
public:
  std::string w_tex;
  std::string t_rail;

  /// peg_mode_e peg;
 
  double x_offset;
  double y_offset;

//??  merged_area_c *face;

public:
   area_side_c();
  ~area_side_c();
};


class area_vert_c
{
public:
  double x, y;

  area_side_c front;
  area_side_c back;

  int line_kind;
  int line_tag;
  int line_flags;

  byte line_args[5];

public:
   area_vert_c();
  ~area_vert_c();
};


class area_poly_c
{
public:
  area_info_c *info;

  std::vector<area_vert_c *> verts;

  double min_x, min_y;
  double max_x, max_y;

public:
   area_poly_c(area_info_c *_info);
  ~area_poly_c();

  void ComputeBBox();
};


class merged_area_c
{
public:
  // all polys for this area (sorted by height)
  std::vector<area_poly_c *> polys;

  int sector_index;

public:
   merged_area_c();
  ~merged_area_c();
};


/* ----- VARIABLES ----- */

extern std::vector<area_info_c *> all_areas;
extern std::vector<area_poly_c *> all_polys;

extern std::vector<merged_area_c *> all_merges;


/* ----- FUNCTIONS ----- */

void CSG2_Init(void);

void CSG2_BeginLevel(void);
void CSG2_EndLevel(void);

void CSG2_MergeAreas(void);

#endif /* __OBLIGE_CSG_POLY_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
