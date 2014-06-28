//------------------------------------------------------------------------
//  DOOM PREFAB loader
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2012-2014 Andrew Apted
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
//  A.P.I
//  =====
//  
//  wadfab_load(name)
//  --> no result, raises error on failure
//  
//  wadfab_free()
//  --> no result
//  
//  wadfab_get_polygon(index)
//  -->  sector_num, { {x=#,y=#,side=#,line=#,along=# } ... }
// 
//  wadfab_get_sector(index)
//  -->  { floor_h=#, floor_tex="...",
//          ceil_h=#,  ceil_tex="...",
//         special=#, tag=#, light=#
//       }
// 
//  wadfab_get_side(index)
//  -->  { upper_tex="", mid_tex="", lower_tex="",
//         x_offset=#, y_offset=#, sector=#
//       }
// 
//  wadfab_get_line(index)
//  -->  { special=#, tag=#, flags=#, right=#, left=# }
//  
//  wadfab_get_3d_floor(poly_idx, floor_idx)
//  -->  { bottom_h=#, bottom_tex="...",
//            top_h=#,    top_tex="...",
//         side_tex="...", x_offset=#, y_offset=#
//         special=#, light=#
//       }
// 
//  wadfab_get_thing(index)
//  -->  { id=#, x=#, y=#, z=#, angle=#, flags=# }
//
//------------------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "ajpoly.h"

#include "lib_file.h"
#include "lib_util.h"
#include "lib_wad.h"

#include "main.h"
#include "m_lua.h"

#include "csg_main.h"

#include "dm_prefab.h"
#include "g_doom.h"


// callbacks for AJ-Polygonator

static char appl_message[MSG_BUF_LEN];

void Appl_FatalError(const char *str, ...)
{
	va_list args;

	va_start(args, str);
	vsnprintf(appl_message, MSG_BUF_LEN, str, args);
	va_end(args);

	appl_message[MSG_BUF_LEN-1] = 0;

	Main_FatalError("AJ-Polygonator Failure:\n%s", appl_message);
	/* NOT REACHED */
}

void Appl_Printf(const char *str, ...)
{
	if (debug_messages)
	{
		va_list args;

		va_start(args, str);
		vsnprintf(appl_message, MSG_BUF_LEN, str, args);
		va_end(args);

		appl_message[MSG_BUF_LEN-1] = 0;

		LogPrintf("AJPOLY: %s", appl_message);
	}
}


//------------------------------------------------------------------------

int wadfab_free(lua_State *L)
{
	ajpoly::CloseMap();
	ajpoly::FreeWAD();

	return 0;
}


int wadfab_load(lua_State *L)
{
	const char *name = luaL_checkstring(L, 1);

	char filename[PATH_MAX];

	SYS_ASSERT(game_dir);

	sprintf(filename, "%s/%s", game_dir, name);

	if (! FileExists(filename))
		return luaL_error(L, "wadfab_load: no such file: %s", name);

	if (! ajpoly::LoadWAD(filename))
		return luaL_error(L, "wadfab_load: %s", ajpoly::GetError());

	if (! ajpoly::OpenMap("*" /* first one */))
		return luaL_error(L, "wadfab_load: %s", ajpoly::GetError());

	if (! ajpoly::Polygonate(true /* require_border */))
		return luaL_error(L, "wadfab_load: %s", ajpoly::GetError());

	return 0;
}


//------------------------------------------------------------------------

static int calc_thing_z(int x, int y)
{
	for (int p = 0 ; p < ajpoly::num_polygons ; p++)
	{
		const ajpoly::polygon_c * poly = ajpoly::Polygon(p);
	
		// ignore void space
		if (!poly->sector || poly->sector->index < 0 ||
		     poly->sector->index == VOID_SECTOR_IDX)
			continue;

		if (poly->ContainsPoint(x, y))
			return poly->sector->floor_h;
	}

	return 0;  // dummy value
}


int wadfab_get_thing(lua_State *L)
{
	int index = luaL_checkint(L, 1);

	if (index < 0 || index >= ajpoly::num_things)
		return 0;

	const ajpoly::thing_c * TH = ajpoly::Thing(index);

	lua_newtable(L);

	lua_pushinteger(L, TH->x);
	lua_setfield(L, -2, "x");

	lua_pushinteger(L, TH->y);
	lua_setfield(L, -2, "y");

	lua_pushinteger(L, calc_thing_z(TH->x, TH->y));
	lua_setfield(L, -2, "z");

	lua_pushinteger(L, TH->angle);
	lua_setfield(L, -2, "angle");

	lua_pushinteger(L, TH->type);
	lua_setfield(L, -2, "id");

	lua_pushinteger(L, TH->options);
	lua_setfield(L, -2, "flags");

	return 1;
}


int wadfab_get_sector(lua_State *L)
{
	int index = luaL_checkint(L, 1);

	if (index < 0 || index >= ajpoly::num_sectors)
		return 0;

	const ajpoly::sector_c * SEC = ajpoly::Sector(index);

	lua_newtable(L);

	lua_pushinteger(L, SEC->floor_h);
	lua_setfield(L, -2, "floor_h");

	lua_pushinteger(L, SEC->ceil_h);
	lua_setfield(L, -2, "ceil_h");

	lua_pushinteger(L, SEC->special);
	lua_setfield(L, -2, "special");

	lua_pushinteger(L, SEC->light);
	lua_setfield(L, -2, "light");

	// if we have 3D floors here, do not send the tag
	if (SEC->num_floors == 0)
	{
		lua_pushinteger(L, SEC->tag);
		lua_setfield(L, -2, "tag");
	}

	lua_pushstring(L, SEC->floor_tex);
	lua_setfield(L, -2, "floor_tex");

	lua_pushstring(L, SEC->ceil_tex);
	lua_setfield(L, -2, "ceil_tex");

	return 1;
}


int wadfab_get_side(lua_State *L)
{
	int index = luaL_checkint(L, 1);

	if (index < 0 || index >= ajpoly::num_sidedefs)
		return 0;

	const ajpoly::sidedef_c * SD = ajpoly::Sidedef(index);

	lua_newtable(L);

	lua_pushinteger(L, SD->x_offset);
	lua_setfield(L, -2, "x_offset");

	lua_pushinteger(L, SD->y_offset);
	lua_setfield(L, -2, "y_offset");

	if (SD->sector)
	{
		lua_pushinteger(L, SD->sector->index);
		lua_setfield(L, -2, "sector");
	}

	lua_pushstring(L, SD->upper_tex);
	lua_setfield(L, -2, "upper_tex");

	lua_pushstring(L, SD->lower_tex);
	lua_setfield(L, -2, "lower_tex");

	lua_pushstring(L, SD->mid_tex);
	lua_setfield(L, -2, "mid_tex");

	return 1;
}


int wadfab_get_line(lua_State *L)
{
	int index = luaL_checkint(L, 1);

	if (index < 0 || index >= ajpoly::num_linedefs)
		return 0;

	const ajpoly::linedef_c * LD = ajpoly::Linedef(index);

	lua_newtable(L);

	lua_pushinteger(L, LD->special);
	lua_setfield(L, -2, "special");

	lua_pushinteger(L, LD->flags);
	lua_setfield(L, -2, "flags");

	lua_pushinteger(L, LD->tag);
	lua_setfield(L, -2, "tag");

	if (LD->right)
	{
		lua_pushinteger(L, LD->right->index);
		lua_setfield(L, -2, "right");
	}

	if (LD->left)
	{
		lua_pushinteger(L, LD->left->index);
		lua_setfield(L, -2, "left");
	}

	return 1;
}


static double calc_along_dist(const ajpoly::edge_c * E)
{
	const ajpoly::linedef_c *LD = E->linedef;

	SYS_ASSERT(LD);

	double ref_x = (E->side == 1) ? LD->start->x : LD->end->x;
	double ref_y = (E->side == 1) ? LD->start->y : LD->end->y;

	double dx = ref_x - E->end->x;
	double dy = ref_y - E->end->y;

	return hypot(dx, dy);
}


static void push_edge(lua_State *L, int tab_index, const ajpoly::edge_c * E)
{
	lua_newtable(L);

	// using 'end' coord since edges face outwards

	lua_pushnumber(L, E->end->x);
	lua_setfield(L, -2, "x");

	lua_pushnumber(L, E->end->y);
	lua_setfield(L, -2, "y");

	if (E->linedef)
	{
		lua_pushinteger(L, E->linedef->index);
		lua_setfield(L, -2, "line");

		lua_pushnumber(L, calc_along_dist(E));
		lua_setfield(L, -2, "along");

		const ajpoly::sidedef_c * SD;

		// we want the "outer" sidedef (the opposite side)
		if (E->side == 0)
			SD = E->linedef->left;
		else
			SD = E->linedef->right;

		if (SD)
		{
			lua_pushinteger(L, SD->index);
			lua_setfield(L, -2, "side");
		}
	}

	lua_rawseti(L, -2, tab_index);
}


int wadfab_get_polygon(lua_State *L)
{
	int index = luaL_checkint(L, 1);

	if (index < 0 || index >= ajpoly::num_polygons)
		return 0;

	const ajpoly::polygon_c * poly = ajpoly::Polygon(index);


	// result #1 : SECTOR
	int sect_id  = poly->sector ? poly->sector->index : -1;

	if (sect_id == VOID_SECTOR_IDX)
		sect_id = -1;

	lua_pushinteger(L, sect_id);


	// result #2 : COORDS
	std::vector<ajpoly::edge_c *> edges;

	for (ajpoly::edge_c * E = poly->edge_list ; E ; E = E->next)
		edges.push_back(E);

	int edge_num = (int)edges.size();

	lua_createtable(L, edge_num, 0);

	for (int tab_index = 1 ; tab_index <= edge_num ; tab_index++)
	{
		// the polygon edges are clockwise, but OBLIGE are anti-clockwise.
		// hence reverse the order.  We also use 'end' instead of 'start'.

		push_edge(L, tab_index, edges[edge_num - tab_index]);
	}

	return 2;
}


int wadfab_get_3d_floor(lua_State *L)
{
	int  poly_idx = luaL_checkint(L, 1);
	int floor_idx = luaL_checkint(L, 2);

	if (poly_idx < 0 || poly_idx >= ajpoly::num_polygons)
		return 0;

	const ajpoly::polygon_c * poly = ajpoly::Polygon(poly_idx);

	if (! poly->sector || poly->sector->num_floors <= 0)
		return 0;


	// determine line and dummy sector

	const ajpoly::linedef_c * LD = poly->sector->getExtraFloor(floor_idx);

	if (! LD)
		return 0;

	const ajpoly::sector_c * SEC = LD->right->sector;

	if (! SEC)
		return 0;

	// save the information

	lua_newtable(L);

	// BOTTOM
	lua_pushinteger(L, SEC->floor_h);
	lua_setfield(L, -2, "bottom_h");

	lua_pushstring(L, SEC->floor_tex);
	lua_setfield(L, -2, "bottom_tex");

	// TOP
	lua_pushinteger(L, SEC->ceil_h);
	lua_setfield(L, -2, "top_h");

	lua_pushstring(L, SEC->ceil_tex);
	lua_setfield(L, -2, "top_tex");

	// SIDE
	lua_pushstring(L, LD->right->mid_tex);
	lua_setfield(L, -2, "side_tex");

	lua_pushinteger(L, LD->right->x_offset);
	lua_setfield(L, -2, "x_offset");

	lua_pushinteger(L, LD->right->y_offset);
	lua_setfield(L, -2, "y_offset");

	// PROPERTIES
	lua_pushinteger(L, SEC->special);
	lua_setfield(L, -2, "special");

	lua_pushinteger(L, SEC->light);
	lua_setfield(L, -2, "light");

	if (LD->special == 405)
	{
		lua_pushinteger(L, 1);
		lua_setfield(L, -2, "liquid");
	}

	return 1;
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
