//------------------------------------------------------------------------
//  DOOM PREFAB loader
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2012 Andrew Apted
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

#include "lib_file.h"
#include "lib_util.h"
#include "lib_wad.h"

#include "main.h"
#include "m_lua.h"

#include "csg_main.h"

#include "dm_prefab.h"
#include "g_doom.h"
#include "q_common.h"  // qLump_c

//
//  A.P.I
//  =====
//  
//  wadfab_load(name)
//  --> boolean
//  
//  wadfab_free()
//  --> no result
//  
//  wadfab_get_polygon(index)
//  -->  { sector=# 
//         coords={ {x=#,y=#,side=# } ... }
//       }
//  
//  wadfab_get_sector(index)
//  -->  { floor_h=#, floor_tex="...",
//         ceil_h=#, ceil_tex="...",
//         special=#, tag=#, light=#
//       }
//  
//  wadfab_get_side(index)
//  -->  { upper_tex="", mid_tex="", lower_tex="",
//         x_offset=#, y_offset=#,
//         special=#, tag=#, flags=#
//       }
//  
//  wadfab_get_thing(index)
//  -->  { id=#, x=#, y=#, angle=#, flags=# }
//


int DM_wadfab_load(lua_State *L)
{
}


int DM_wadfab_free(lua_State *L)
{
}


int DM_wadfab_get_polygon(lua_State *L)
{
}


int DM_wadfab_get_sector(lua_State *L)
{
}


int DM_wadfab_get_side(lua_State *L)
{
}


int DM_wadfab_get_thing(lua_State *L)
{
}


// TODO

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
