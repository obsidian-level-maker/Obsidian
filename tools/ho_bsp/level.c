//------------------------------------------------------------------------
// LEVEL : Level structure read/write functions.
//------------------------------------------------------------------------
//
//  GL-Friendly Node Builder (C) 2000-2007 Andrew Apted
//
//  Based on 'BSP 2.3' by Colin Reed, Lee Killough and others.
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

#include "system.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <ctype.h>
#include <math.h>
#include <limits.h>
#include <assert.h>

#include "analyze.h"
#include "level.h"
#include "node.h"
#include "seg.h"
#include "structs.h"
#include "util.h"
#include "wad.h"


#define DEBUG_LOAD      0
#define DEBUG_BSP       0

#define ALLOC_BLKNUM  1024


// per-level variables

boolean_g lev_doing_hexen;

sector_t * void_sector;


#define LEVELARRAY(TYPE, BASEVAR, NUMVAR)  \
    TYPE ** BASEVAR = NULL;  \
    int NUMVAR = 0;


LEVELARRAY(vertex_t,  lev_vertices,   num_vertices)
LEVELARRAY(linedef_t, lev_linedefs,   num_linedefs)
LEVELARRAY(sidedef_t, lev_sidedefs,   num_sidedefs)
LEVELARRAY(sector_t,  lev_sectors,    num_sectors)
LEVELARRAY(thing_t,   lev_things,     num_things)

static LEVELARRAY(seg_t,     segs,       num_segs)
static LEVELARRAY(subsec_t,  subsecs,    num_subsecs)
static LEVELARRAY(wall_tip_t,wall_tips,  num_wall_tips)


int num_normal_vert = 0;
int num_gl_vert = 0;
int num_complete_seg = 0;


/* ----- allocation routines ---------------------------- */

#define ALLIGATOR(TYPE, BASEVAR, NUMVAR)  \
{  \
  if ((NUMVAR % ALLOC_BLKNUM) == 0)  \
  {  \
    BASEVAR = UtilRealloc(BASEVAR, (NUMVAR + ALLOC_BLKNUM) *   \
        sizeof(TYPE *));  \
  }  \
  BASEVAR[NUMVAR] = (TYPE *) UtilCalloc(sizeof(TYPE));  \
  NUMVAR += 1;  \
  return BASEVAR[NUMVAR - 1];  \
}


vertex_t *NewVertex(void)
  ALLIGATOR(vertex_t, lev_vertices, num_vertices)

linedef_t *NewLinedef(void)
  ALLIGATOR(linedef_t, lev_linedefs, num_linedefs)

sidedef_t *NewSidedef(void)
  ALLIGATOR(sidedef_t, lev_sidedefs, num_sidedefs)

sector_t *NewSector(void)
  ALLIGATOR(sector_t, lev_sectors, num_sectors)

thing_t *NewThing(void)
  ALLIGATOR(thing_t, lev_things, num_things)

seg_t *NewSeg(void)
  ALLIGATOR(seg_t, segs, num_segs)

subsec_t *NewSubsec(void)
  ALLIGATOR(subsec_t, subsecs, num_subsecs)

wall_tip_t *NewWallTip(void)
  ALLIGATOR(wall_tip_t, wall_tips, num_wall_tips)


/* ----- free routines ---------------------------- */

#define FREEMASON(TYPE, BASEVAR, NUMVAR)  \
{  \
  int i;  \
  for (i=0; i < NUMVAR; i++)  \
    UtilFree(BASEVAR[i]);  \
  if (BASEVAR)  \
    UtilFree(BASEVAR);  \
  BASEVAR = NULL; NUMVAR = 0;  \
}


void FreeVertices(void)
  FREEMASON(vertex_t, lev_vertices, num_vertices)

void FreeLinedefs(void)
  FREEMASON(linedef_t, lev_linedefs, num_linedefs)

void FreeSidedefs(void)
  FREEMASON(sidedef_t, lev_sidedefs, num_sidedefs)

void FreeSectors(void)
  FREEMASON(sector_t, lev_sectors, num_sectors)

void FreeThings(void)
  FREEMASON(thing_t, lev_things, num_things)

void FreeSegs(void)
  FREEMASON(seg_t, segs, num_segs)

void FreeSubsecs(void)
  FREEMASON(subsec_t, subsecs, num_subsecs)

void FreeWallTips(void)
  FREEMASON(wall_tip_t, wall_tips, num_wall_tips)


/* ----- lookup routines ------------------------------ */

#define LOOKERUPPER(BASEVAR, NUMVAR, NAMESTR)  \
{  \
  if (index < 0 || index >= NUMVAR)  \
    FatalError("No such %s number #%d", NAMESTR, index);  \
    \
  return BASEVAR[index];  \
}

vertex_t *LookupVertex(int index)
  LOOKERUPPER(lev_vertices, num_vertices, "vertex")

linedef_t *LookupLinedef(int index)
  LOOKERUPPER(lev_linedefs, num_linedefs, "linedef")
  
sidedef_t *LookupSidedef(int index)
  LOOKERUPPER(lev_sidedefs, num_sidedefs, "sidedef")
  
sector_t *LookupSector(int index)
  LOOKERUPPER(lev_sectors, num_sectors, "sector")
  
thing_t *LookupThing(int index)
  LOOKERUPPER(lev_things, num_things, "thing")
  
seg_t *LookupSeg(int index)
  LOOKERUPPER(segs, num_segs, "seg")
  
subsec_t *LookupSubsec(int index)
  LOOKERUPPER(subsecs, num_subsecs, "subsector")
  

/* ----- reading routines ------------------------------ */


//
// GetVertices
//
static void GetVertices(void)
{
  int i, count=-1;
  raw_vertex_t *raw;
  lump_t *lump = FindLevelLump("VERTEXES");

  if (lump)
    count = lump->length / sizeof(raw_vertex_t);

  DisplayTicker();

# if DEBUG_LOAD
  PrintDebug("GetVertices: num = %d\n", count);
# endif

  if (!lump || count == 0)
    FatalError("Couldn't find any Vertices");

  raw = (raw_vertex_t *) lump->data;

  for (i=0; i < count; i++, raw++)
  {
    vertex_t *vert = NewVertex();

    vert->x = (double) SINT16(raw->x);
    vert->y = (double) SINT16(raw->y);

    vert->index = i;
  }

  num_normal_vert = num_vertices;
  num_gl_vert = 0;
  num_complete_seg = 0;
}

//
// GetSectors
//
static void GetSectors(void)
{
  int i, count=-1;
  raw_sector_t *raw;
  lump_t *lump = FindLevelLump("SECTORS");

  if (lump)
    count = lump->length / sizeof(raw_sector_t);

  if (!lump || count == 0)
    FatalError("Couldn't find any Sectors");

  DisplayTicker();

# if DEBUG_LOAD
  PrintDebug("GetSectors: num = %d\n", count);
# endif

  raw = (raw_sector_t *) lump->data;

  for (i=0; i < count; i++, raw++)
  {
    sector_t *sector = NewSector();

    sector->floor_h = SINT16(raw->floor_h);
    sector->ceil_h  = SINT16(raw->ceil_h);

    memcpy(sector->floor_tex, raw->floor_tex, sizeof(sector->floor_tex));
    memcpy(sector->ceil_tex,  raw->ceil_tex,  sizeof(sector->ceil_tex));

    sector->light = UINT16(raw->light);
    sector->special = UINT16(raw->special);
    sector->tag = SINT16(raw->tag);

    /* sector indices never change */
    sector->index = i;

    sector->warned_facing = -1;
  }

  /* HO-BSP : create dummy sector for VOID space */

  void_sector = NewSector();

  void_sector->index = 0xffff;
}

//
// GetThings
//
static void GetThings(void)
{
  int i, count=-1;
  raw_thing_t *raw;
  lump_t *lump = FindLevelLump("THINGS");

  if (lump)
    count = lump->length / sizeof(raw_thing_t);

  if (!lump || count == 0)
    return;

  DisplayTicker();

# if DEBUG_LOAD
  PrintDebug("GetThings: num = %d\n", count);
# endif

  raw = (raw_thing_t *) lump->data;

  for (i=0; i < count; i++, raw++)
  {
    thing_t *thing = NewThing();

    thing->x = SINT16(raw->x);
    thing->y = SINT16(raw->y);

    thing->type = UINT16(raw->type);
    thing->options = UINT16(raw->options);

    thing->index = i;
  }
}

//
// GetThingsHexen
//
static void GetThingsHexen(void)
{
  int i, count=-1;
  raw_hexen_thing_t *raw;
  lump_t *lump = FindLevelLump("THINGS");

  if (lump)
    count = lump->length / sizeof(raw_hexen_thing_t);

  if (!lump || count == 0)
    return;

  DisplayTicker();

# if DEBUG_LOAD
  PrintDebug("GetThingsHexen: num = %d\n", count);
# endif

  raw = (raw_hexen_thing_t *) lump->data;

  for (i=0; i < count; i++, raw++)
  {
    thing_t *thing = NewThing();

    thing->x = SINT16(raw->x);
    thing->y = SINT16(raw->y);

    thing->type = UINT16(raw->type);
    thing->options = UINT16(raw->options);

    thing->index = i;
  }
}

//
// GetSidedefs
//
static void GetSidedefs(void)
{
  int i, count=-1;
  raw_sidedef_t *raw;
  lump_t *lump = FindLevelLump("SIDEDEFS");

  if (lump)
    count = lump->length / sizeof(raw_sidedef_t);

  if (!lump || count == 0)
    FatalError("Couldn't find any Sidedefs");

  DisplayTicker();

# if DEBUG_LOAD
  PrintDebug("GetSidedefs: num = %d\n", count);
# endif

  raw = (raw_sidedef_t *) lump->data;

  for (i=0; i < count; i++, raw++)
  {
    sidedef_t *side = NewSidedef();

    if (SINT16(raw->sector) == -1)
      FatalError("Missing sector ref in sidedef #%d\n", i);

    side->sector = LookupSector(UINT16(raw->sector));
    side->sector->ref_count++;

    side->x_offset = SINT16(raw->x_offset);
    side->y_offset = SINT16(raw->y_offset);

    memcpy(side->upper_tex, raw->upper_tex, sizeof(side->upper_tex));
    memcpy(side->lower_tex, raw->lower_tex, sizeof(side->lower_tex));
    memcpy(side->mid_tex,   raw->mid_tex,   sizeof(side->mid_tex));

    /* sidedef indices never change */
    side->index = i;
  }
}

static INLINE_G sidedef_t *SafeLookupSidedef(uint16_g num)
{
  if (num == 0xFFFF)
    return NULL;

  if ((int)num >= num_sidedefs && (sint16_g)(num) < 0)
    return NULL;

  return LookupSidedef(num);
}

//
// GetLinedefs
//
static void GetLinedefs(void)
{
  int i, count=-1;
  raw_linedef_t *raw;
  lump_t *lump = FindLevelLump("LINEDEFS");

  if (lump)
    count = lump->length / sizeof(raw_linedef_t);

  if (!lump || count == 0)
    FatalError("Couldn't find any Linedefs");

  DisplayTicker();

# if DEBUG_LOAD
  PrintDebug("GetLinedefs: num = %d\n", count);
# endif

  raw = (raw_linedef_t *) lump->data;

  for (i=0; i < count; i++, raw++)
  {
    linedef_t *line;

    vertex_t *start = LookupVertex(UINT16(raw->start));
    vertex_t *end   = LookupVertex(UINT16(raw->end));

    start->ref_count++;
    end->ref_count++;

    line = NewLinedef();

    line->start = start;
    line->end   = end;

    /* check for zero-length line */
    if ( (fabs(start->x - end->x) < DIST_EPSILON) && 
         (fabs(start->y - end->y) < DIST_EPSILON) )
    {
      FatalError("Linedef #%d has zero length.", i);
    }

    line->flags = UINT16(raw->flags);
    line->type = UINT16(raw->type);
    line->tag  = SINT16(raw->tag);

    line->two_sided = (line->flags & LINEFLAG_TWO_SIDED) ? TRUE : FALSE;

    line->right = SafeLookupSidedef(UINT16(raw->sidedef1));
    line->left  = SafeLookupSidedef(UINT16(raw->sidedef2));

    if (line->right)
    {
      line->right->ref_count++;
      line->right->on_special |= (line->type > 0) ? 1 : 0;
    }

    if (line->left)
    {
      line->left->ref_count++;
      line->left->on_special |= (line->type > 0) ? 1 : 0;
    }

    line->index = i;
  }
}

//
// GetLinedefsHexen
//
static void GetLinedefsHexen(void)
{
  int i, j, count=-1;
  raw_hexen_linedef_t *raw;
  lump_t *lump = FindLevelLump("LINEDEFS");

  if (lump)
    count = lump->length / sizeof(raw_hexen_linedef_t);

  if (!lump || count == 0)
    FatalError("Couldn't find any Linedefs");

  DisplayTicker();

# if DEBUG_LOAD
  PrintDebug("GetLinedefsHexen: num = %d\n", count);
# endif

  raw = (raw_hexen_linedef_t *) lump->data;

  for (i=0; i < count; i++, raw++)
  {
    linedef_t *line;

    vertex_t *start = LookupVertex(UINT16(raw->start));
    vertex_t *end   = LookupVertex(UINT16(raw->end));

    start->ref_count++;
    end->ref_count++;

    line = NewLinedef();

    line->start = start;
    line->end   = end;

    /* check for zero-length line */
    if ( (fabs(start->x - end->x) < DIST_EPSILON) && 
         (fabs(start->y - end->y) < DIST_EPSILON) )
    {
      FatalError("Linedef #%d has zero length.", i);
    }

    line->flags = UINT16(raw->flags);
    line->type = UINT8(raw->type);
    line->tag  = 0;

    /* read specials */
    for (j=0; j < 5; j++)
      line->specials[j] = UINT8(raw->specials[j]);

    // -JL- Added missing twosided flag handling that caused a broken reject
    line->two_sided = (line->flags & LINEFLAG_TWO_SIDED) ? TRUE : FALSE;

    line->right = SafeLookupSidedef(UINT16(raw->sidedef1));
    line->left  = SafeLookupSidedef(UINT16(raw->sidedef2));

    // -JL- Added missing sidedef handling that caused all sidedefs to be pruned
    if (line->right)
    {
      line->right->ref_count++;
      line->right->on_special |= (line->type > 0) ? 1 : 0;
    }

    if (line->left)
    {
      line->left->ref_count++;
      line->left->on_special |= (line->type > 0) ? 1 : 0;
    }

    line->index = i;
  }
}


static INLINE_G int TransformSegDist(const seg_t *seg)
{
  double sx = seg->side ? seg->linedef->end->x : seg->linedef->start->x;
  double sy = seg->side ? seg->linedef->end->y : seg->linedef->start->y;

  return (int) ceil(UtilComputeDist(seg->start->x - sx, seg->start->y - sy));
}

static INLINE_G int TransformAngle(angle_g angle)
{
  int result;
  
  result = (int)(angle * 65536.0 / 360.0);
  
  if (result < 0)
    result += 65536;

  return (result & 0xFFFF);
}

static int SegCompare(const void *p1, const void *p2)
{
  const seg_t *A = ((const seg_t **) p1)[0];
  const seg_t *B = ((const seg_t **) p2)[0];

  if (A->index < 0)
    InternalError("Seg %p never reached a subsector !", A);

  if (B->index < 0)
    InternalError("Seg %p never reached a subsector !", B);

  return (A->index - B->index);
}


/* ----- writing routines ------------------------------ */

static const uint8_g *lev_v2_magic = (uint8_g *) "gNd2";


static void PutVertices(void)
{
  int count, i;
  lump_t *lump;

  DisplayTicker();

  lump = CreateGLLump("HO_VERT");

  AppendLevelLump(lump, lev_v2_magic, 4);

  for (i=0, count=0; i < num_vertices; i++)
  {
    raw_v2_vertex_t raw;
    vertex_t *vert = lev_vertices[i];

    if (! (vert->index & IS_GL_VERTEX))
      continue;

    raw.x = SINT32((int)(vert->x * 65536.0));
    raw.y = SINT32((int)(vert->y * 65536.0));

    AppendLevelLump(lump, &raw, sizeof(raw));

    count++;
  }

  if (count != num_gl_vert)
    InternalError("PutVertices miscounted (%d != %d)", count,
      num_gl_vert);
}


static INLINE_G uint16_g VertexIndex16Bit(const vertex_t *v)
{
  if (v->index & IS_GL_VERTEX)
    return (uint16_g) ((v->index & ~IS_GL_VERTEX) | 0x8000U);

  return (uint16_g) v->index;
}

static INLINE_G uint32_g VertexIndex32BitV5(const vertex_t *v)
{
  if (v->index & IS_GL_VERTEX)
    return (uint32_g) ((v->index & ~IS_GL_VERTEX) | 0x80000000U);

  return (uint32_g) v->index;
}


static void PutSegs(void)
{
  int i, count;
  lump_t *lump = CreateGLLump("HO_SEGS");

  DisplayTicker();

  // sort segs into ascending index
  qsort(segs, num_segs, sizeof(seg_t *), SegCompare);

  for (i=0, count=0; i < num_segs; i++)
  {
    raw_gl_seg_t raw;
    seg_t *seg = segs[i];

    raw.start = UINT16(VertexIndex16Bit(seg->start));
    raw.end   = UINT16(VertexIndex16Bit(seg->end));
    raw.side  = UINT16(seg->side);

    if (seg->linedef)
      raw.linedef = UINT16(seg->linedef->index);
    else
      raw.linedef = UINT16(0xFFFF);

    if (seg->partner)
      raw.partner = UINT16(seg->partner->index);
    else
      raw.partner = UINT16(0xFFFF);

    AppendLevelLump(lump, &raw, sizeof(raw));

    count++;

#   if DEBUG_BSP
    PrintDebug("PUT GL SEG: %04X  Line %04X %s  Partner %04X  "
      "(%1.1f,%1.1f) -> (%1.1f,%1.1f)\n", seg->index, UINT16(raw.linedef), 
      seg->side ? "L" : "R", UINT16(raw.partner),
      seg->start->x, seg->start->y, seg->end->x, seg->end->y);
#   endif
  }

  if (count != num_complete_seg)
    InternalError("PutSegs miscounted (%d != %d)", count,
      num_complete_seg);
}


static void PutSubsecs(void)
{
  int i;
  lump_t *lump;

  DisplayTicker();

  lump = CreateGLLump("HO_SSECT");

  for (i=0; i < num_subsecs; i++)
  {
    raw_subsec_t raw;
    subsec_t *sub = subsecs[i];

    raw.sector = UINT16(sub->sector->index);
    raw.first  = UINT16(sub->seg_list->index);
    raw.num    = UINT16(sub->seg_count);

    AppendLevelLump(lump, &raw, sizeof(raw));

#   if DEBUG_BSP
    PrintDebug("PUT SUBSEC %04X  First %04X  Num %04X\n",
      sub->index, UINT16(raw.first), UINT16(raw.num));
#   endif
  }
}


/* ----- whole-level routines --------------------------- */

//
// LoadLevel
//
void LoadLevel(void)
{
  char *message;

  const char *level_name = GetLevelName();

  // -JL- Identify Hexen mode by presence of BEHAVIOR lump
  lev_doing_hexen = (FindLevelLump("BEHAVIOR") != NULL);

  message = UtilFormat("Building Hobbs on %s%s",
       level_name, lev_doing_hexen ? " (Hexen)" : "");
 
  lev_doing_hexen |= cur_info->force_hexen;

  DisplaySetBarText(1, message);

  PrintVerbose("\n\n");
  PrintMsg("%s\n", message);
  PrintVerbose("\n");

  UtilFree(message);

  GetVertices();
  GetSectors();
  GetSidedefs();

  if (lev_doing_hexen)
  {
    GetLinedefsHexen();
    GetThingsHexen();
  }
  else
  {
    GetLinedefs();
    GetThings();
  }

  PrintVerbose("Loaded %d vertices, %d sectors, %d sides, %d lines, %d things\n", 
      num_vertices, num_sectors, num_sidedefs, num_linedefs, num_things);

  DetectOverlappingLines();
  DetectDuplicateVertices();

  CalculateWallTips();
}

//
// FreeLevel
//
void FreeLevel(void)
{
  FreeVertices();
  FreeSidedefs();
  FreeLinedefs();
  FreeSectors();
  FreeThings();
  FreeSegs();
  FreeSubsecs();
  FreeWallTips();
}


//
// SaveLevel
//
void SaveLevel(void)
{
  if (num_normal_vert > 32767 || num_gl_vert > 32767)
  {
    FatalError("Vertex overflow!");
  }

  if (num_segs > 65534)
  {
    FatalError("Seg overflow!");
  }

  PutVertices();
  PutSegs();
  PutSubsecs();
}

