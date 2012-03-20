//------------------------------------------------------------------------
//  LEVEL : Level structure read/write functions.
//------------------------------------------------------------------------
//
//  Brusher (C) 2012 Andrew Apted
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

// this includes everything we need
#include "main.h"

#define DEBUG_LOAD      0
#define DEBUG_BSP       0


#define LEVELARRAY(TYPE, BASEVAR, NAMESTR)  \
    container_tp<TYPE> BASEVAR(NAMESTR);

LEVELARRAY(vertex_c,  lev_vertices, "vertex")
LEVELARRAY(linedef_c, lev_linedefs, "linedef")
LEVELARRAY(sidedef_c, lev_sidedefs, "sidedef")
LEVELARRAY(sector_c,  lev_sectors,  "sector")
LEVELARRAY(thing_c,   lev_things,   "thing")



/* ----- reading routines ------------------------------ */

vertex_c::vertex_c(int _idx, const raw_vertex_t *raw) : lines()
{
  index = _idx;

  x = (double) SINT16(raw->x);
  y = (double) SINT16(raw->y);
}

vertex_c::vertex_c(int _idx, const raw_v2_vertex_t *raw)
{
  index = _idx;

  x = (double) SINT32(raw->x) / 65536.0;
  y = (double) SINT32(raw->y) / 65536.0;
}

vertex_c::~vertex_c()
{
}

void vertex_c::AddLine(linedef_c *L)
{
  lines.push_back(L);
}


void LoadVertices(wad_c *base)
{
  lump_c *lump = base->FindLumpInLevel("VERTEXES");
  int count = -1;

  if (lump)
  {
    base->CacheLump(lump);
    count = lump->length / sizeof(raw_vertex_t);
  }

# if DEBUG_LOAD
  PrintDebug("LoadVertices: num = %d\n", count);
# endif

  if (!lump || count == 0)
    FatalError("Couldn't find any Vertices");

  lev_vertices.Allocate(count);

  raw_vertex_t *raw = (raw_vertex_t *) lump->data;

  for (int i = 0; i < count; i++, raw++)
  {
    lev_vertices.Set(i, new vertex_c(i, raw));
  }
}


sector_c::sector_c(int _idx, const raw_sector_t *raw)
{
  index = _idx;

  floor_h = SINT16(raw->floor_h);
  ceil_h  = SINT16(raw->ceil_h);

  // these are updated by FindSectorExtents
  floor_under = floor_h;
  ceil_over   = ceil_h;

  memcpy(floor_tex, raw->floor_tex, sizeof(floor_tex));
  memcpy(ceil_tex,  raw->ceil_tex,  sizeof(ceil_tex));

  // ensure NUL terminated
  floor_tex[8] = ceil_tex[8] = 0;

  light   = UINT16(raw->light);
  special = UINT16(raw->special);
  tag     = SINT16(raw->tag);
}

sector_c::~sector_c()
{
}


void LoadSectors(wad_c *base)
{
  int count = -1;
  lump_c *lump = base->FindLumpInLevel("SECTORS");

  if (lump)
  {
    base->CacheLump(lump);
    count = lump->length / sizeof(raw_sector_t);
  }

  if (!lump || count == 0)
    FatalError("Couldn't find any Sectors");

# if DEBUG_LOAD
  PrintDebug("LoadSectors: num = %d\n", count);
# endif

  lev_sectors.Allocate(count);

  raw_sector_t *raw = (raw_sector_t *) lump->data;

  for (int i = 0; i < count; i++, raw++)
  {
    lev_sectors.Set(i, new sector_c(i, raw));
  }
}

thing_c::thing_c(int _idx, const raw_thing_t *raw)
{
  index = _idx;

  x = SINT16(raw->x);
  y = SINT16(raw->y);

  type    = UINT16(raw->type);
  options = UINT16(raw->options);

  angle   = SINT16(raw->angle);
  height  = 0;
}

thing_c::~thing_c()
{
}


void LoadThings(wad_c *base)
{
  int count = -1;
  lump_c *lump = base->FindLumpInLevel("THINGS");

  if (lump)
  {
    base->CacheLump(lump);
    count = lump->length / sizeof(raw_thing_t);
  }

  if (!lump || count == 0)
    return;

# if DEBUG_LOAD
  PrintDebug("LoadThings: num = %d\n", count);
# endif

  lev_things.Allocate(count);

  raw_thing_t *raw = (raw_thing_t *) lump->data;

  for (int i = 0; i < count; i++, raw++)
  {
    lev_things.Set(i, new thing_c(i, raw));
  }
}


sidedef_c::sidedef_c(int _idx, const raw_sidedef_t *raw)
{
  index = _idx;

  sector = (SINT16(raw->sector) == -1) ? NULL :
    lev_sectors.Get(UINT16(raw->sector));

  x_offset = SINT16(raw->x_offset);
  y_offset = SINT16(raw->y_offset);

  memcpy(upper_tex, raw->upper_tex, sizeof(upper_tex));
  memcpy(lower_tex, raw->lower_tex, sizeof(lower_tex));
  memcpy(mid_tex,   raw->mid_tex,   sizeof(mid_tex));

  // ensure NUL terminated
  upper_tex[8] = lower_tex[8] = mid_tex[8] = 0;
}

sidedef_c::~sidedef_c()
{
}

void LoadSidedefs(wad_c *base)
{
  int count = -1;
  lump_c *lump = base->FindLumpInLevel("SIDEDEFS");

  if (lump)
  {
    base->CacheLump(lump);
    count = lump->length / sizeof(raw_sidedef_t);
  }

  if (!lump || count == 0)
    FatalError("Couldn't find any Sidedefs");

# if DEBUG_LOAD
  PrintDebug("LoadSidedefs: num = %d\n", count);
# endif

  lev_sidedefs.Allocate(count);

  raw_sidedef_t *raw = (raw_sidedef_t *) lump->data;

  for (int i = 0; i < count; i++, raw++)
  {
    lev_sidedefs.Set(i, new sidedef_c(i, raw));
  }
}

static sidedef_c *SafeLookupSidedef(uint16_g num)
{
  if (num == 0xFFFF)
    return NULL;

  if ((int)num >= lev_sidedefs.num && (sint16_g)(num) < 0)
    return NULL;

  return lev_sidedefs.Get(num);
}


linedef_c::linedef_c(int _idx, const raw_linedef_t *raw) :
  index(_idx), traced_sides(0)
{
  start = lev_vertices.Get(UINT16(raw->start));
    end = lev_vertices.Get(UINT16(raw->end));

  start->AddLine(this);
    end->AddLine(this);

  /* check for zero-length line */
  zero_len = (fabs(start->x - end->x) < DIST_EPSILON) && 
         (fabs(start->y - end->y) < DIST_EPSILON);

  flags = UINT16(raw->flags);
  type  = UINT16(raw->type);
  tag   = SINT16(raw->tag);

  two_sided = (flags & LINEFLAG_TWO_SIDED) ? true : false;

  right = SafeLookupSidedef(UINT16(raw->sidedef1));
  left  = SafeLookupSidedef(UINT16(raw->sidedef2));
}

linedef_c::~linedef_c()
{
}


void LoadLinedefs(wad_c *base)
{
  int count = -1;
  lump_c *lump = base->FindLumpInLevel("LINEDEFS");

  if (lump)
  {
    base->CacheLump(lump);
    count = lump->length / sizeof(raw_linedef_t);
  }

  if (!lump || count == 0)
    FatalError("Couldn't find any Linedefs");

# if DEBUG_LOAD
  PrintDebug("LoadLinedefs: num = %d\n", count);
# endif

  lev_linedefs.Allocate(count);

  raw_linedef_t *raw = (raw_linedef_t *) lump->data;

  for (int i = 0; i < count; i++, raw++)
  {
    lev_linedefs.Set(i, new linedef_c(i, raw));
  }
}



/* ----- whole-level routines --------------------------- */

void LoadLevel(const char *level_name)
{
  // ---- Normal stuff ----

  if (! the_wad->FindLevel(level_name))
    FatalError("Unable to find level: %s\n", level_name);

  LoadVertices(the_wad);
  LoadSectors(the_wad);
  LoadSidedefs(the_wad);
  LoadLinedefs(the_wad);
  LoadThings(the_wad);

/// PrintMsg("Loaded %d vertices, %d sectors, %d sides, %d lines, %d things\n", 
///     num_vertices, num_sectors, num_sidedefs, num_linedefs, num_things);

}

void FreeLevel(void)
{
  lev_vertices.FreeAll();
  lev_linedefs.FreeAll();
  lev_sidedefs.FreeAll();
  lev_sectors.FreeAll();
  lev_things.FreeAll();
}


/* ----- analysis stuff ------------------------------ */


lineloop_c::lineloop_c() :
	lines(), sides(), faces_outward(false)
{ }


lineloop_c::~lineloop_c()
{
	clear();
}


void lineloop_c::clear()
{
	lines.clear();
	sides.clear();

	faces_outward = false;
}


void lineloop_c::push_back(linedef_c * ld, int side)
{
	lines.push_back(ld);
	sides.push_back(side);
}


bool lineloop_c::get(linedef_c * ld, int side) const
{
	for (unsigned int k = 0 ; k < lines.size() ; k++)
		if (lines[k] == ld && sides[k] == side)
			return true;

	return false;
}


bool lineloop_c::get_just_line(linedef_c * ld) const
{
	for (unsigned int k = 0 ; k < lines.size() ; k++)
		if (lines[k] == ld)
			return true;

	return false;
}


int lineloop_c::IndexWithLowestX() const
{
  int best = -1;
  int best_x = 99999;
  int best_y = 99999;

	for (unsigned int i = 0 ; i < lines.size() ; i++)
  {
    int x = GetX(i);
    int y = GetY(i);

    if (best < 0 || x < best_x || (x == best_x && y < best_y))
    {
      best   = i;
      best_x = x;
      best_y = y;
    }
  }

  SYS_ASSERT(best >= 0);

  return best;
}


sector_c * lineloop_c::GetSector() const
{
  linedef_c *ld = lines[0];

  sidedef_c *sd = (sides[0] > 0 ? ld->right : ld->left);

  if (! sd)
    return NULL;

  return sd->sector;
}


vertex_c * lineloop_c::GetVertex(int index) const
{
  if (sides[index] < 0)
    return lines[index]->start;
  else
    return lines[index]->end;
}


int lineloop_c::GetX(int index) const
{
  return I_ROUND(GetVertex(index)->x);
}

int lineloop_c::GetY(int index) const
{
  return I_ROUND(GetVertex(index)->y);
}


void lineloop_c::GetProps(int index, char bkind, const char **tex)
{
    // use opposite side if it exists
    linedef_c *ld = lines[index];
    int side      = sides[index];

    if (! (ld->left && ld->right))
    {
      sidedef_c *sd = (ld->right ? ld->right : ld->left);

      SYS_ASSERT(sd);

      *tex = sd->mid_tex;
    }
    else
    {
      sidedef_c *sd = (side > 0 ? ld->left : ld->right);

      if (bkind == 'b')
        *tex = sd->upper_tex;
      else
        *tex = sd->lower_tex;
    }
}


void lineloop_c::MarkAsProcessed()
{
  for (unsigned int k = 0 ; k < lines.size() ; k++)
  {
    int mask = (sides[k] < 0 ? 2 : 1);

    lines[k]->traced_sides |= mask;
  }
}


double AngleBetweenLines(int ax, int ay, int bx, int by, int cx, int cy)
{
	int a_dx = bx - ax;
	int a_dy = by - ay;

	int c_dx = bx - cx;
	int c_dy = by - cy;

	double AB_angle = (a_dx == 0) ? (a_dy >= 0 ? 90 : -90) : atan2(a_dy, a_dx) * 180 / M_PI;
	double CB_angle = (c_dx == 0) ? (c_dy >= 0 ? 90 : -90) : atan2(c_dy, c_dx) * 180 / M_PI;

	double result = CB_angle - AB_angle;

	while (result >= 360.0)
		result -= 360.0;

	while (result < 0)
		result += 360.0;

	return result;
}


double AngleBetweenLines(const vertex_c *A,
                         const vertex_c *B,
                         const vertex_c *C)
{
  return AngleBetweenLines(A->x, A->y,  B->x, B->y,  C->x, C->y);
}


bool TraceLineLoop(linedef_c * ld, int side, lineloop_c& loop)
{
	loop.clear();

	vertex_c * cur_vert;
	vertex_c * prev_vert;

	if (side == SIDE_RIGHT)
	{
		cur_vert  = ld->end;
		prev_vert = ld->start;
	}
	else
	{
		cur_vert  = ld->start;
		prev_vert = ld->end;
	}

	vertex_c * final_vert = prev_vert;

#ifdef DEBUG_PATH
	fprintf(stderr, "TRACE PATH: line:%d  side:%d  cur:%d  final:%d\n",
			ld, side, cur_vert, final_vert);
#endif

	// compute the average angle
	double average_angle = 0;

	// add the starting line
	loop.push_back(ld, side);

	while (cur_vert != final_vert)
	{
		linedef_c * next_line = NULL;
		vertex_c  * next_vert = NULL;
		int next_side = 0;

		double best_angle = 9999;

		// Look for the next linedef in the path.  It's the linedef which
		// uses the current vertex, not the same as the current line, and
		// has the smallest interior angle.

		for (int n = 0 ; n < lev_linedefs.num ; n++)
		{
			linedef_c * N = lev_linedefs.Get(n);

			if (N->start != cur_vert && N->end != cur_vert)
				continue;

			if (N == ld)
				continue;

			vertex_c * other_vert;
			int which_side;

			if (N->start == cur_vert)
			{
				other_vert = N->end;
				which_side = SIDE_RIGHT;
			}
			else  // (N->end == cur_vert)
			{
				other_vert = N->start;
				which_side = SIDE_LEFT;
			}

			// found adjoining linedef

			double angle = AngleBetweenLines(prev_vert, cur_vert, other_vert);

			if (!next_line || angle < best_angle)
			{
				next_line = N;
				next_vert = other_vert;
				next_side = which_side;

				best_angle = angle;
			}

			// continue the search...
		}

#ifdef DEBUG_PATH
		fprintf(stderr, "PATH NEXT: line:%d  side:%d  vert:%d  angle:%1.6f\n",
				next_line, next_side, next_vert, best_angle);
#endif

		// No next line?  Path cannot be closed
		if (! next_line)
			return false;

		// Line already seen?  Under normal circumstances this won't
		// happen, but it _can_ happen and indicates a non-closed
		// structure
		if (loop.get_just_line(next_line))
			return false;

		ld   = next_line;
		side = next_side;

		prev_vert = cur_vert;
		cur_vert  = next_vert;

		average_angle += best_angle;

		// add the next line
		loop.push_back(ld, side);
	}

	// this might happen if there are overlapping linedefs
	if (loop.lines.size() < 3)
		return false;

	average_angle = average_angle / (double)loop.lines.size();

	loop.faces_outward = (average_angle >= 180.0);

#ifdef DEBUG_PATH
	fprintf(stderr, "PATH CLOSED!  average_angle:%1.2f\n", average_angle);
#endif

	return true;
}


linedef_c * ClosestLine(int x, int y, int *side)
{
  linedef_c * best_match = NULL;
	float       best_dist  = 9e9;

	for (int n = 0 ; n < lev_linedefs.num ; n++)
	{
    linedef_c *ld = lev_linedefs.Get(n);

		int ly1 = (int)ld->start->y;
		int ly2 = (int)ld->end->y;

		// does the linedef cross the horizontal ray?
		if ( (ly1 > y) == (ly2 > y) )
			continue;

		// ignore purely horizontal lines
		if (ly1 == ly2)
			continue;

		int lx1 = (int)ld->start->x;
		int lx2 = (int)ld->end->x;

		float dist = lx1 - x + (lx2 - lx1) * (y - ly1) / (float)(ly2 - ly1);

		if (fabs(dist) > 0.1 && fabs(dist) < best_dist)
		{
			best_match = ld;
			best_dist  = fabs(dist);

      if ( (ly1 > ly2) == (dist > 0) )
        *side = SIDE_RIGHT;
      else
        *side = SIDE_LEFT;
		}
	}

	return best_match;
}


sector_c * SectorAtPoint(int x, int y)
{
  int side;
  linedef_c *ld = ClosestLine(x, y, &side);

  if (! ld)
    return NULL;

  sidedef_c *sd = (side > 0) ? ld->right : ld->left;

  if (! sd)
    return NULL;

  return sd->sector;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
