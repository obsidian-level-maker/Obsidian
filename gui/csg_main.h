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

#ifndef __OBLIGE_CSG_MAIN_H__
#define __OBLIGE_CSG_MAIN_H__

#define EPSILON  0.005

#define ANGLE_EPSILON  0.0003


// unset values (handy sometimes)
#define IVAL_NONE  -27777
#define FVAL_NONE  -27777.75f


/* ----- CLASSES ----- */

class merge_vertex_c;
class merge_segment_c;
class merge_region_c;


class slope_plane_c
{
  // defines the planes used for sloped floors or ceiling.
  // Gives two points in 3D space, from low to high (sz < ez).
  // The plane is not tilted along that line, i.e. the vector
  // at right-angles has constant Z.

public:
  double sx, sy, sz;
  double ex, ey, ez;

public:
   slope_plane_c();
  ~slope_plane_c();

  double GetAngle() const;
};


class area_face_c
{
public:
  std::string tex;

  /// peg_mode_e peg;
 
  double x_offset;
  double y_offset;

public:
   area_face_c();
  ~area_face_c();
};


class area_vert_c
{
public:
  double x, y;

  area_face_c *face; // optional

  int line_kind;
  int line_tag;
  int line_flags;

  byte line_args[5];

  merge_vertex_c *partner;

public:
   area_vert_c(double _x = 0, double _y = 0);
  ~area_vert_c();
};


typedef enum
{
  BRU_F_Liquid   = (1 << 0),
  BRU_F_Detail   = (1 << 1),  // skipped when vis-ing
  BRU_F_NoClip   = (1 << 2),  // objects/shots can pass through

  BRU_F_Close    = (1 << 4),  // (DOOM) close the created sector
  BRU_F_SkyClose = (1 << 5),  // (DOOM) almost close the sector
}
brush_flags_e;


class csg_brush_c
{
  // This represents a "brush" in Quake terms, a solid area
  // on the map with out-facing sides and top/bottom.
  // Unlike quake brushes, these don't have to be convex

public:
  std::vector<area_vert_c *> verts;

  double min_x, min_y;
  double max_x, max_y;

  // AREA INFO
  int bflags;

  area_face_c *b_face;
  area_face_c *t_face;
  area_face_c *side;  // default side face

  // without slopes, z1 and z2 are just the heights of the bottom
  // and top faces.  When slopes are present, they represent the
  // bounding heights of the brush.
  double z1, z2;

  // these are NULL when not sloped
  slope_plane_c *b_slope;
  slope_plane_c *t_slope;

  int sec_kind, sec_tag;
  int mark;

public:
   csg_brush_c();
  ~csg_brush_c();

  // copy constructor
  csg_brush_c(const csg_brush_c *other, bool do_verts = false);

  void ComputeBBox();

  const char * Validate();
  // makes sure there are enough vertices and they are in
  // clockwise order.  Returns NULL if OK, otherwise an
  // error message string.
};


typedef enum
{
  ENT_F_Player    = (1 << 0),
  ENT_F_Monster   = (1 << 1),
  ENT_F_Light     = (1 << 2),
  EMT_F_Temp      = (1 << 3),  // temporary, don't store in the map
}
entity_flags_e;


class entity_info_c
{
public:
  std::string name;

  double x, y, z;

  int eflags;

  std::map<std::string, std::string> props;

public:
   entity_info_c(const char *_name, double xpos, double ypos, double zpos,
                 int _flags = 0);
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
  // and refers to the current csg_brush_c if this segment lies
  // along it's border (just an efficient boolean test).
  csg_brush_c *border_of;

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

  void Kill();
  void Flip();

  bool HasGap() const;
};


class merge_gap_c
{
public:
  merge_region_c *parent;

  csg_brush_c *b_brush;
  csg_brush_c *t_brush;

  std::vector<merge_gap_c *> neighbours;

  std::vector<entity_info_c *> entities;

  bool reachable;

public:
  merge_gap_c(merge_region_c *R, csg_brush_c *B, csg_brush_c *T) :
      parent(R), b_brush(B), t_brush(T),
      neighbours(), entities(), reachable(false)
  { }

  ~merge_gap_c()
  { }

  inline double GetZ1() const
  {
    return b_brush->z2;
  }

  inline double GetZ2() const
  {
    return t_brush->z1;
  }

  inline const char *FloorTex() const
  {
    return b_brush->t_face->tex.c_str();
  }

  inline const char *CeilTex() const
  {
    return t_brush->b_face->tex.c_str();
  }
};


class merge_region_c
{
  // This represents a region on the 2D map, bounded by a group
  // of segments (not explicitly stored here, but implicit in the
  // merge_segment_c::front and back fields).  Each region lists
  // all the brushes contained, as well as the gaps (spaces between
  // brushes where objects can go).

public:
  bool faces_out;

  std::vector<csg_brush_c *> areas;

  std::vector<merge_gap_c *> gaps;

  // this index is not used by the polygoniser code (csg_poly.cc),
  // only by the Doom conversion code.  -1 means "unused".
  int index;

public:
  merge_region_c() : faces_out(false), areas(), gaps(), index(-1)
  { }

  ~merge_region_c()
  { }

  inline bool HasGap() const
  {
    return ! gaps.empty();
  }

  double MinGapZ() const;
  double MaxGapZ() const;
  // compute vertical bounds of all gaps in this region.
  // requires at least one gap!
};


/* ----- VARIABLES ----- */

extern std::vector<csg_brush_c *> all_brushes;

extern std::vector<entity_info_c *> all_entities;

extern std::vector<merge_vertex_c *>  mug_vertices;
extern std::vector<merge_segment_c *> mug_segments;
extern std::vector<merge_region_c *>  mug_regions;
extern std::vector<merge_gap_c *>     mug_gaps;


/* ----- FUNCTIONS ----- */

void CSG2_MergeAreas(void);

void CSG2_GetBounds(double& min_x, double& min_y, double& min_z,
                    double& max_x, double& max_y, double& max_z);

void CSG2_MakeMiniMap(void);

void CSG2_FreeMerges(void);

#endif /* __OBLIGE_CSG_MAIN_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
