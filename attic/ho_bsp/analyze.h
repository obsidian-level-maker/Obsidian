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

#ifndef __GLBSP_ANALYZE_H__
#define __GLBSP_ANALYZE_H__

#include "structs.h"
#include "level.h"


void DetermineMapLimits(void);

int CheckLinedefInsideBox(int xmin, int ymin, int xmax, int ymax,
    int x1, int y1, int x2, int y2);


// detection routines
void DetectDuplicateVertices(void);
void DetectOverlappingLines(void);


// computes the wall tips for all of the vertices
void CalculateWallTips(void);

// return a new vertex (with correct wall_tip info) for the split that
// happens along the given seg at the given location.
//
vertex_t *NewVertexFromSplitSeg(seg_t *seg, double x, double y);

// check whether a line with the given delta coordinates and beginning
// at this vertex is open.  Returns a sector reference if it's open,
// or NULL if closed (void space or directly along a linedef).
//
sector_t * VertexCheckOpen(vertex_t *vert, double dx, double dy);

#endif /* __GLBSP_ANALYZE_H__ */
