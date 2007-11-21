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
#include "g_doom.h"
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

  // TODO: Make convex  -  needed ???

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
  if (stack_pos < 0)
    stack_pos += lua_gettop(L) + 1;

  if (lua_type(L, stack_pos) != LUA_TTABLE)
  {
    return luaL_argerror(L, stack_pos, "expected a table (height info)");
  }

  lua_getfield(L, stack_pos, "z1");
  lua_getfield(L, stack_pos, "z2");

  A->z1 = luaL_checknumber(L, -2);
  A->z2 = luaL_checknumber(L, -1);

  lua_pop(L, 2);

  if (A->z2 <= A->z1 + EPSILON)
  {
    return luaL_error(L, "add_solid: bad z1..z2 range given (%1.2f .. %1.2f)", A->z1, A->z2);
  }

  // TODO: px1, py1, px2, py2,  tz1, tz2, bz1, bz2

  return 0;
}


static int Grab_SideDef(lua_State *L, int stack_pos, area_side_c *S)
{
  if (lua_type(L, stack_pos) != LUA_TTABLE)
  {
    return luaL_argerror(L, stack_pos, "expected a table (sidedef)");
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
    return NULL; /* NOT REACHED */
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
    return NULL; /* NOT REACHED */
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

// LUA: add_solid(info, loop, heights)
//
// info is a table:
//   t_tex, b_tex  : top and bottom textures
//   w_tex         : default wall (side) texture
//   peg, y_offset : default peg and y_offset for sides
//   t_kind, t_tag
//   t_light, b_light
// 
// heights is a table (can be nil)
//    z1, z2             : height range (compulsory)
//    px1, py1, px2, py2 : coordinates on 2D map for slope points
//    tz1, tz2           : height values for top slope
//    bz1, bz2           : height values for bottom slope
//
// loop is an array of Vertices:
//    x, y,
//    front, back,
//    line_kind, line_tag, line_flags, line_args
//
// front and back are Sidedefs:
//    w_tex, peg, rail,
//    x_offset, y_offset
//
int add_solid(lua_State *L)
{
  area_info_c *A = Grab_SectorInfo(L, 1);

  all_areas.push_back(A);

  Grab_Heights(L, 3, A);

  area_poly_c *P = Grab_LineLoop(L, 2, A);

  AddPoly_MakeConvex(P);

  return 0;
}

} // namespace csg2


//------------------------------------------------------------------------


class segment_c;
class region_c;


class vertex_c
{
public:
  double x, y;

  // list of segments that touch this vertex
  std::vector<segment_c *> segs;

  int index;

public:
   vertex_c() : x(0), y(0), segs(), index(-1) { }
   vertex_c(double _xx, double _yy) : x(_xx), y(_yy), segs(), index(-1) { }
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

  region_c *front;
  region_c *back;

public:
  segment_c(vertex_c *_v1, vertex_c *_v2) : start(_v1), end(_v2), front(NULL), back(NULL)
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

  void Flip(void)
  {
    vertex_c *tmp_V = start; start = end; end = tmp_V;

    region_c *tmp_R = front; front = back; back = tmp_R;
  }
};


class region_c
{
public:
  bool faces_out;

  int index;

  std::vector<area_poly_c *> areas;

public:
  region_c() : faces_out(false), index(-1), areas()
  { }

  ~region_c()
  { }
};


static std::vector<vertex_c *>  mug_vertices;
static std::vector<segment_c *> mug_segments;
static std::vector<region_c *>  mug_regions;

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

  mug_changes++;
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

#if 0
fprintf(stderr, ".. %d new segments, %d dead ones\n",
       (int)mug_new_segs.size(), (int)(mug_segments.end() - ENDP));
#endif

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

static inline double CalcAngle(double sx, double sy, double ex, double ey)
{
  // result is Degrees (0 <= angle < 360).
  // East  (increasing X) -->  0 degrees
  // North (increasing Y) --> 90 degrees

  ex -= sx;
  ey -= sy;

  if (fabs(ex) < 0.0001)
    return (ey > 0) ? 90.0 : 270.0;

  if (fabs(ey) < 0.0001)
    return (ex > 0) ? 0.0 : 180.0;

  double angle = atan2(ey, ex) * 180.0 / M_PI;

  if (angle < 0) 
    angle += 360.0;

  return angle;
}


static void Mug_OverlapPass(void)
{
  /* sort segments in order of minimum X coordinate */
  std::sort(mug_segments.begin(), mug_segments.end(),
            Compare_SegmentMinX_pred());

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

#if 1 // normal code
      if (MIN(bx1, bx2) > MAX(ax1, ax2)+EPSILON)
        break;
#else // non-sorted method (TESTING only)
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
        // NOTE: this will be detected in next pass
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

      /* pure cross-over */
      
      // add a new vertex at the intersection point
      double along = bp1 / (bp1 - bp2);

      double ix = bx1 + along * (bx2 - bx1);
      double iy = by1 + along * (by2 - by1);

#if 0
fprintf(stderr, ".. pure cross-over at (%1.2f, %1.2f)\n", ix, iy);
fprintf(stderr, "   A = (%1.0f,%1.0f) --> (%1.0f,%1.0f)\n", ax1,ay1, ax2,ay2);
fprintf(stderr, "   B = (%1.0f,%1.0f) --> (%1.0f,%1.0f)\n", bx1,by1, bx2,by2);
#endif

      vertex_c * NV = Mug_AddVertex(ix, iy);
      
      Mug_SplitSegment(A, NV);
      Mug_SplitSegment(B, NV);
    }
  }
}

static void Mug_FindOverlaps(void)
{
  int loops = 0;

  do
  {
    SYS_ASSERT(loops < 1000);

    mug_changes = 0;

    Mug_OverlapPass();
    Mug_AdjustList();

    loops++;

fprintf(stderr, "Mug_FindOverlaps: loop %d, changes %d\n", loops, mug_changes);
  }
  while (mug_changes > 0);
}


//------------------------------------------------------------------------

static segment_c *trace_seg;
static vertex_c  *trace_vert;
static int        trace_side;
static double     trace_angles;

static void TraceNext(void)
{
  vertex_c *next_v;

  if (trace_vert == trace_seg->start)
    next_v = trace_seg->end;
  else
    next_v = trace_seg->start;

  segment_c *best_seg = NULL;
  double     best_angle = 999;

  double old_angle = CalcAngle(next_v->x, next_v->y, trace_vert->x, trace_vert->y);
  
  for (int k = 0; k < (int)next_v->segs.size(); k++)
  {
    segment_c *T = next_v->segs[k];

    if (T == trace_seg)
      continue;

    vertex_c *TV2 = (next_v == T->start) ? T->end : T->start;

    double angle = CalcAngle(next_v->x, next_v->y, TV2->x, TV2->y);

    if (trace_side == 0)
    {
      // FRONT: want lowest angle ANTI-Clockwise from current seg
      angle = angle - old_angle;
    }
    else
    {
      // BACK: want lowest angle CLOCKWISE from current seg
      angle = old_angle - angle;
    }

    // should never have two segments with same angle (pt 1)
    SYS_ASSERT(fabs(angle) > ANGLE_EPSILON);

    if (angle < 0)
      angle += 360.0;

    SYS_ASSERT(angle > -ANGLE_EPSILON);
    SYS_ASSERT(angle < 360.0 + ANGLE_EPSILON);

    // should never have two segments with same angle (pt 2)
    SYS_ASSERT(fabs(best_angle - angle) > ANGLE_EPSILON);

    if (angle < best_angle)
    {
      best_seg = T;
      best_angle = angle;
    }
  }

  SYS_ASSERT(best_seg);

  trace_seg  = best_seg;
  trace_vert = next_v;

  trace_angles += best_angle;
}

static void TraceSegment(segment_c *S, int side)
{
#if 0
fprintf(stderr, "TraceSegment (%1.1f,%1.1f) .. (%1.1f,%1.1f) side:%d\n",
S->start->x, S->start->y,
S->end->x, S->end->y, side);
#endif
  
  region_c *R = new region_c();

R->index = (int)mug_regions.size(); // ONLY NEED FOR DEBUG

  mug_regions.push_back(R);


  trace_seg  = S;
  trace_vert = S->start;
  trace_side = side;

  trace_angles = 0.0;
 
  int count = 0;

  do
  {
    TraceNext();

#if 0
fprintf(stderr, "  CUR SEG (%1.1f,%1.1f) .. (%1.1f,%1.1f)\n",
trace_seg->start->x, trace_seg->start->y,
trace_seg->end->x, trace_seg->end->y);

fprintf(stderr, "  CUR VERT: %s\n",
(trace_vert == trace_seg->start) ? "start" :
(trace_vert == trace_seg->end) ? "end" : "FUCKED");
#endif

    if ((trace_vert == trace_seg->start) == (side == 0))
    {
      // TODO: this assert indicates we hit some dead-end or
      //       non-returning loop.  Make it a mere WARNING.
      SYS_ASSERT(! trace_seg->front);
      trace_seg->front = R;
    }
    else
    {
      SYS_ASSERT(! trace_seg->back);
      trace_seg->back = R;
    }

    count++;

    SYS_ASSERT(count < 9000);
  }
  while (trace_seg != S);

  SYS_ASSERT(count >= 3);

  R->faces_out = (trace_angles / count) > 180.0;

//fprintf(stderr, "DONE\n\n");
}

static void Mug_TraceSegLoops(void)
{
  // Algorithm:
  //
  // starting at a particular seg and a particular vertex of
  // that seg, follow the segs around in the tightest loop
  // possible until we get back to the beginning.  The result
  // will form a 'merged_area' (i.e. a "sector" for Doom).
  //
  // Note: if the average angle is > 180, then the sector
  //       faces outward (i.e. it's actually an island within
  //       another sector -OR- the edge of the map).

  for (int i = 0; i < (int)mug_segments.size(); i++)
  {
    segment_c *S = mug_segments[i];

    if (! S->front)
      TraceSegment(S, 0);

    if (! S->back)
      TraceSegment(S, 1);
  }
}

static bool GetOppositeSegment(segment_c *S, int side, 
    segment_c **hit, int *hit_side, double along)
{
  // Returns false if result was ambiguous (e.g. the only segment
  // hit was parallel to the casting line, and two-sided).

  // Algorithm: cast a line (horizontal or vertical, depending
  // on the source segment's orientation) and test all segments
  // which intersect or touch it.

  double lx = MIN(S->start->x, S->end->x);
  double ly = MIN(S->start->y, S->end->y);

  double hx = MAX(S->start->x, S->end->x);
  double hy = MAX(S->start->y, S->end->y);

  double mx = S->start->x + (S->end->x - S->start->x) * along;
  double my = S->start->y + (S->end->y - S->start->y) * along;

  bool cast_vert = (hx-lx) > (hy-ly);

  segment_c *best_seg  = NULL;
  bool       best_vert = false;
  int        best_side = 0;
  double     best_dist = 999999.0;

  for (int t = 0; t < (int)mug_segments.size(); t++)
  {
    segment_c *T = mug_segments[t];

    if (T == S)
      continue;

    if (cast_vert)
    {
      /* vertical cast line */

      double ss = T->start->x - mx;
      double ee = T->end->x   - mx;

      if (MAX(ss, ee) < -EPSILON || MIN(ss, ee) > EPSILON)
        continue;  // no intersection

      // compute distance from S to T
      double dist;

      if (fabs(ss) <= EPSILON)
        dist = T->start->y - my;
      else if (fabs(ee) <= EPSILON)
        dist = T->end->y - my;
      else
      {
        double iy = T->start->y + (T->end->y - T->start->y) * fabs(ss) / fabs(ss - ee);
        dist = iy - my;
      }

      // correct the sign based on 'side' and orientation of S
      if ((S->start->x < S->end->x) == (side == 0))
          dist = -dist;

      if (dist <= EPSILON)
        continue; // intersects on wrong side

      if (dist < best_dist)
      {
        best_dist = dist;
        best_seg  = T;
        best_vert = (fabs(ss) <= EPSILON || fabs(ee) <= EPSILON);
        best_side = side;

        if (S->end->x > S->start->x) best_side ^= 1;
        if (T->end->x < T->start->x) best_side ^= 1;
      }
    }
    else
    {
      /* horizontal cast line */

      double ss = T->start->y - my;
      double ee = T->end->y   - my;

      if (MAX(ss, ee) < -EPSILON || MIN(ss, ee) > EPSILON)
        continue;  // no intersection

      // compute distance from S to T
      double dist;

      if (fabs(ss) <= EPSILON)
        dist = T->start->x - mx;
      else if (fabs(ee) <= EPSILON)
        dist = T->end->x - mx;
      else
      {
        double ix = T->start->x + (T->end->x - T->start->x) * fabs(ss) / fabs(ss - ee);
        dist = ix - mx;
      }

      // correct the sign based on 'side' and orientation of S
      if ((S->start->y < S->end->y) != (side == 0))
          dist = -dist;

      if (dist <= EPSILON)
        continue; // intersects on wrong side

      if (dist < best_dist)
      {
        best_dist = dist;
        best_seg  = T;
        best_vert = (fabs(ss) <= EPSILON || fabs(ee) <= EPSILON);
        best_side = side;

        if (S->end->y > S->start->y) best_side ^= 1;
        if (T->end->y < T->start->y) best_side ^= 1;
      }
    }

  }

  // hitting a vertex is bad (can be ambiguous)
  if (best_vert)
    return false;

  if (best_seg)
  {
    *hit = best_seg;
    *hit_side = best_side;
  }
  else
  {
    *hit = NULL;
    *hit_side = 0;
  }

  return true;
}

static region_c *FindIslandParent(region_c *R)
{
  // there is a small possibility that every segment we test
  // will hit a vertex opposite it.  So when that happens we
  // need to try a different 'along' value.
  static const double along_tries[] =
  {
    0.5, 0.7, 0.3, 0.6, 0,4,
    0,8, 0.2, 0.9, 0.1,

    0.55, 0.45, 0.65, 0.35, 0.75, 0.25,
    0.85, 0.15, 0.95, 0.05,

    -1 // THE END
  };

  for (int a = 0; along_tries[a] > 0; a++)
  {
    for (int i = 0; i < (int)mug_segments.size(); i++)
    {
      segment_c *S = mug_segments[i];
      segment_c *T;

      int S_side;
      int T_side;

      if (S->front == R)
        S_side = 0;
      else if (S->back == R)
        S_side = 1;
      else
        continue;

      if (! GetOppositeSegment(S, S_side, &T, &T_side, along_tries[a]))
      {
        continue;
      }

      if (! T)
      {
        return NULL;  // edge of map
      }

      region_c *R_opp = (T_side == 0) ? T->front : T->back;

      if (R_opp != R)
        return R_opp;
    }
  }

  Main_FatalError("FindIslandParent: cannot find container!\n");
  return NULL; /* NOT REACHED */
}

static void ReplaceRegion(region_c *R_old, region_c *R_new)
{
  for (int i = 0; i < (int)mug_segments.size(); i++)
  {
    segment_c *S = mug_segments[i];

    if (S->front == R_old) S->front = R_new;
    if (S->back  == R_old) S->back  = R_new;

    if (S->back && ! S->front)
      S->Flip();
  }
}

static void Mug_RemoveIslands(void)
{
  // Algorithm:
  //
  // For each island (i.e. region->faces_out is true), cast a
  // line outwards from one of the segments and see what we hit.
  // If we hit nothing at all, the region is the edge of the map.
  // If we hit ourselves, need to try another segment.

  for (int i = 0; i < (int)mug_regions.size(); i++)
  {
    region_c *R = mug_regions[i];
    
    if (R->faces_out)
    {
      region_c *parent = FindIslandParent(R);

      ReplaceRegion(R, parent);
      
      mug_regions[i] = NULL; // kill it
      delete R;
    }
  }

  // remove the NULL pointers
  std::vector<region_c *>::iterator ENDP;

  ENDP = std::remove(mug_regions.begin(), mug_regions.end(), (region_c*)NULL);

  mug_regions.erase(ENDP, mug_regions.end());
}

static void Mug_AssignAreas(void)
{
  // @@
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
  //   (3) create regions from segs, remove islands
  //   (4) assign area_polys to the regions
  //   (5) perform merge (etc) operations

  for (int j=0; j < (int)all_polys.size(); j++)
  {
    area_poly_c *P = all_polys[j];
    SYS_ASSERT(P);

    Mug_MakeSegments(P);
  }

  Mug_FindOverlaps();
  Mug_TraceSegLoops();
  Mug_RemoveIslands();

  Mug_AssignAreas();
    
  // TODO
}

void CSG2_DumpSegmentsToWAD(void)
{
  /* debugging function */

  int total_vert = 0;

  std::vector<vertex_c *>::iterator VI;

  for (VI = mug_vertices.begin(); VI != mug_vertices.end(); VI++)
  {
    vertex_c *V = *VI;
    
    V->index = total_vert;
    total_vert++;

    wad::add_vertex(I_ROUND(V->x), I_ROUND(V->y));
  }


  std::vector<region_c *>::iterator RNI;

  for (RNI = mug_regions.begin(); RNI != mug_regions.end(); RNI++)
  {
    region_c *R = *RNI;

    R->index = (int)(RNI - mug_regions.begin());

    wad::add_sector(0, "FLAT1", 128, "FLAT1", 200, 0, 0);

    const char *tex = R->faces_out ? "COMPBLUE" : "STARTAN3";

    wad::add_sidedef(R->index, tex, "-", tex, 0, 0);
  }


  std::vector<segment_c *>::iterator SGI;

  for (SGI = mug_segments.begin(); SGI != mug_segments.end(); SGI++)
  {
    segment_c *S = *SGI;

    SYS_ASSERT(S);
    SYS_ASSERT(S->start);

    wad::add_linedef(S->start->index, S->end->index,
                     S->front ? S->front->index : -1,
                     S->back  ? S->back->index  : -1,
                     0, 1 /*impassible*/, 0,
                     NULL /* args */);
  }
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
