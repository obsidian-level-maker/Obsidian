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

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"

#include <algorithm>

#include "csg_poly.h"
#include "g_lua.h"
#include "lib_util.h"

#include "main.h"
#include "ui_dialog.h"
#include "ui_window.h"


std::vector<area_info_c *> all_areas;
std::vector<area_poly_c *> all_polys;

std::vector<merged_area_c *> all_merges;


static int cur_poly_time;


slope_points_c::slope_points_c() :
      tz1(FVAL_NONE), tz2(FVAL_NONE),
      bz1(FVAL_NONE), bz2(FVAL_NONE),
      x1(0), y1(0), x2(0), y2(0)
{ }

slope_points_c::~slope_points_c()
{ }


area_info_c::area_info_c() :
      t_tex(), b_tex(), w_tex(),
      z1(-1), z2(-1), slope(),
      sec_kind(0), sec_tag(0),
      t_light(255), b_light(255)
{
  time = cur_poly_time++;
}

area_info_c::~area_info_c()
{ }


area_side_c::area_side_c() :
      w_tex(), t_rail(), x_offset(0), y_offset(0)
{ }

area_side_c::~area_side_c()
{ }


area_vert_c::area_vert_c() :
      x(0), y(0), front(), back(),
      line_kind(0), line_tag(0), line_flags(0)
{
  memset(line_args, 0, sizeof(line_args));
}

area_vert_c::~area_vert_c()
{ }


area_poly_c::area_poly_c(area_info_c *_info) : info(_info), verts()
{ }

area_poly_c::~area_poly_c()
{
  // FIXME: free verts
}

void area_poly_c::ComputeBBox()
{
  min_x = +999999.9;
  min_y = +999999.9;
  max_x = -999999.9;
  max_y = -999999.9;

  std::vector<area_vert_c *>::iterator VI;

  for (VI = verts.begin(); VI != verts.end(); VI++)
  {
    area_vert_c *V = *VI;

    if (V->x < min_x) min_x = V->x;
    if (V->x > max_x) max_x = V->x;

    if (V->y < min_y) min_y = V->y;
    if (V->y > max_y) max_y = V->y;
  }
}


merged_area_c::merged_area_c() : polys(), sector_index(-1)
{ }

merged_area_c::~merged_area_c()
{
  // TODO: free stuff
}



//------------------------------------------------------------------------

static void AddPoly_MakeConvex(area_poly_c *P)
{
  // splits this area_poly into convex pieces (if needed) and
  // add each separate piece (sharing the same sector info).

  // TODO: Make convex

  all_polys.push_back(P);
}


//------------------------------------------------------------------------

static area_info_c * Grab_SectorInfo(lua_State *L, int stack_pos)
{
  if (stack_pos < 0)
    stack_pos += lua_gettop(L) + 1;

  if (lua_type(L, stack_pos) != LUA_TTABLE)
  {
    luaL_argerror(L, stack_pos, "expected a table (sector info)");
    return 0; /* NOT REACHED */
  }

  area_info_c *A = new area_info_c();

  lua_getfield(L, stack_pos, "t_tex");
  lua_getfield(L, stack_pos, "b_tex");
  lua_getfield(L, stack_pos, "w_tex");

  A->t_tex = std::string(luaL_checkstring(L, -3));
  A->b_tex = std::string(luaL_checkstring(L, -2));
  A->w_tex = std::string(luaL_checkstring(L, -1));

  lua_pop(L, 3);

  // TODO: sec_kind, sec_tag
  // TODO: t_light, b_light
  // TODO: y_offset, peg

  return A;
}


static int Grab_Heights(lua_State *L, int stack_pos, area_info_c *A)
{
  A->z1 = luaL_checknumber(L, stack_pos + 0);
  A->z2 = luaL_checknumber(L, stack_pos + 1);

  if (A->z2 <= A->z1 + 0.1)
  {
    return luaL_error(L, "add_solid: bad z1..z2 range given (%1.2f .. %1.2f)", A->z1, A->z2);
  }

  return 0;
}


static int Grab_SlopeInfo(lua_State *L, int stack_pos, area_info_c *A)
{
  int what = lua_type(L, stack_pos);

  if (what == LUA_TNONE || what == LUA_TNIL)
    return 0;

  if (what != LUA_TTABLE)
  {
    luaL_argerror(L, stack_pos, "expected a table (slope info)");
    return 0; /* NOT REACHED */
  }

  // TODO

  Main_FatalError("CSG2: slope_info not yet supported!\n");
  return 0; /* NOT REACHED */
}


static int Grab_SideDef(lua_State *L, int stack_pos, area_side_c *S)
{
  if (lua_type(L, stack_pos) != LUA_TTABLE)
  {
    luaL_argerror(L, stack_pos, "expected a table (sidedef)");
    return 0; /* NOT REACHED */
  }

  // TODO

  Main_FatalError("CSG2: sidedef info not yet supported!\n");
  return 0; /* NOT REACHED */
}


static area_vert_c * Grab_Vertex(lua_State *L, int stack_pos)
{
  if (stack_pos < 0)
    stack_pos += lua_gettop(L) + 1;

  if (lua_type(L, stack_pos) != LUA_TTABLE)
  {
    luaL_argerror(L, stack_pos, "expected a table (vertex)");
    return 0; /* NOT REACHED */
  }

  area_vert_c *V = new area_vert_c();

  lua_getfield(L, stack_pos, "x");
  lua_getfield(L, stack_pos, "y");

  V->x = luaL_checknumber(L, -2);
  V->y = luaL_checknumber(L, -1);

  lua_pop(L, 2);

  // TODO: front, back
  // TODO: kind, tag, flags, args

  return V;
}


static area_poly_c * Grab_LineLoop(lua_State *L, int stack_pos, area_info_c *A)
{
  if (lua_type(L, stack_pos) != LUA_TTABLE)
  {
    luaL_argerror(L, stack_pos, "expected a table (line loop)");
    return 0; /* NOT REACHED */
  }

  area_poly_c *P = new area_poly_c(A);

  int index = 1;

  for (;;)
  {
    lua_pushinteger(L, index);
    lua_gettable(L, stack_pos);

    if (lua_isnil(L, -1))
    {
      lua_pop(L, 1);
      break;
    }

    area_vert_c *V = Grab_Vertex(L, -1);

    P->verts.push_back(V);

    lua_pop(L, 1);

    index++;
  }

  if (P->verts.size() < 3)
    Main_FatalError("line loop contains less than 3 vertices!\n");

  P->ComputeBBox();

  return P;
}


namespace csg2
{

// LUA: add_solid(info, loop, z1, z2, slope_info)
//
// info is a table:
//   t_tex, b_tex  : top and bottom textures
//   w_tex         : default wall (side) texture
//   peg, y_offset : default peg and y_offset for sides
//   t_kind, t_tag
//   t_light, b_light
// 
// slope_info is a table (can be nil)
//    x1, y1, x2, y2  : coordinates on 2D map for slope points
//    tz1, tz2        : height coords for top slope
//    bz1, bz2        : height coords for bottom slope
//
// loop is an array of Vertices:
//    x, y,
//    front, back,
//    ln_kind, ln_tag, ln_flags, ln_args
//
// front and back are Sidedefs:
//    w_tex, peg, rail, x_offset, y_offset
//
int add_solid(lua_State *L)
{
  area_info_c *A = Grab_SectorInfo(L, 1);

  all_areas.push_back(A);

  Grab_Heights(L, 3, A);
  Grab_SlopeInfo(L, 5, A);

  area_poly_c *P = Grab_LineLoop(L, 2, A);

  AddPoly_MakeConvex(P);

  return 0;
}

} // namespace csg2


//------------------------------------------------------------------------


class segment_c;


class vertex_c
{
public:
  double x, y;

  // list of segments that touch this vertex
  std::vector<segment_c *> segs;

public:
   vertex_c() : x(0), y(0) { }
   vertex_c(double _xx, double _yy) : x(_xx), y(_yy) { }
  ~vertex_c() { }

  inline bool Match(double _xx, double _yy) const
  {
    return (fabs(_xx - x) <= EPSILON) &&
           (fabs(_yy - y) <= EPSILON);
  }
    
  inline bool Match(const vertex_c *other) const
  {
    return (fabs(other->x - x) <= EPSILON) &&
           (fabs(other->y - y) <= EPSILON);
  }
    
  void AddSeg(segment_c *seg)
  {
    for (int j=0; j < (int)segs.size(); j++)
      if (segs[j] == seg)
        return;

    segs.push_back(seg);
  }

  void RemoveSeg(segment_c *seg)
  {
    std::vector<segment_c *>::iterator ENDP;

    ENDP = std::remove(segs.begin(), segs.end(), seg);

    segs.erase(ENDP, segs.end());
  }

  void ReplaceSeg(segment_c *old_seg, segment_c *new_seg)
  {
    for (int j=0; j < (int)segs.size(); j++)
      if (segs[j] == old_seg)
      {
        segs[j] = new_seg;
        return;
      }

    Main_FatalError("ReplaceSeg: does not exist!\n");
  }
};


class segment_c
{
public:
  vertex_c *start;
  vertex_c *end;

public:
  segment_c(vertex_c *_v1, vertex_c *_v2) : start(_v1), end(_v2)
  { }

  ~segment_c()
  { }

  inline bool Match(vertex_c *_v1, vertex_c *_v2) const
  {
    return (_v1 == start && _v2 == end) ||
           (_v2 == start && _v1 == end);
  }

  inline bool Match(const segment_c *other) const
  {
    return (other->start == start && other->end   == end) ||
           (other->end   == start && other->start == end);
  }

  void Kill(void)
  {
    start->RemoveSeg(this);
    end  ->RemoveSeg(this);

    start = end = NULL;
  }
};


static std::vector<vertex_c *>  mug_vertices;
static std::vector<segment_c *> mug_segments;

static std::vector<segment_c *> mug_new_segs;

static int mug_changes = 0;


static vertex_c *Mug_AddVertex(double x, double y)
{
  // check if already present (FIXME: OPTIMISE !!)

  for (int i=0; i < (int)mug_vertices.size(); i++)
    if (mug_vertices[i]->Match(x, y))
      return mug_vertices[i];

  vertex_c * V = new vertex_c(x, y);

  mug_vertices.push_back(V);

  return V;
}

static segment_c *Mug_AddSegment(vertex_c *start, vertex_c *end)
{
  // check if already present (FIXME: OPTIMISE !!)

  SYS_ASSERT(start != end);

  for (int i=0; i < (int)mug_segments.size(); i++)
    if (mug_segments[i]->Match(start, end))
      return mug_segments[i];

  segment_c * S = new segment_c(start, end);

  mug_segments.push_back(S);

  start->AddSeg(S);
  end  ->AddSeg(S);

  return S;
}

static void Mug_MakeSegments(area_poly_c *P)
{
  for (int k=0; k < (int)P->verts.size(); k++)
  {
    area_vert_c *v1 = P->verts[k];
    area_vert_c *v2 = P->verts[(k+1) % (int)P->verts.size()];

    vertex_c *new_v1 = Mug_AddVertex(v1->x, v1->y);
    vertex_c *new_v2 = Mug_AddVertex(v2->x, v2->y);

    Mug_AddSegment(new_v1, new_v2);
  }
}

static void Mug_SplitSegment(segment_c *S, vertex_c *V)
{
  segment_c *NS = new segment_c(V, S->end);

  S->end = V;

  mug_new_segs.push_back(NS);

  // update join info

  NS->end->ReplaceSeg(S, NS);

  V->AddSeg(S);
  V->AddSeg(NS);
}

struct SegDead_pred
{
  inline bool operator() (const segment_c *S) const
  {
    return ! S->start;
  }
};

static void Mug_AdjustList(void)
{
  /* Removes dead segs and Appends new segs */

  std::vector<segment_c *>::iterator ENDP;

  ENDP = std::remove_if(mug_segments.begin(), mug_segments.end(), SegDead_pred());

  mug_segments.erase(ENDP, mug_segments.end());


  while (mug_new_segs.size() > 0)
  {
    segment_c *S = mug_new_segs.back();

    mug_new_segs.pop_back();
    mug_segments.push_back(S);
  }
}


struct Compare_SegmentMinX_pred
{
  inline bool operator() (const segment_c *A, const segment_c *B) const
  {
    return MIN(A->start->x, A->end->x) < MIN(B->start->x, B->end->x);
  }
};

static inline double PerpDist(double x, double y,
                              double x1, double y1, double x2, double y2)
{
  x  -= x1; y  -= y1;
  x2 -= x1; y2 -= y1;

  double len = sqrt(x2*x2 + y2*y2);

  SYS_ASSERT(len > 0);

  return (x * y2 - y * x2) / len;
}

static inline double AlongDist(double x, double y,
                               double x1, double y1, double x2, double y2)
{
  x  -= x1; y  -= y1;
  x2 -= x1; y2 -= y1;

  double len = sqrt(x2*x2 + y2*y2);

  SYS_ASSERT(len > 0);

  return (x * x2 + y * y2) / len;
}


static void Mug_OverlapPass(void)
{
//!!!!  std::sort(mug_segments.begin(), mug_segments.end(), Compare_SegmentMinX_pred());

  for (int i=0; i < (int)mug_segments.size(); i++)
  {
    segment_c *A = mug_segments[i];

    for (int k=i+1; k < (int)mug_segments.size(); k++)
    {
      segment_c *B = mug_segments[k];

      // skip deleted segments
      if (! A->start) break;
      if (! B->start) continue;

      double ax1 = A->start->x;
      double ay1 = A->start->y;
      double ax2 = A->end->x;
      double ay2 = A->end->y;

      double bx1 = B->start->x;
      double by1 = B->start->y;
      double bx2 = B->end->x;
      double by2 = B->end->y;

#if 0 //!!!! TESTING
      if (MIN(bx1, bx2) > MAX(ax1, ax2)+EPSILON)
        break;
#else
      if (MIN(bx1, bx2) > MAX(ax1, ax2)+EPSILON ||
          MIN(ax1, ax2) > MAX(bx1, bx2)+EPSILON)
        continue;
#endif

      if (MIN(by1, by2) > MAX(ay1, ay2)+EPSILON ||
          MIN(ay1, ay2) > MAX(by1, by2)+EPSILON)
        continue;

      /* to get here, the bounding boxes must touch or overlap.
       * now we perform the line-line intersection test.
       */

      double ap1 = PerpDist(ax1,ay1, bx1,by1, bx2,by2);
      double ap2 = PerpDist(ax2,ay2, bx1,by1, bx2,by2);

      double bp1 = PerpDist(bx1,by1, ax1,ay1, ax2,ay2);
      double bp2 = PerpDist(bx2,by2, ax1,ay1, ax2,ay2);

      // does A cross B-extended-to-infinity?
      if ((ap1 >  EPSILON && ap2 >  EPSILON) ||
          (ap1 < -EPSILON && ap2 < -EPSILON))
        continue;

      // does B cross A-extended-to-infinity?
      if ((bp1 >  EPSILON && bp2 >  EPSILON) ||
          (bp1 < -EPSILON && bp2 < -EPSILON))
        continue;

      // check if on the same line
      if (fabs(bp1) <= EPSILON && fabs(bp2) <= EPSILON)
      {
#if 1
        // same start + end points?
        if (A->Match(B))
        {
          B->Kill();
          mug_changes++;
          continue;
        }
#endif
        // find vertices that split a segment
        double a1_along = 0.0;
        double a2_along = AlongDist(ax2,ay2, ax1,ay1, ax2,ay2);
        double b1_along = AlongDist(bx1,by1, ax1,ay1, ax2,ay2);
        double b2_along = AlongDist(bx2,by2, ax1,ay1, ax2,ay2);

        if (b1_along > a1_along+EPSILON && b1_along < a2_along-EPSILON)
          Mug_SplitSegment(A, B->start);

        if (b2_along > a1_along+EPSILON && b2_along < a2_along-EPSILON)
          Mug_SplitSegment(A, B->end);

        if (a1_along > b1_along+EPSILON && a1_along < b2_along-EPSILON)
          Mug_SplitSegment(B, A->start);

        if (a2_along > b1_along+EPSILON && a2_along < b2_along-EPSILON)
          Mug_SplitSegment(B, A->end);
#if 0
        // check for total overlap (A covers B or vice versa)
#endif
        continue;
      }

      // check for sharing a single vertex
      // (NOTE: **rely** on the fact that all vertices are unique)
      if (A->start->Match(B->start) || A->start->Match(B->end) ||
          A->end  ->Match(B->start) || A->end  ->Match(B->end))
        continue;

      // check for T junction
      if (fabs(bp1) <= EPSILON)
      {
        Mug_SplitSegment(A, B->start);
        continue;
      }
      else if (fabs(bp2) <= EPSILON)
      {
        Mug_SplitSegment(A, B->end);
        continue;
      }
      else if (fabs(ap1) <= EPSILON)
      {
        Mug_SplitSegment(B, A->start);
        continue;
      }
      else if (fabs(ap2) <= EPSILON)
      {
        Mug_SplitSegment(B, A->end);
        continue;
      }

      /* pure overlap */
      
      // intersection point
      double along = bp1 / (bp1 - bp2);

      double ix = bx1 + along * (bx2 - bx1);
      double iy = by1 + along * (by2 - by1);

      vertex_c * NV = Mug_AddVertex(ix, iy);
      
      Mug_SplitSegment(A, NV);
      Mug_SplitSegment(B, NV);
    }
  }
}

static void Mug_FindOverlaps(void)
{
  do
  {
    mug_changes = 0;

    Mug_OverlapPass();
    Mug_AdjustList();
  }
  while (mug_changes > 0);
}


struct Compare_PolyMinX_pred
{
  inline bool operator() (const area_poly_c *A, const area_poly_c *B) const
  {
    return A->min_x < B->min_x;
  }
};

void CSG2_MergeAreas(void)
{
  // this takes all the area_polys, figures out what OVERLAPS
  // (on the 2D map), and performs the CSG operations to create
  // new area_polys for the overlapping parts.
  //
  // also figures out which area_polys are TOUCHING, and ensures
  // there are vertices where needed (at 'T' junctions).

  // Algorithm:
  //   (1) create segments and vertices for every line
  //   (2) check seg against every other seg for overlap/T-junction
  //   (3) create merge_polys from seg list

  for (int j=0; j < (int)all_polys.size(); j++)
  {
    area_poly_c *P = all_polys[j];
    SYS_ASSERT(P);

    Mug_MakeSegments(P);
  }

  // TODO
}


//------------------------------------------------------------------------

static const luaL_Reg csg2_funcs[] =
{
  { "add_solid",   csg2::add_solid   },

  { NULL, NULL } // the end
};


void CSG2_Init(void)
{
  Script_RegisterLib("csg2", csg2_funcs);
}

void CSG2_BeginLevel(void)
{
  cur_poly_time = 0;
}

void CSG2_EndLevel(void)
{
  // FIXME: free all_polys

  // FIXME: free all_merges
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
