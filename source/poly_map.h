//------------------------------------------------------------------------
//
//  AJ-Polygonator
//  (C) 2021-2022 The OBSIDIAN Team
//  (C) 2000-2013 Andrew Apted
//
//  This library is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This library is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#ifndef __AJPOLY_MAP_H__
#define __AJPOLY_MAP_H__

#include "poly.h"

/* ----- OBJECTS --------------------------------- */

// a wall_tip is where a wall meets a vertex

class wall_tip_c
{
  public:
    // link in list.  List is kept in ANTI-clockwise order.
    wall_tip_c *next;
    wall_tip_c *prev;

    // angle that line makes at vertex (degrees).
    double angle;

    // sectors on each side of wall.  Left is the side of increasing
    // angles, right is the side of decreasing angles.  Either can be
    // NULL for one sided walls.
    ajpoly::sector_c *left;
    ajpoly::sector_c *right;
};

/* ----- VARIABLES --------------------------------- */

// map limits
extern int limit_x1, limit_y1;
extern int limit_x2, limit_y2;

// a special sector used to represent the void (empty space)
extern ajpoly::sector_c *void_sector;

/* ----- FUNCTIONS --------------------------------- */

ajpoly::vertex_c  *NewVertex();
ajpoly::linedef_c *NewLinedef();
ajpoly::sidedef_c *NewSidedef();
ajpoly::sector_c  *NewSector();
ajpoly::thing_c   *NewThing();

ajpoly::vertex_c  *NewSplit();
ajpoly::edge_c    *NewEdge();
ajpoly::polygon_c *NewPolygon();
wall_tip_c        *NewWallTip();

// return a new vertex (with correct wall_tip info) for the split that
// happens along the given edge at the given location.
ajpoly::vertex_c *NewVertexFromSplit(ajpoly::edge_c *E, double x, double y);

bool VerifyOuterLines();

#endif /* __AJPOLY_MAP_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
