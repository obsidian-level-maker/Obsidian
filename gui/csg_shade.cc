//------------------------------------------------------------------------
//  DOOM SHADING / LIGHTING
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2013 Andrew Apted
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
#include "hdr_ui.h"

#include "csg_main.h"
#include "csg_local.h"

/*

Doom Lighting Model
-------------------

1. light comes from surfaces or entities

2. result value is MAXIMUM of all tests made 

3. (a) sky ceiling is like a light of 184 units
   (b) if diagonal vector (4,1,2) from floor can hit sky, light is 208
   (c) these tests are skipped for night skies

4. a "sector" is a group of brush regions
   [exactly how to group them is yet to be determined...]

5. sectors perform lighting tests at various points in sector
   (most basic: middle point of each region).  Further distance
   means lower light level [equation yet to be determined...]

6. clamp results to a certain minimum (e.g. 96).

*/


static void SHADE_LightRegion(region_c *R)
{
  // ignore solid areas
  if (R->gaps.size() == 0)
    return;

  // TEST CRUD:

  R->shade = 144 + 16 * ((rand() & 255) % 5);
}


void CSG_Shade()
{
  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    SHADE_LightRegion(all_regions[i]);
  }
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
