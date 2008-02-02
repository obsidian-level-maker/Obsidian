//------------------------------------------------------------------------
//  2.5D Constructive Solid Geometry
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

#ifndef __OBLIGE_CSG_POLY_H__
#define __OBLIGE_CSG_POLY_H__

#define EPSILON  0.005

#define ANGLE_EPSILON  0.0003


// unset values (handy sometimes)
#define IVAL_NONE  -27777
#define FVAL_NONE  -27777.75f


/* ----- CLASSES ----- */

class merge_vertex_c;
class merge_segment_c;
class merge_region_c;


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

  int t_light, b_light;

  int sec_kind, sec_tag;
  int mark;

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

  area_side_c side;

  int line_kind;
  int line_tag;
  int line_flags;

  byte line_args[5];

  merge_vertex_c *partner;

public:
   area_vert_c();
  ~area_vert_c();
};


class area_poly_c
{
  // This represents a "brush" in Quake terms, a solid area
  // on the map with out-facing sides and top/bottom.
  // Unlike quake brushes, area_polys don't have to be convex
  // (FIXME: actually must be convex when output is .map format).

public:
  area_info_c *info;

  std::vector<area_vert_c *> verts;

  double min_x, min_y;
  double max_x, max_y;

///---  std::vector<merge_region_c *> regions;

public:
   area_poly_c(area_info_c *_info);
  ~area_poly_c();

  void ComputeBBox();
};


class entity_info_c
{
public:
  std::string name;

  double x, y, z;

public:
   entity_info_c(const char *_name, double xpos, double ypos, double zpos);
  ~entity_info_c();
};


//------------------------------------------------------------------------


class merge_vertex_c
{
public:
  double x, y;

  // list of segments that touch this vertex
  std::vector<merge_segment_c *> segs;

  // this index is not used by the polygoniser code (csg_poly.cc),
  // only by the Doom conversion code.  -1 means "unused".
  int index;
  
public:
  merge_vertex_c() : x(0), y(0), segs(), index(-1)
  { }

  merge_vertex_c(double _xx, double _yy) : x(_xx), y(_yy), segs(), index(-1)
  { }

  ~merge_vertex_c()
  { }

  inline bool Match(double _xx, double _yy) const
  {
    return (fabs(_xx - x) <= EPSILON) &&
           (fabs(_yy - y) <= EPSILON);
  }
    
  inline bool Match(const merge_vertex_c *other) const
  {
    return (fabs(other->x - x) <= EPSILON) &&
           (fabs(other->y - y) <= EPSILON);
  }
    
  void AddSeg(merge_segment_c *seg);

  void RemoveSeg(merge_segment_c *seg);

  void ReplaceSeg(merge_segment_c *old_seg, merge_segment_c *new_seg);
};


class merge_segment_c
{
  // This is a just a line on the 2D map.

public:
  merge_vertex_c *start;
  merge_vertex_c *end;

  merge_region_c *front;
  merge_region_c *back;

  // temporary value that is only used by Mug_AssignAreas(),
  // and refers to the current area_poly_c if this segment lies
  // along it's border (just an efficient boolean test).
  area_poly_c *border_of;

  // this index is not used by the polygoniser code (csg_poly.cc),
  // only by the Doom conversion code.  -1 means "unused".
  int index;

public:
  merge_segment_c(merge_vertex_c *_v1, merge_vertex_c *_v2) :
      start(_v1), end(_v2), front(NULL), back(NULL), border_of(NULL), index(-1)
  { }

  ~merge_segment_c()
  { }

  inline bool Match(merge_vertex_c *_v1, merge_vertex_c *_v2) const
  {
    return (_v1 == start && _v2 == end) ||
           (_v2 == start && _v1 == end);
  }

  inline bool Match(const merge_segment_c *other) const
  {
    return (other->start == start && other->end   == end) ||
           (other->end   == start && other->start == end);
  }

  inline merge_vertex_c *Other(const merge_vertex_c *v) const
  {
    if (v == start)
      return end;

    SYS_ASSERT(v == end);
    return start;
  }

  void Kill(void);
  void Flip(void);
};


class merge_gap_c
{
public:
  merge_region_c *parent;

  area_poly_c *bottom;
  area_poly_c *top;

  std::vector<merge_gap_c *> neighbours;

  std::vector<entity_info_c *> entities;

  bool reachable;

public:
  merge_gap_c(merge_region_c *R, area_poly_c *B, area_poly_c *T) :
      parent(R), bottom(B), top(T),
      neighbours(), entities(), reachable(false)
  { }

  ~merge_gap_c()
  { }
};


class merge_region_c
{
  // This represents an a region on the 2D map, bounded by a set
  // of segments (not explicitly stored here, but implicit in the
  // merge_segment_c::front and back fields).  Each region lists
  // all the area_polys ("brushes") contained, as well as the gaps
  // (spaces between brushes where objects can go).

public:
  bool faces_out;

  std::vector<area_poly_c *> areas;

  std::vector<merge_gap_c *> gaps;

  // this index is not used by the polygoniser code (csg_poly.cc),
  // only by the Doom conversion code.  -1 means "unused".
  int index;

public:
  merge_region_c() : faces_out(false), areas(), gaps(), index(-1)
  { }

  ~merge_region_c()
  { }
};


/* ----- VARIABLES ----- */

extern std::vector<area_info_c *> all_areas;
extern std::vector<area_poly_c *> all_polys;

extern std::vector<entity_info_c *> all_entities;

extern std::vector<merge_vertex_c *>  mug_vertices;
extern std::vector<merge_segment_c *> mug_segments;
extern std::vector<merge_region_c *>  mug_regions;
extern std::vector<merge_gap_c *>     mug_gaps;


/* ----- FUNCTIONS ----- */

void CSG2_Init(void);

void CSG2_BeginLevel(void);
void CSG2_EndLevel(void);

void CSG2_MergeAreas(void);

#endif /* __OBLIGE_CSG_POLY_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
