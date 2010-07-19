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

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"

#include <algorithm>

#include "lib_util.h"
#include "main.h"

#include "csg_main.h"
#include "csg_local.h"
#include "g_lua.h"
#include "ui_dialog.h"


void CSG_SwallowBrushes()
{
  // check each region_c for redundant brushes, ones which are
  // completely surrounded by another brush (on the Z axis)

}


//------------------------------------------------------------------------

void CSG_Quantize()
{
  // mark segments and regions which become zero size as "degenerate".

  // a segment with a degenerate region on one side (after marking all
  // degenerates) needs to discover the new region, e.g. point test.
}


//------------------------------------------------------------------------

void CSG_FindGaps()
{
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
