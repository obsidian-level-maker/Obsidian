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
#include "node.h"
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

static INLINE_G int LineVertexLowest(const linedef_t *L)
{
  // returns the "lowest" vertex (normally the left-most, but if the
  // line is vertical, then the bottom-most) => 0 for start, 1 for end.

  return ((int)L->start->x < (int)L->end->x ||
          ((int)L->start->x == (int)L->end->x && 
           (int)L->start->y <  (int)L->end->y)) ? 0 : 1;
}

static int LineStartCompare(const void *p1, const void *p2)
{
  int line1 = ((const int *) p1)[0];
  int line2 = ((const int *) p2)[0];

  linedef_t *A = lev_linedefs[line1];
  linedef_t *B = lev_linedefs[line2];

  vertex_t *C;
  vertex_t *D;

  if (line1 == line2)
    return 0;

  // determine left-most vertex of each line
  C = LineVertexLowest(A) ? A->end : A->start;
  D = LineVertexLowest(B) ? B->end : B->start;

  if ((int)C->x != (int)D->x)
    return (int)C->x - (int)D->x; 

  return (int)C->y - (int)D->y;
}

static int LineEndCompare(const void *p1, const void *p2)
{
  int line1 = ((const int *) p1)[0];
  int line2 = ((const int *) p2)[0];

  linedef_t *A = lev_linedefs[line1];
  linedef_t *B = lev_linedefs[line2];

  vertex_t *C;
  vertex_t *D;

  if (line1 == line2)
    return 0;

  // determine right-most vertex of each line
  C = LineVertexLowest(A) ? A->start : A->end;
  D = LineVertexLowest(B) ? B->start : B->end;

  if ((int)C->x != (int)D->x)
    return (int)C->x - (int)D->x; 

  return (int)C->y - (int)D->y;
}

void DetectOverlappingLines(void)
{
  // Algorithm:
  //   Sort all lines by left-most vertex.
  //   Overlapping lines will then be near each other in this set.
  //   Note: does not detect partially overlapping lines.

  int i;

  int *array = UtilCalloc(num_linedefs * sizeof(int));

  DisplayTicker();

  // sort array of indices
  for (i=0; i < num_linedefs; i++)
    array[i] = i;
  
  qsort(array, num_linedefs, sizeof(int), LineStartCompare);

  for (i=0; i < num_linedefs - 1; i++)
  {
    int j;

    for (j = i+1; j < num_linedefs; j++)
    {
      if (LineStartCompare(array + i, array + j) != 0)
        break;

      if (LineEndCompare(array + i, array + j) == 0)
      {
        // found an overlap !
        FatalError("Linedefs #%d and #%d overlap.\n", array[i], array[j]);
      }
    }
  }

  UtilFree(array);
}


/* ----- vertex routines ------------------------------- */

static void VertexAddWallTip(vertex_t *vert, float_g dx, float_g dy,
  sector_t *left, sector_t *right)
{
  wall_tip_t *tip = NewWallTip();
  wall_tip_t *after;

  tip->angle = UtilComputeAngle(dx, dy);
  tip->left  = left;
  tip->right = right;

  // find the correct place (order is increasing angle)
  for (after=vert->tip_set; after && after->next; after=after->next)
  { }

  while (after && tip->angle + ANG_EPSILON < after->angle) 
    after = after->prev;
  
  // link it in
  tip->next = after ? after->next : vert->tip_set;
  tip->prev = after;

  if (after)
  {
    if (after->next)
      after->next->prev = tip;
    
    after->next = tip;
  }
  else
  {
    if (vert->tip_set)
      vert->tip_set->prev = tip;
    
    vert->tip_set = tip;
  }
}

void CalculateWallTips(void)
{
  int i;

  DisplayTicker();

  for (i=0; i < num_linedefs; i++)
  {
    linedef_t *line = lev_linedefs[i];

    float_g x1 = line->start->x;
    float_g y1 = line->start->y;
    float_g x2 = line->end->x;
    float_g y2 = line->end->y;

    sector_t *right = (line->right) ? line->right->sector : void_sector;
    sector_t *left  = (line->left)  ? line->left->sector  : (line->is_border ? NULL : void_sector);

    VertexAddWallTip(line->start, x2-x1, y2-y1, left, right);
    VertexAddWallTip(line->end,   x1-x2, y1-y2, right, left);
  }
 
# if DEBUG_WALLTIPS
  for (i=0; i < num_vertices; i++)
  {
    vertex_t *vert = LookupVertex(i);
    wall_tip_t *tip;

    PrintDebug("WallTips for vertex %d:\n", i);

    for (tip=vert->tip_set; tip; tip=tip->next)
    {
      PrintDebug("  Angle=%1.1f left=%d right=%d\n", tip->angle,
        tip->left ? tip->left->index : -1,
        tip->right ? tip->right->index : -1);
    }
  }
# endif
}

//
// NewVertexFromSplitSeg
//
vertex_t *NewVertexFromSplitSeg(seg_t *seg, float_g x, float_g y)
{
  vertex_t *vert = NewVertex();

  vert->x = x;
  vert->y = y;

  vert->ref_count = seg->partner ? 4 : 2;

  {
    vert->index = num_gl_vert | IS_GL_VERTEX;
    num_gl_vert++;
  }

  // compute wall_tip info

  VertexAddWallTip(vert, -seg->pdx, -seg->pdy, seg->sector, 
      seg->partner ? seg->partner->sector : NULL);

  VertexAddWallTip(vert, seg->pdx, seg->pdy,
      seg->partner ? seg->partner->sector : NULL, seg->sector);

  // create a duplex vertex if needed

  return vert;
}

//
// NewVertexDegenerate
//
vertex_t *NewVertexDegenerate(vertex_t *start, vertex_t *end)
{
  float_g dx = end->x - start->x;
  float_g dy = end->y - start->y;

  float_g dlen = UtilComputeDist(dx, dy);

  vertex_t *vert = NewVertex();

  vert->ref_count = start->ref_count;

  {
    vert->index = num_gl_vert | IS_GL_VERTEX;
    num_gl_vert++;
  }

  // compute new coordinates

  vert->x = start->x;
  vert->y = start->x;

  if (dlen == 0)
    InternalError("NewVertexDegenerate: bad delta !");

  dx /= dlen;
  dy /= dlen;

  while (I_ROUND(vert->x) == I_ROUND(start->x) && 
         I_ROUND(vert->y) == I_ROUND(start->y))
  {
    vert->x += dx;
    vert->y += dy;
  }

  return vert;
}

//
// VertexCheckOpen
//
sector_t * VertexCheckOpen(vertex_t *vert, float_g dx, float_g dy)
{
  wall_tip_t *tip;

  angle_g angle = UtilComputeAngle(dx, dy);

  // first check whether there's a wall_tip that lies in the exact
  // direction of the given direction (which is relative to the
  // vertex).

  for (tip=vert->tip_set; tip; tip=tip->next)
  {
    if (fabs(tip->angle - angle) < ANG_EPSILON ||
        fabs(tip->angle - angle) > (360.0 - ANG_EPSILON))
    {
      // yes, found one
      return NULL;
    }
  }

  // OK, now just find the first wall_tip whose angle is greater than
  // the angle we're interested in.  Therefore we'll be on the RIGHT
  // side of that wall_tip.

  for (tip=vert->tip_set; tip; tip=tip->next)
  {
    if (angle + ANG_EPSILON < tip->angle)
    {
      // found it
      return tip->right;
    }

    if (! tip->next)
    {
      // no more tips, thus we must be on the LEFT side of the tip
      // with the largest angle.

      return tip->left;
    }
  }
 
  InternalError("Vertex %d has no tips !", vert->index);
  return FALSE;
}

