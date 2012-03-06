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


// per-level variables

bool lev_doing_hexen;


#define LEVELARRAY(TYPE, BASEVAR, NAMESTR)  \
    container_tp<TYPE> BASEVAR(NAMESTR);

LEVELARRAY(vertex_c,  lev_vertices, "vertex")
LEVELARRAY(linedef_c, lev_linedefs, "linedef")
LEVELARRAY(sidedef_c, lev_sidedefs, "sidedef")
LEVELARRAY(sector_c,  lev_sectors,  "sector")
LEVELARRAY(thing_c,   lev_things,   "thing")



/* ----- reading routines ------------------------------ */

// forward decls
void GetLinedefsHexen(wad_c *base);
void GetThingsHexen(wad_c *base);

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


void GetVertices(wad_c *base)
{
  lump_c *lump = base->FindLumpInLevel("VERTEXES");
  int count = -1;

  if (lump)
  {
    base->CacheLump(lump);
    count = lump->length / sizeof(raw_vertex_t);
  }

# if DEBUG_LOAD
  PrintDebug("GetVertices: num = %d\n", count);
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


sector_c::sector_c(int _idx, const raw_sector_t *raw) :
            extrafloors(), ef_lines(), liquids()
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


void GetSectors(wad_c *base)
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
  PrintDebug("GetSectors: num = %d\n", count);
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

thing_c::thing_c(int _idx, const raw_hexen_thing_t *raw)
{
  index = _idx;

  x = SINT16(raw->x);
  y = SINT16(raw->y);

  type    = UINT16(raw->type);
  options = UINT16(raw->options);

  angle   = SINT16(raw->angle);
  height  = SINT16(raw->height);
}

thing_c::~thing_c()
{
}


void GetThings(wad_c *base)
{
  if (lev_doing_hexen)
  {
    GetThingsHexen(base);
    return;
  }
  
  int count = -1;
  lump_c *lump = base->FindLumpInLevel("THINGS");

  if (lump)
  {
    base->CacheLump(lump);
    count = lump->length / sizeof(raw_thing_t);
  }

  if (!lump || count == 0)
  {
    // Note: no error if no things exist, even though technically a map
    // will be unplayable without the player starts.
    PrintWarn("Couldn't find any Things");
    return;
  }

# if DEBUG_LOAD
  PrintDebug("GetThings: num = %d\n", count);
# endif

  lev_things.Allocate(count);

  raw_thing_t *raw = (raw_thing_t *) lump->data;

  for (int i = 0; i < count; i++, raw++)
  {
    lev_things.Set(i, new thing_c(i, raw));
  }
}


void GetThingsHexen(wad_c *base)
{
  int count = -1;
  lump_c *lump = base->FindLumpInLevel("THINGS");

  if (lump)
  {
    base->CacheLump(lump);
    count = lump->length / sizeof(raw_hexen_thing_t);
  }

  if (!lump || count == 0)
  {
    // Note: no error if no things exist, even though technically a map
    // will be unplayable without the player starts.
    PrintWarn("Couldn't find any Things");
    return;
  }

# if DEBUG_LOAD
  PrintDebug("GetThingsHexen: num = %d\n", count);
# endif

  lev_things.Allocate(count);

  raw_hexen_thing_t *raw = (raw_hexen_thing_t *) lump->data;

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

void GetSidedefs(wad_c *base)
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
  PrintDebug("GetSidedefs: num = %d\n", count);
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


linedef_c::linedef_c(int _idx, const raw_linedef_t *raw)
{
  index = _idx;

  start = lev_vertices.Get(UINT16(raw->start));
  end   = lev_vertices.Get(UINT16(raw->end));

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

linedef_c::linedef_c(int _idx, const raw_hexen_linedef_t *raw)
{
  index = _idx;

  start = lev_vertices.Get(UINT16(raw->start));
  end   = lev_vertices.Get(UINT16(raw->end));

  // check for zero-length line
  zero_len = (fabs(start->x - end->x) < DIST_EPSILON) && 
             (fabs(start->y - end->y) < DIST_EPSILON);

  flags = UINT16(raw->flags);
  type  = UINT8(raw->type);
  tag   = 0;

  /* read specials */
  for (int j = 0; j < 5; j++)
    specials[j] = UINT8(raw->specials[j]);

  // -JL- Added missing twosided flag handling that caused a broken reject
  two_sided = (flags & LINEFLAG_TWO_SIDED) ? true : false;

  right = SafeLookupSidedef(UINT16(raw->sidedef1));
  left  = SafeLookupSidedef(UINT16(raw->sidedef2));
}

linedef_c::~linedef_c()
{
}


void GetLinedefs(wad_c *base)
{
  if (lev_doing_hexen)
  {
    GetLinedefsHexen(base);
    return;
  }
  
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
  PrintDebug("GetLinedefs: num = %d\n", count);
# endif

  lev_linedefs.Allocate(count);

  raw_linedef_t *raw = (raw_linedef_t *) lump->data;

  for (int i = 0; i < count; i++, raw++)
  {
    lev_linedefs.Set(i, new linedef_c(i, raw));
  }
}

void GetLinedefsHexen(wad_c *base)
{
  int count = -1;
  lump_c *lump = base->FindLumpInLevel("LINEDEFS");

  if (lump)
  {
    base->CacheLump(lump);
    count = lump->length / sizeof(raw_hexen_linedef_t);
  }

  if (!lump || count == 0)
    FatalError("Couldn't find any Linedefs");

# if DEBUG_LOAD
  PrintDebug("GetLinedefsHexen: num = %d\n", count);
# endif

  lev_linedefs.Allocate(count);

  raw_hexen_linedef_t *raw = (raw_hexen_linedef_t *) lump->data;

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

  // -JL- Identify Hexen mode by presence of BEHAVIOR lump
  lev_doing_hexen = (the_wad->FindLumpInLevel("BEHAVIOR") != NULL);

  GetVertices(the_wad);
  GetSectors(the_wad);
  GetSidedefs(the_wad);
  GetLinedefs(the_wad);
  GetThings(the_wad);

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

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
