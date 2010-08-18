//------------------------------------------------------------------------
//  T-JUNCTION FIXING
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C)      2010 Andrew Apted
//  Copyright (C) 1996-1997 Id Software, Inc.
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
//
//  This employs same method as in Quake's qbsp tool:
//
//    -  use hash table to track 'infinite lines' which edges sit on.
//    -  for each infinite line, collect all vertices, then sort them.
//    -  for each edge of each face, find it's line and see if any
//       vertices would split the edge.
//
//------------------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"

#include "lib_file.h"
#include "lib_util.h"
#include "main.h"

#include "q_common.h"
#include "q_light.h"

#include "csg_main.h"
#include "csg_quake.h"


void QCOM_Fix_T_Junctions()
{
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
