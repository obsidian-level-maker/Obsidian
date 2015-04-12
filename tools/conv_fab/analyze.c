//------------------------------------------------------------------------
// ANALYZE : Analyzing level structures
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
#include "blockmap.h"
#include "level.h"
#include "reject.h"
#include "seg.h"
#include "structs.h"
#include "util.h"
#include "wad.h"


#define DEBUG_WALLTIPS   0
#define DEBUG_POLYOBJ    0
#define DEBUG_WINDOW_FX  0

#define POLY_BOX_SZ  10

// stuff needed from level.c (this file closely related)
extern vertex_t  ** lev_vertices;
extern linedef_t ** lev_linedefs;
extern sidedef_t ** lev_sidedefs;
extern sector_t  ** lev_sectors;

extern boolean_g lev_doing_normal;


/* ----- polyobj handling ----------------------------- */

static void MarkPolyobjSector(sector_t *sector)
{
  int i;
    
  if (! sector)
    return;

# if DEBUG_POLYOBJ
  PrintDebug("  Marking SECTOR %d\n", sector->index);
# endif

  /* already marked ? */
  if (sector->has_polyobj)
    return;

  /* mark all lines of this sector as precious, to prevent the sector
   * from being split.
   */ 
  sector->has_polyobj = TRUE;

  for (i = 0; i < num_linedefs; i++)
  {
    linedef_t *L = lev_linedefs[i];

    if ((L->right && L->right->sector == sector) ||
        (L->left && L->left->sector == sector))
    {
      L->is_precious = TRUE;
    }
  }
}

static void MarkPolyobjPoint(float_g x, float_g y)
{
  int i;
  int inside_count = 0;
 
  float_g best_dist = 999999;
  linedef_t *best_match = NULL;
  sector_t *sector = NULL;

  float_g x1, y1;
  float_g x2, y2;

  // -AJA- First we handle the "awkward" cases where the polyobj sits
  //       directly on a linedef or even a vertex.  We check all lines
  //       that intersect a small box around the spawn point.

  int bminx = (int) (x - POLY_BOX_SZ);
  int bminy = (int) (y - POLY_BOX_SZ);
  int bmaxx = (int) (x + POLY_BOX_SZ);
  int bmaxy = (int) (y + POLY_BOX_SZ);

  for (i = 0; i < num_linedefs; i++)
  {
    linedef_t *L = lev_linedefs[i];

    if (CheckLinedefInsideBox(bminx, bminy, bmaxx, bmaxy,
          (int) L->start->x, (int) L->start->y,
          (int) L->end->x, (int) L->end->y))
    {
#     if DEBUG_POLYOBJ
      PrintDebug("  Touching line was %d\n", L->index);
#     endif

      if (L->left)
        MarkPolyobjSector(L->left->sector);

      if (L->right)
        MarkPolyobjSector(L->right->sector);

      inside_count++;
    }
  }

  if (inside_count > 0)
    return;

  // -AJA- Algorithm is just like in DEU: we cast a line horizontally
  //       from the given (x,y) position and find all linedefs that
  //       intersect it, choosing the one with the closest distance.
  //       If the point is sitting directly on a (two-sided) line,
  //       then we mark the sectors on both sides.

  for (i = 0; i < num_linedefs; i++)
  {
    linedef_t *L = lev_linedefs[i];

    float_g x_cut;

    x1 = L->start->x;  y1 = L->start->y;
    x2 = L->end->x;    y2 = L->end->y;

    /* check vertical range */
    if (fabs(y2 - y1) < DIST_EPSILON)
      continue;

    if ((y > (y1 + DIST_EPSILON) && y > (y2 + DIST_EPSILON)) || 
        (y < (y1 - DIST_EPSILON) && y < (y2 - DIST_EPSILON)))
      continue;

    x_cut = x1 + (x2 - x1) * (y - y1) / (y2 - y1) - x;

    if (fabs(x_cut) < fabs(best_dist))
    {
      /* found a closer linedef */

      best_match = L;
      best_dist = x_cut;
    }
  }

  if (! best_match)
  {
    PrintWarn("Bad polyobj thing at (%1.0f,%1.0f).\n", x, y);
    return;
  }

  y1 = best_match->start->y;
  y2 = best_match->end->y;

# if DEBUG_POLYOBJ
  PrintDebug("  Closest line was %d Y=%1.0f..%1.0f (dist=%1.1f)\n",
      best_match->index, y1, y2, best_dist);
# endif

  /* sanity check: shouldn't be directly on the line */
# if DEBUG_POLYOBJ
  if (fabs(best_dist) < DIST_EPSILON)
  {
    PrintDebug("  Polyobj FAILURE: directly on the line (%d)\n",
        best_match->index);
  }
# endif
 
  /* check orientation of line, to determine which side the polyobj is
   * actually on.
   */
  if ((y1 > y2) == (best_dist > 0))
    sector = best_match->right ? best_match->right->sector : NULL;
  else
    sector = best_match->left ? best_match->left->sector : NULL;

# if DEBUG_POLYOBJ
  PrintDebug("  Sector %d contains the polyobj.\n", 
      sector ? sector->index : -1);
# endif

  if (! sector)
  {
    PrintWarn("Invalid Polyobj thing at (%1.0f,%1.0f).\n", x, y);
    return;
  }

  MarkPolyobjSector(sector);
}

//
// DetectPolyobjSectors
//
// Based on code courtesy of Janis Legzdinsh.
//
void DetectPolyobjSectors(void)
{
  int i;
  int hexen_style;

  // -JL- There's a conflict between Hexen polyobj thing types and Doom thing
  //      types. In Doom type 3001 is for Imp and 3002 for Demon. To solve
  //      this problem, first we are going through all lines to see if the
  //      level has any polyobjs. If found, we also must detect what polyobj
  //      thing types are used - Hexen ones or ZDoom ones. That's why we
  //      are going through all things searching for ZDoom polyobj thing
  //      types. If any found, we assume that ZDoom polyobj thing types are
  //      used, otherwise Hexen polyobj thing types are used.

  // -JL- First go through all lines to see if level contains any polyobjs
  for (i = 0; i < num_linedefs; i++)
  {
    linedef_t *L = lev_linedefs[i];

    if (L->type == HEXTYPE_POLY_START || L->type == HEXTYPE_POLY_EXPLICIT)
      break;
  }

  if (i == num_linedefs)
  {
    // -JL- No polyobjs in this level
    return;
  }

  // -JL- Detect what polyobj thing types are used - Hexen ones or ZDoom ones
  hexen_style = TRUE;
  
  for (i = 0; i < num_things; i++)
  {
    thing_t *T = LookupThing(i);

    if (T->type == ZDOOM_PO_SPAWN_TYPE || T->type == ZDOOM_PO_SPAWNCRUSH_TYPE)
    {
      // -JL- A ZDoom style polyobj thing found
      hexen_style = FALSE;
      break;
    }
  }

# if DEBUG_POLYOBJ
  PrintDebug("Using %s style polyobj things\n",
      hexen_style ? "HEXEN" : "ZDOOM");
# endif
   
  for (i = 0; i < num_things; i++)
  {
    thing_t *T = LookupThing(i);

    float_g x = (float_g) T->x;
    float_g y = (float_g) T->y;

    // ignore everything except polyobj start spots
    if (hexen_style)
    {
      // -JL- Hexen style polyobj things
      if (T->type != PO_SPAWN_TYPE && T->type != PO_SPAWNCRUSH_TYPE)
        continue;
    }
    else
    {
      // -JL- ZDoom style polyobj things
      if (T->type != ZDOOM_PO_SPAWN_TYPE && T->type != ZDOOM_PO_SPAWNCRUSH_TYPE)
        continue;
    }

#   if DEBUG_POLYOBJ
    PrintDebug("Thing %d at (%1.0f,%1.0f) is a polyobj spawner.\n", i, x, y);
#   endif
 
    MarkPolyobjPoint(x, y);
  }
}

/* ----- analysis routines ----------------------------- */

static int VertexCompare(const void *p1, const void *p2)
{
  int vert1 = ((const uint16_g *) p1)[0];
  int vert2 = ((const uint16_g *) p2)[0];

  vertex_t *A = lev_vertices[vert1];
  vertex_t *B = lev_vertices[vert2];

  if (vert1 == vert2)
    return 0;

  if ((int)A->x != (int)B->x)
    return (int)A->x - (int)B->x; 
  
  return (int)A->y - (int)B->y;
}

static int SidedefCompare(const void *p1, const void *p2)
{
  int comp;

  int side1 = ((const uint16_g *) p1)[0];
  int side2 = ((const uint16_g *) p2)[0];

  sidedef_t *A = lev_sidedefs[side1];
  sidedef_t *B = lev_sidedefs[side2];

  if (side1 == side2)
    return 0;

  // don't merge sidedefs on special lines
  if (A->on_special || B->on_special)
    return side1 - side2;

  if (A->sector != B->sector)
  {
    if (A->sector == NULL) return -1;
    if (B->sector == NULL) return +1;

    return (A->sector->index - B->sector->index);
  }

  if ((int)A->x_offset != (int)B->x_offset)
    return A->x_offset - (int)B->x_offset;

  if ((int)A->y_offset != B->y_offset)
    return (int)A->y_offset - (int)B->y_offset;

  // compare textures

  comp = memcmp(A->upper_tex, B->upper_tex, sizeof(A->upper_tex));
  if (comp) return comp;
  
  comp = memcmp(A->lower_tex, B->lower_tex, sizeof(A->lower_tex));
  if (comp) return comp;
  
  comp = memcmp(A->mid_tex, B->mid_tex, sizeof(A->mid_tex));
  if (comp) return comp;

  // sidedefs must be the same
  return 0;
}

void DetectDuplicateVertices(void)
{
  int i;
  uint16_g *array = UtilCalloc(num_vertices * sizeof(uint16_g));

  DisplayTicker();

  // sort array of indices
  for (i=0; i < num_vertices; i++)
    array[i] = i;
  
  qsort(array, num_vertices, sizeof(uint16_g), VertexCompare);

  // now mark them off
  for (i=0; i < num_vertices - 1; i++)
  {
    // duplicate ?
    if (VertexCompare(array + i, array + i+1) == 0)
    {
      vertex_t *A = lev_vertices[array[i]];
      vertex_t *B = lev_vertices[array[i+1]];

      // found a duplicate !
      B->equiv = A->equiv ? A->equiv : A;
    }
  }

  UtilFree(array);
}

void DetectDuplicateSidedefs(void)
{
  int i;
  uint16_g *array = UtilCalloc(num_sidedefs * sizeof(uint16_g));

  DisplayTicker();

  // sort array of indices
  for (i=0; i < num_sidedefs; i++)
    array[i] = i;
  
  qsort(array, num_sidedefs, sizeof(uint16_g), SidedefCompare);

  // now mark them off
  for (i=0; i < num_sidedefs - 1; i++)
  {
    // duplicate ?
    if (SidedefCompare(array + i, array + i+1) == 0)
    {
      sidedef_t *A = lev_sidedefs[array[i]];
      sidedef_t *B = lev_sidedefs[array[i+1]];

      // found a duplicate !
      B->equiv = A->equiv ? A->equiv : A;
    }
  }

  UtilFree(array);
}

void PruneLinedefs(void)
{
  int i;
  int new_num;

  DisplayTicker();

  // scan all linedefs
  for (i=0, new_num=0; i < num_linedefs; i++)
  {
    linedef_t *L = lev_linedefs[i];

    // handle duplicated vertices
    while (L->start->equiv)
    {
      L->start->ref_count--;
      L->start = L->start->equiv;
      L->start->ref_count++;
    }

    while (L->end->equiv)
    {
      L->end->ref_count--;
      L->end = L->end->equiv;
      L->end->ref_count++;
    }

    // handle duplicated sidedefs
    while (L->right && L->right->equiv)
    {
      L->right->ref_count--;
      L->right = L->right->equiv;
      L->right->ref_count++;
    }

    while (L->left && L->left->equiv)
    {
      L->left->ref_count--;
      L->left = L->left->equiv;
      L->left->ref_count++;
    }

    // remove zero length lines
    if (L->zero_len)
    {
      L->start->ref_count--;
      L->end->ref_count--;

      UtilFree(L);
      continue;
    }

    L->index = new_num;
    lev_linedefs[new_num++] = L;
  }

  if (new_num < num_linedefs)
  {
    PrintVerbose("Pruned %d zero-length linedefs\n", num_linedefs - new_num);
    num_linedefs = new_num;
  }

  if (new_num == 0)
    FatalError("Couldn't find any Linedefs");
}

void PruneVertices(void)
{
  int i;
  int new_num;
  int unused = 0;

  DisplayTicker();

  // scan all vertices
  for (i=0, new_num=0; i < num_vertices; i++)
  {
    vertex_t *V = lev_vertices[i];

    if (V->ref_count < 0)
      InternalError("Vertex %d ref_count is %d", i, V->ref_count);
    
    if (V->ref_count == 0)
    {
      if (V->equiv == NULL)
        unused++;

      UtilFree(V);
      continue;
    }

    V->index = new_num;
    lev_vertices[new_num++] = V;
  }

  if (new_num < num_vertices)
  {
    int dup_num = num_vertices - new_num - unused;

    if (unused > 0)
      PrintVerbose("Pruned %d unused vertices "
        "(this is normal if the nodes were built before)\n", unused);

    if (dup_num > 0)
      PrintVerbose("Pruned %d duplicate vertices\n", dup_num);

    num_vertices = new_num;
  }

  if (new_num == 0)
    FatalError("Couldn't find any Vertices");
 
  num_normal_vert = num_vertices;
}

void PruneSidedefs(void)
{
  int i;
  int new_num;
  int unused = 0;

  DisplayTicker();

  // scan all sidedefs
  for (i=0, new_num=0; i < num_sidedefs; i++)
  {
    sidedef_t *S = lev_sidedefs[i];

    if (S->ref_count < 0)
      InternalError("Sidedef %d ref_count is %d", i, S->ref_count);
    
    if (S->ref_count == 0)
    {
      if (S->sector)
        S->sector->ref_count--;

      if (S->equiv == NULL)
        unused++;

      UtilFree(S);
      continue;
    }

    S->index = new_num;
    lev_sidedefs[new_num++] = S;
  }

  if (new_num < num_sidedefs)
  {
    int dup_num = num_sidedefs - new_num - unused;

    if (unused > 0)
      PrintVerbose("Pruned %d unused sidedefs\n", unused);

    if (dup_num > 0)
      PrintVerbose("Pruned %d duplicate sidedefs\n", dup_num);

    num_sidedefs = new_num;
  }

  if (new_num == 0)
    FatalError("Couldn't find any Sidedefs");
}

void PruneSectors(void)
{
  int i;
  int new_num;

  DisplayTicker();

  // scan all sectors
  for (i=0, new_num=0; i < num_sectors; i++)
  {
    sector_t *S = lev_sectors[i];

    if (S->ref_count < 0)
      InternalError("Sector %d ref_count is %d", i, S->ref_count);
    
    if (S->ref_count == 0)
    {
      UtilFree(S);
      continue;
    }

    S->index = new_num;
    lev_sectors[new_num++] = S;
  }

  if (new_num < num_sectors)
  {
    PrintVerbose("Pruned %d unused sectors\n", num_sectors - new_num);
    num_sectors = new_num;
  }

  if (new_num == 0)
    FatalError("Couldn't find any Sectors");
}


//----------------------------------------------------------------------


static void Convert_Name(char *buf_8, const char *old_name, const char *new_name)
{
  int i;

  // check for match
  for (i = 0 ; i < 8 ; i++)
  {
    // terminator in original string?
    if ((unsigned char) buf_8[i] <= 32)
    {
      if (old_name[i] == 0)
        break;   // MATCH!
      else
        return;  // NO MATCH
    }

    // this handles NUL terminator in 'old_name' too
    if (toupper(buf_8[i]) != toupper(old_name[i]))
      return;  // NO MATCH
  }

  for (i = 0 ; i < 8 ; i++)
  {
    buf_8[i] = *new_name;

    if (new_name[i] != 0)
      new_name++;
  }
}


static void Convert_TexName(char *buf_8)
{
  Convert_Name(buf_8, "COMPBLUE", "_NOTHING");
  Convert_Name(buf_8, "STARTAN3", "_WALL");
  Convert_Name(buf_8, "BLAKWAL1", "_OUTER");
  Convert_Name(buf_8, "SFALL3",   "_LIQUID");
  Convert_Name(buf_8, "GRAY5",    "_FLOOR");
  Convert_Name(buf_8, "STARBR2",  "_CEIL");
}

static void Convert_Textures(void)
{
  int i;

  for (i = 0 ; i < num_sidedefs ; i++)
  {
    sidedef_t * W = LookupSidedef(i);

    Convert_TexName(W->upper_tex);
    Convert_TexName(W->lower_tex);
    Convert_TexName(W->mid_tex);
  }
}


static void Convert_FlatName(char *buf_8)
{
  Convert_Name(buf_8, "FWATER4",  "_NOTHING");
  Convert_Name(buf_8, "FLOOR5_3", "_WALL");
  Convert_Name(buf_8, "NUKAGE3",  "_LIQUID");
  Convert_Name(buf_8, "FLOOR0_6", "_FLOOR");
  Convert_Name(buf_8, "CEIL3_1",  "_CEIL");
}

static void Convert_Flats(void)
{
  int i;

  for (i = 0 ; i < num_sectors ; i++)
  {
    sector_t * S = LookupSector(i);

    Convert_FlatName(S->floor_tex);
    Convert_FlatName(S->ceil_tex);
  }
}


static int Convert_ThingNum(int id)
{
  switch (id)
  {
    case 3004 : return 8102;
    case 3002 : return 8103;
    case 3005 : return 8113;
    case 68   : return 8106;
    case 7    : return 8108;
    case 2015 : return 8151;
    case 2018 : return 8152;
    case 37   : return 8155;
    case 34   : return 8181;

    default: return id;
  }
}

static void Convert_Things(void)
{
  int i;

  for (i = 0 ; i < num_things ; i++)
  {
    thing_t * T = LookupThing(i);

    T->type = Convert_ThingNum(T->type);
  }
}


void DoConversions(void)
{
  Convert_Textures();
  Convert_Flats();
  Convert_Things();
}

