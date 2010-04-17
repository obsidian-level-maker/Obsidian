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

#ifndef __OBLIGE_CSG_MAIN_H__
#define __OBLIGE_CSG_MAIN_H__


// grid spacing for quantizing vertices  
#define QUANTIZE_GRID  0.1

// distance between two points to consider them equal.
// the 1.98 provides a small overlap between two quantized vertices.
#define EPSILON  (QUANTIZE_GRID / 1.98)

#define ANGLE_EPSILON  0.0003

// very high (low) value for uncapped brushes
#define EXTREME_H  4000


// unset values (handy sometimes)
#define IVAL_NONE  -27777
#define FVAL_NONE  -27777.75f


/* ----- CLASSES ----- */

class merge_vertex_c;
class merge_segment_c;
class merge_region_c;

class csg_brush_c;


class slope_info_c
{
  // defines the planes used for sloped floors or ceiling.
  // gives two points on the 2D map, and change in Z between them.
  //
  // the absolute Z coords are not here, this is implicitly relative
  // to an external height (such as the top of the brush).

public:
  double sx, sy;
  double ex, ey;

  double dz;

public:
   slope_info_c();
  ~slope_info_c();

  double GetAngle() const;

  double CalcZ(double base_z, double x, double y) const;
};


class csg_face_c
{
public:
  std::map<std::string, std::string> props;

  void * parsed;

///---  // this causes the Upper or Lower on a two-sided linedef to
///---  // be PEGGED, which is useful for doors and steps.
///---  bool peg;

public:
   csg_face_c();
  ~csg_face_c();
};


class brush_vert_c
{
public:
  csg_brush_c *parent;

  double x, y;

  csg_face_c *face;

//----  int line_kind;
//----  int line_tag;
//----  int line_flags;
//----
//----  byte line_args[5];

  merge_vertex_c *partner;

public:
   brush_vert_c(csg_brush_c *_parent, double _x = 0, double _y = 0);
  ~brush_vert_c();
};


class brush_plane_c
{
public:
  // without slope, this is just the height of the top or bottom
  // of the brush.  When sloped, it still represents a bounding
  // height of the brush.
  double z;

  slope_info_c *slope;

  csg_face_c *face;

public:
  brush_plane_c(double _z = 0) : z(_z), slope(NULL), face(NULL)
  { }

  brush_plane_c(const brush_plane_c& other);

  ~brush_plane_c();
};


typedef enum
{
  BKIND_Solid = 0,
  BKIND_Detail,   // ignored for clipping (Quake 1/2 only)
  BKIND_Clip,     // clipping only, no visible faces (Quake 1/2 only)

  BKIND_Sky,
  BKIND_Liquid,
  BKIND_Rail,     // supply a railing (DOOM/Nukem only)
  BKIND_Light,    // supply extra lighting or shadow
}
brush_kind_e;

typedef enum
{
  // internal flags
  BRU_IF_Quad    = (1 << 16),  // brush is a four-sided box
}
brush_flags_e;


class csg_brush_c
{
  // This represents a "brush" in Quake terms, a solid area
  // on the map with out-facing sides and top/bottom.  Like
  // quake brushes, these must be convex, but co-linear sides
  // are allowed.

public:
  int bkind;
  int bflags;

  std::vector<brush_vert_c *> verts;

  brush_plane_c b;  // bottom
  brush_plane_c t;  // top

//----  // without slopes, these are just the heights of the bottom
//----  // and top faces.  When slopes are present, they represent the
//----  // bounding heights of the brush.
//----  double z1, z2;
//----
//----  // these are NULL when not sloped
//----  slope_info_c *b_slope;
//----  slope_info_c *t_slope;
//----
//----  csg_face_c *b_face;
//----  csg_face_c *t_face;

  double min_x, min_y;
  double max_x, max_y;

//----  // this moves the whole brush up or down _after_ all the CSG
//----  // construction has been done.  It's purpose is to ease the
//----  // creation of features inset into the floor or ceiling.
//----  // Yes it's a hack, but a very useful one!
//----  double delta_z;
//----
//----  int mark;
//----  int sec_kind, sec_tag;

public:
   csg_brush_c();
  ~csg_brush_c();

  // copy constructor
  csg_brush_c(const csg_brush_c *other, bool do_verts = false);

  void ComputeBBox();

  const char * Validate();
  // makes sure there are enough vertices and they are in
  // anti-clockwise order.  Returns NULL if OK, otherwise an
  // error message string.
};


class entity_info_c
{
public:
  std::string name;

  double x, y, z;

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
    return (I_ROUND(_xx / QUANTIZE_GRID) == I_ROUND(x / QUANTIZE_GRID)) &&
           (I_ROUND(_yy / QUANTIZE_GRID) == I_ROUND(y / QUANTIZE_GRID));
  }

  inline bool Match(const merge_vertex_c *other) const
  {
    return (I_ROUND(other->x / QUANTIZE_GRID) == I_ROUND(x / QUANTIZE_GRID)) &&
           (I_ROUND(other->y / QUANTIZE_GRID) == I_ROUND(y / QUANTIZE_GRID));
  }
    
  void AddSeg(merge_segment_c *seg);
  void RemoveSeg(merge_segment_c *seg);

  void ReplaceSeg(merge_segment_c *old_seg, merge_segment_c *new_seg);
  bool HasSeg(merge_segment_c *seg) const;

  merge_segment_c * FindSeg(merge_vertex_c *other);
};


class merge_segment_c
{
  // This is a just a line on the 2D map.

public:
  merge_vertex_c *start;
  merge_vertex_c *end;

  merge_region_c *front;
  merge_region_c *back;

  // line-loop parts which lie along this segment
  std::vector<brush_vert_c *> f_sides;
  std::vector<brush_vert_c *> b_sides;

  // this index is not used by the polygoniser code (csg_poly.cc),
  // only by the Doom conversion code.  -1 means "unused".
  int index;

public:
  merge_segment_c(merge_vertex_c *_v1, merge_vertex_c *_v2) :
      start(_v1), end(_v2), front(NULL), back(NULL),
      f_sides(), b_sides(), index(-1)
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

  void ReplaceStart(merge_vertex_c *V);
  void ReplaceEnd  (merge_vertex_c *V);

  void MergeSides(merge_segment_c *other);

  void Kill();
  void Flip();

  bool HasGap() const;

  brush_vert_c *FindSide(csg_brush_c *brush);
};


class merge_gap_c
{
public:
  merge_region_c *parent;

  csg_brush_c *b_brush;
  csg_brush_c *t_brush;

  std::vector<merge_gap_c *> neighbors;

  std::vector<entity_info_c *> entities;

  bool reachable;

public:
  merge_gap_c(merge_region_c *R, csg_brush_c *B, csg_brush_c *T) :
      parent(R), b_brush(B), t_brush(T),
      neighbors(), entities(), reachable(false)
  { }

  ~merge_gap_c()
  { }

  inline double GetZ1() const
  {
    return b_brush->t.z;
  }

  inline double GetZ2() const
  {
    return t_brush->b.z;
  }

//---  inline const char *FloorTex() const
//---  {
//---    return b_brush->t_face->tex.c_str();
//---  }
//---
//---  inline const char *CeilTex() const
//---  {
//---    return t_brush->b_face->tex.c_str();
//---  }
};


class merge_region_c
{
  // This represents a region on the 2D map, bounded by a group
  // of segments.  Each region lists all the brushes contained,
  // as well as the gaps (vertical spaces between brushes where
  // objects can go).

public:
  bool faces_out;

  std::vector<csg_brush_c *> brushes;

  std::vector<merge_segment_c *> segs;

  // gaps are in order from lowest to highest
  std::vector<merge_gap_c *> gaps;

  double min_x, min_y;
  double max_x, max_y;

  // this index is not used by the polygoniser code (csg_poly.cc),
  // only by the Doom conversion code.  -1 means "unused".
  int index;

public:
  merge_region_c() : faces_out(false), brushes(), segs(), gaps(), index(-1)
  { }

  ~merge_region_c()
  { }

  inline bool HasGap() const
  {
    return ! gaps.empty();
  }

  // compute vertical bounds of all gaps in this region.
  // requires at least one gap!
  double MinGapZ() const;
  double MaxGapZ() const;

  bool HasSeg(merge_segment_c *seg) const;
  void AddSeg(merge_segment_c *seg);

  bool HasBrush(csg_brush_c *P) const;
  void AddBrush(csg_brush_c *P);

  void ComputeBBox();
};


/* ----- VARIABLES ----- */

extern std::vector<csg_brush_c *> all_brushes;

extern std::vector<entity_info_c *> all_entities;

extern std::vector<merge_vertex_c *>  mug_vertices;
extern std::vector<merge_segment_c *> mug_segments;
extern std::vector<merge_region_c *>  mug_regions;
extern std::vector<merge_gap_c *>     mug_gaps;

extern int bounds_x1, bounds_y1, bounds_z1;
extern int bounds_x2, bounds_y2, bounds_z2;

extern csg_face_c *dummy_side_face;
extern csg_face_c *dummy_plane_face;


/* ----- FUNCTIONS ----- */

const char * CSG2_Lookup(std::map<std::string, std::string> & props,
                         const char *field, const char *nil_result = NULL);

void CSG2_MergeAreas(bool do_clips = false);

brush_vert_c * CSG2_FindSideVertex(merge_segment_c *G, double z,
                                  bool is_front, bool exact = false);
csg_brush_c * CSG2_FindSideBrush(merge_segment_c *G, double z,
                                 bool is_front, bool exact = false);
csg_face_c * CSG2_FindSideFace(merge_segment_c *G, double z, bool is_front,
                               brush_vert_c *V = NULL);

merge_region_c *CSG2_FindRegionForPoint(double x, double y);

void CSG2_MakeMiniMap(void);

void CSG2_UpdateBounds(bool three_d);

void CSG2_FreeMerges(void);

#endif /* __OBLIGE_CSG_MAIN_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
