//------------------------------------------------------------------------
//  2.5D Constructive Solid Geometry
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2014 Andrew Apted
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
#include "m_lua.h"

#include "csg_main.h"
#include "csg_local.h"


#define EPSILON  0.001


std::vector<csg_brush_c *> all_brushes;

std::vector<csg_entity_c *> all_entities;

std::string dummy_wall_tex;
std::string dummy_plane_tex;


// m_spots.cc
#define SPOT_LOW_CEIL  1
#define SPOT_WALL      2
#define SPOT_LEDGE     3

int spot_low_h  = 72;
int spot_high_h = 128;


extern void SPOT_FillPolygon(byte content, const int *shape, int count);


slope_info_c::slope_info_c() :
	sx(0),sy(0), ex(1),ey(0),dz(0)
{ }

slope_info_c::slope_info_c(const slope_info_c *other) :
	sx(other->sx), sy(other->sy),
	ex(other->ex), ey(other->ey), dz(other->dz)
{ }

slope_info_c::~slope_info_c()
{ }


void slope_info_c::Reverse()
{
	std::swap(sx, ex);
	std::swap(sy, ey);

	dz = -dz;
}


double slope_info_c::GetAngle() const
{
	double xy_dist = ComputeDist(sx, sy, ex, ey);

	return CalcAngle(0, 0, xy_dist, dz);
}


double slope_info_c::CalcZ(double base_z, double x, double y) const
{
	double dx = (ex - sx);
	double dy = (ey - sy);

	double along = (x - sx) * dx + (y - dy) * dy;

	return base_z + dz * along / (dx*dx + dy*dy);
}



void csg_property_set_c::Add(const char *key, const char *value)
{
	dict[key] = std::string(value);
}

void csg_property_set_c::Remove(const char *key)
{
	dict.erase(key);
}


void csg_property_set_c::DebugDump()
{
	std::map<std::string, std::string>::iterator PI;

	fprintf(stderr, "{\n");

	for (PI = dict.begin() ; PI != dict.end() ; PI++)
	{
		fprintf(stderr, "  %s = \"%s\"\n", PI->first.c_str(), PI->second.c_str());
	}

	fprintf(stderr, "}\n");
}


const char * csg_property_set_c::getStr(const char *key, const char *def_val)
{
	std::map<std::string, std::string>::iterator PI = dict.find(key);

	if (PI == dict.end())
		return def_val;

	return PI->second.c_str();
}

double csg_property_set_c::getDouble(const char *key, double def_val)
{
	const char *str = getStr(key);

	return str ? atof(str) : def_val;
}

int csg_property_set_c::getInt(const char *key, int def_val)
{
	const char *str = getStr(key);

	return str ? I_ROUND(atof(str)) : def_val;
}


void csg_property_set_c::getHexenArgs(u8_t *arg5)
{
	arg5[0] = getInt("arg1");
	arg5[1] = getInt("arg2");
	arg5[2] = getInt("arg3");
	arg5[3] = getInt("arg4");
	arg5[4] = getInt("arg5");
}


brush_vert_c::brush_vert_c(csg_brush_c *_parent, double _x, double _y) :
	parent(_parent), x(_x), y(_y),
	face()
{ }

brush_vert_c::~brush_vert_c()
{ }


brush_plane_c::brush_plane_c(const brush_plane_c& other) :
	z(other.z), slope(NULL), face(other.face)
{
	// NOTE: slope not cloned
}
 
brush_plane_c::~brush_plane_c()
{
	// free slope ??   (or keep all slopes in big list)

	// free face ??  (or keep all faces in big list)
}


csg_brush_c::csg_brush_c() :
	bkind(BKIND_Solid), bflags(0),
	props(), verts(),
	b(-EXTREME_H),
	t( EXTREME_H)
{ }

csg_brush_c::csg_brush_c(const csg_brush_c *other) :
	bkind(other->bkind), bflags(other->bflags),
	props(other->props), verts(),
	b(other->b), t(other->t)
{
	// NOTE: verts and slopes not cloned

	bflags &= ~ BRU_IF_Quad;
}

csg_brush_c::~csg_brush_c()
{
	// FIXME: free verts

	// FIXME: free slopes
}


const char * csg_brush_c::Validate()
{
	if (verts.size() < 3)
		return "Line loop contains less than 3 vertices!";

	// FIXME: make sure brush is convex (co-linear lines is OK)

	// make sure vertices are anti-clockwise
	double average_ang = 0;

	bflags |= BRU_IF_Quad;

	for (unsigned int k = 0 ; k < verts.size() ; k++)
	{
		brush_vert_c *v1 = verts[k];
		brush_vert_c *v2 = verts[(k+1) % (int)verts.size()];
		brush_vert_c *v3 = verts[(k+2) % (int)verts.size()];

		if (fabs(v2->x - v1->x) < EPSILON && fabs(v2->y - v1->y) < EPSILON)
			return "Line loop contains a zero length line!";

		double ang1 = CalcAngle(v2->x, v2->y, v1->x, v1->y);
		double ang2 = CalcAngle(v2->x, v2->y, v3->x, v3->y);

		double diff = ang1 - ang2;

		if (diff < 0)    diff += 360.0;
		if (diff >= 360) diff -= 360.0;

		if (diff > 180.1)
			return "Line loop is not convex!";

		average_ang += diff;

		if (fabs(v1->x - v2->x) >= EPSILON &&
				fabs(v1->y - v2->y) >= EPSILON)
		{
			bflags &= ~BRU_IF_Quad;  // not a quad
		} 
	}

	average_ang /= (double)verts.size();

	// fprintf(stderr, "Average angle = %1.4f\n\n", average_ang);

	if (average_ang > 180.0)
		return "Line loop is not anti-clockwise!";

	return NULL; // OK
}

void csg_brush_c::ComputeBBox()
{
	min_x = +9e7;
	min_y = +9e7;
	max_x = -9e7;
	max_y = -9e7;

	for (unsigned int i = 0 ; i < verts.size() ; i++)
	{
		brush_vert_c *V = verts[i];

		if (V->x < min_x) min_x = V->x;
		if (V->y < min_y) min_y = V->y;

		if (V->x > max_x) max_x = V->x;
		if (V->y > max_y) max_y = V->y;
	}
}


bool csg_brush_c::IntersectRay(float x1, float y1, float z1,
                               float x2, float y2, float z2) const
{
	// clip the 2D line to the brush sides

	for (unsigned int k = 0 ; k < verts.size() ; k++)
	{
		brush_vert_c *v1 = verts[k];
		brush_vert_c *v2 = verts[(k+1) % (int)verts.size()];

		double a = PerpDist(x1,y1, v1->x,v1->y, v2->x,v2->y);
		double b = PerpDist(x2,y2, v1->x,v1->y, v2->x,v2->y);

		// ray is completely outside the brush?
		if (a > 0 && b > 0)
			return false;

		// ray is completely inside it?
		if (a <= 0 && b <= 0)
			continue;

		// gotta clip the ray

		double frac = a / (double)(a - b);

		if (a > 0)
		{
			x1 = x1 + (x2 - x1) * frac;
			y1 = y1 + (y2 - y1) * frac;
			z1 = z1 + (z2 - z1) * frac;
		}
		else
		{
			x2 = x1 + (x2 - x1) * frac;
			y2 = y1 + (y2 - y1) * frac;
			z2 = z1 + (z2 - z1) * frac;
		}
	}

	// at here, the clipped ray lies inside the brush

	if (MAX(z1, z2) < b.z - 0.1) return false;
	if (MIN(z1, z2) > t.z + 0.1) return false;

	return true;
}


csg_entity_c::csg_entity_c() : id(), x(0), y(0), z(0), props(), ex_floor(-1)
{ }

csg_entity_c::~csg_entity_c()
{ }


bool csg_entity_c::Match(const char *want_name) const
{
	return (strcmp(id.c_str(), want_name) == 0);
}


//------------------------------------------------------------------------

#define QUAD_NODE_SIZE  320


class brush_quad_node_c
{
public:
	int lo_x, lo_y, size;  

	brush_quad_node_c *children[2][2];   // [x][y]

	std::vector<csg_brush_c *> brushes;

public:
	inline int hi_x() const { return lo_x + size; }
	inline int hi_y() const { return lo_y + size; }

	inline int mid_x() const { return lo_x + size / 2; }
	inline int mid_y() const { return lo_y + size / 2; }

public:
	brush_quad_node_c(int x1, int y1, int _size) :
		lo_x(x1), lo_y(y1), size(_size),
		brushes()
	{
		children[0][0] = NULL;
		children[0][1] = NULL;
		children[1][0] = NULL;
		children[1][1] = NULL;

		Subdivide();
	}

	~brush_quad_node_c()
	{
		delete children[0][0];
		delete children[0][1];
		delete children[1][0];
		delete children[1][1];
	}

private:
	void Subdivide()
	{
		if (size <= QUAD_NODE_SIZE)
			return;

		int new_size = (size + 1) / 2;

		for (int cx = 0 ; cx < 2 ; cx++)
		for (int cy = 0 ; cy < 2 ; cy++)
		{
			int new_x = cx ? mid_x() : lo_x;
			int new_y = cy ? mid_y() : lo_y;

			children[cx][cy] = new brush_quad_node_c(new_x, new_y, new_size);
		}
	}

private:
	void DoAddBrush(csg_brush_c *B, int x1, int y1, int x2, int y2)
	{
		// does it fit in a child node?
		if (children[0][0])
		{
			int cx = -1;
			int cy = -1;

			if (x1 >  lo_x   && x2 < mid_x()) cx = 0;
			if (x1 > mid_x() && x2 <  hi_x()) cx = 1;

			if (y1 >  lo_y   && y2 < mid_y()) cy = 0;
			if (y1 > mid_y() && y2 <  hi_y()) cy = 1;

			if (cx >= 0 && cy >= 0)
			{
				children[cx][cy]->DoAddBrush(B, x1, y1, x2, y2);
				return;
			}
		}

		// nope -- gotta go in this node
		brushes.push_back(B);
	}

public:
	void Add(csg_brush_c * B)
	{
		int x1 = floor(B->min_x);
		int y1 = floor(B->min_y);
		int x2 =  ceil(B->max_x);
		int y2 =  ceil(B->max_y);

		DoAddBrush(B, x1, y1, x2, y2);
	}

private:
	bool IntersectBrush(const csg_brush_c *B,
						double x1, double y1, double z1,
				    	double x2, double y2, double z2, const char *mode)
	{
		if (mode[0] == 'v')
		{
			if (B->bkind == BKIND_Clip || B->bkind >= BKIND_Trigger)
				return false;
		}
		else if (mode[0] == 'p')
		{
			if (B->bkind == BKIND_Detail || B->bkind >= BKIND_Liquid)
				return false;
		}

		return B->IntersectRay(x1, y1, z1, x2, y2, z2);
	}

	bool BoxTouchesThis(double x1, double y1, double x2, double y2) const
	{
		if (MAX(x1, x2) < lo_x) return false;
		if (MAX(y1, y2) < lo_y) return false;

		if (MIN(x1, x2) > hi_x()) return false;
		if (MIN(y1, y2) > hi_y()) return false;

		return true;
	}

	bool RayTouchesBox(double x1, double y1, double x2, double y2) const
	{
		// TODO: a _proper_ line/box test will be much more optimal
		//       (assuming the average ray is fairly long).

		return BoxTouchesThis(x1, y1, x2, y2);
	}

public:
	bool TraceRay(double x1, double y1, double z1,
				  double x2, double y2, double z2, const char *mode)
	{
		for (unsigned int k = 0 ; k < brushes.size() ; k++)
			if (IntersectBrush(brushes[k], x1,y1,z1, x2,y2,z2, mode))
				return true;

		if (children[0][0])
		{
			for (int cx = 0 ; cx < 2 ; cx++)
			for (int cy = 0 ; cy < 2 ; cy++)
			{
				if (children[cx][cy]->RayTouchesBox(x1,y1, x2,y2))
					if (children[cx][cy]->TraceRay(x1,y1,z1, x2,y2,z2, mode))
						return true;
			}
		}

		return false;  // did not hit anything
	}

private:
	void SpotTestBrush(const csg_brush_c *B,
					   int x1, int y1, int x2, int y2, int floor_h)
	{
		// ignore non-solid brushes
		if (B->bkind == BKIND_Detail || B->bkind >= BKIND_Liquid)
			return;

		// bbox check (skip if merely touching the bbox)
		if (B->max_x <= x1 || B->min_x >= x2 ||
		    B->max_y <= y1 || B->min_y >= y2)
			return;

		// skip brushes underneath the floor (or the floor itself)
		if (B->t.z < floor_h + 1)
			return;

		// skip brushes far above the floor (like ceilings)
		if (B->b.z >= floor_h + spot_high_h)
			return;

		/* this brush is a potential blocker */

		int content = SPOT_LEDGE;

		if (B->b.z >= floor_h + spot_low_h)
			content = SPOT_LOW_CEIL;

		else if (B->b.z <= floor_h && B->t.z >= floor_h + spot_low_h)
			content = SPOT_WALL;

		// build the polygon
		std::vector<int> shape;

		int num_vert = (int)B->verts.size();

		for (int i = 0 ; i < num_vert ; i++)
		{
			const brush_vert_c *V = B->verts[i];

			// rounding to integer here, I don't think it is any problem,
			// as the spot polygon-drawing code is fairly robust.
			shape.push_back(I_ROUND(V->x));
			shape.push_back(I_ROUND(V->y));
		}

		SPOT_FillPolygon(content, &shape[0], num_vert);
	}

public:
	void SpotStuff(int x1, int y1, int x2, int y2, int floor_h)
	{
		for (unsigned int k = 0 ; k < brushes.size() ; k++)
			SpotTestBrush(brushes[k], x1,y1, x2,y2, floor_h);

		if (children[0][0])
		{
			for (int cx = 0 ; cx < 2 ; cx++)
			for (int cy = 0 ; cy < 2 ; cy++)
			{
				if (children[cx][cy]->BoxTouchesThis(x1,y1, x2,y2))
					children[cx][cy]->SpotStuff(x1,y1, x2,y2, floor_h);
			}
		}
	}
};


brush_quad_node_c * brush_quad_tree;


static void CSG_CreateQuadTree()
{
	// TODO: these coords assume DOOM maps
	// (for Quake it should be centred on the origin)
	// perhaps make this controllable from the Lua scripts?

	brush_quad_tree = new brush_quad_node_c(0, 0, 16384);
}

static void CSG_DeleteQuadTree()
{
	delete brush_quad_tree;

	brush_quad_tree = NULL;
}


//------------------------------------------------------------------------

int Grab_Properties(lua_State *L, int stack_pos,
                    csg_property_set_c *props,
                    bool skip_singles = false)
{
	if (stack_pos < 0)
		stack_pos += lua_gettop(L) + 1;

	if (lua_isnil(L, stack_pos))
		return 0;

	if (lua_type(L, stack_pos) != LUA_TTABLE)
		return luaL_argerror(L, stack_pos, "bad property table");

	for (lua_pushnil(L) ; lua_next(L, stack_pos) != 0 ; lua_pop(L,1))
	{
		// skip keys which are not strings
		if (lua_type(L, -2) != LUA_TSTRING)
			continue;

		const char *key = lua_tostring(L, -2);

		// optionally skip single letter keys ('x', 'y', etc)
		if (skip_singles && strlen(key) == 1)
			continue;

		// validate the value
		if (lua_type(L, -1) == LUA_TBOOLEAN)
		{
			props->Add(key, lua_toboolean(L, -1) ? "1" : "0");
			continue;
		}

		if (lua_type(L, -1) == LUA_TSTRING || lua_type(L, -1) == LUA_TNUMBER)
		{
			props->Add(key, lua_tostring(L, -1));
			continue;
		}

		// ignore other values (tables etc)

		//// return luaL_error(L, "bad property: weird value for '%s'", key);
	}

	return 0;
}


static slope_info_c * Grab_Slope(lua_State *L, int stack_pos, bool is_ceil)
{
	if (stack_pos < 0)
		stack_pos += lua_gettop(L) + 1;

	if (lua_isnil(L, stack_pos))
		return NULL;

	if (lua_type(L, stack_pos) != LUA_TTABLE)
	{
		luaL_argerror(L, stack_pos, "missing table: slope info");
		return NULL; /* NOT REACHED */
	}

	slope_info_c *P = new slope_info_c();

	lua_getfield(L, stack_pos, "x1");
	lua_getfield(L, stack_pos, "y1");

	P->sx = luaL_checknumber(L, -2);
	P->sy = luaL_checknumber(L, -1);

	lua_pop(L, 2);

	lua_getfield(L, stack_pos, "x2");
	lua_getfield(L, stack_pos, "y2");
	lua_getfield(L, stack_pos, "dz");

	P->ex = luaL_checknumber(L, -3);
	P->ey = luaL_checknumber(L, -2);
	P->dz = luaL_checknumber(L, -1);

	lua_pop(L, 3);

	// floor slopes should have negative dz, and ceilings positive
	if ((is_ceil ? 1 : -1) * P->dz < 0)
	{
		// P->Reverse();
		luaL_error(L, "bad slope: dz should be <0 for floor, >0 for ceiling");
		return NULL; /* NOT REACHED */
	}

	return P;
}


int Grab_BrushMode(lua_State *L, const char *kind)
{
	// parse the 'm' field of the props table

	if (! kind)
	{
		// not present, return the default
		return BKIND_Solid;
	}

	if (StringCaseCmp(kind, "solid")  == 0) return BKIND_Solid;
	if (StringCaseCmp(kind, "detail") == 0) return BKIND_Detail;
	if (StringCaseCmp(kind, "clip")   == 0) return BKIND_Clip;

	if (StringCaseCmp(kind, "sky")     == 0) return BKIND_Sky;
	if (StringCaseCmp(kind, "liquid")  == 0) return BKIND_Liquid;
	if (StringCaseCmp(kind, "trigger") == 0) return BKIND_Trigger;
	if (StringCaseCmp(kind, "light")   == 0) return BKIND_Light;

	return luaL_error(L, "gui.add_brush: unknown kind '%s'", kind);
}


static int Grab_Vertex(lua_State *L, int stack_pos, csg_brush_c *B)
{
	if (stack_pos < 0)
		stack_pos += lua_gettop(L) + 1;

	if (lua_type(L, stack_pos) != LUA_TTABLE)
	{
		return luaL_error(L, "gui.add_brush: missing vertex info");
	}

	lua_getfield(L, stack_pos, "m");

	if (! lua_isnil(L, -1))
	{
		const char *kind_str = luaL_checkstring(L, -1);

		B->bkind = Grab_BrushMode(L, kind_str);

		Grab_Properties(L, stack_pos, &B->props, true);

		lua_pop(L, 1);

		return 0;
	}

	lua_pop(L, 1);

	lua_getfield(L, stack_pos, "slope");
	lua_getfield(L, stack_pos, "b");
	lua_getfield(L, stack_pos, "t");

	if (! lua_isnil(L, -2) || ! lua_isnil(L, -1))
	{
		if (lua_isnil(L, -2))  // top
		{
			B->t.z = luaL_checknumber(L, -1);
			B->t.slope = Grab_Slope(L, -3, false);

			Grab_Properties(L, stack_pos, &B->t.face, true);
		}
		else  // bottom
		{
			B->b.z = luaL_checknumber(L, -2);
			B->b.slope = Grab_Slope(L, -3, true);

			Grab_Properties(L, stack_pos, &B->b.face, true);
		}
	}
	else  // side info
	{
		brush_vert_c *V = new brush_vert_c(B);

		lua_getfield(L, stack_pos, "x");
		lua_getfield(L, stack_pos, "y");

		V->x = luaL_checknumber(L, -2);
		V->y = luaL_checknumber(L, -1);

		lua_pop(L, 2);

		Grab_Properties(L, stack_pos, &V->face, true);

		B->verts.push_back(V);
	}

	lua_pop(L, 3);  // slope, b, t

	return 0;
}


static int Grab_CoordList(lua_State *L, int stack_pos, csg_brush_c *B)
{
	if (lua_type(L, stack_pos) != LUA_TTABLE)
	{
		return luaL_argerror(L, stack_pos, "missing table: coords");
	}

	int index = 1;

	for (;;)
	{
		lua_pushinteger(L, index);
		lua_gettable(L, stack_pos);

		if (lua_isnil(L, -1))
		{
			lua_pop(L, 1);
			break;
		}

		Grab_Vertex(L, -1, B);

		lua_pop(L, 1);

		index++;
	}

	const char *err_msg = B->Validate();

	if (err_msg)
		return luaL_error(L, "%s", err_msg);

	B->ComputeBBox();

	if ((B->max_x - B->min_x) < EPSILON)
		return luaL_error(L, "Line loop has zero width!");

	if ((B->max_y - B->min_y) < EPSILON)
		return luaL_error(L, "Line loop has zero height!");

	return 0;
}


// LUA: begin_level()
//
int CSG_begin_level(lua_State *L)
{
	SYS_ASSERT(game_object);

	CSG_Main_Free();

	game_object->BeginLevel();

	CSG_CreateQuadTree();

	return 0;
}


// LUA: end_level()
//
int CSG_end_level(lua_State *L)
{
	SYS_ASSERT(game_object);

	game_object->EndLevel();

	CSG_Main_Free();

	CSG_BSP_Free();

	return 0;
}


// LUA: property(key, value)
//
int CSG_property(lua_State *L)
{
	const char *key   = luaL_checkstring(L,1);
	const char *value = luaL_checkstring(L,2);

	// eat propertities intended for CSG2

	if (strcmp(key, "error_tex") == 0)
	{
		dummy_wall_tex = std::string(value);
		return 0;
	}
	else if (strcmp(key, "error_flat") == 0)
	{
		dummy_plane_tex = std::string(value);
		return 0;
	}
	else if (strcmp(key, "spot_low_h") == 0)
	{
		spot_low_h = atoi(value);
		return 0;
	}
	else if (strcmp(key, "spot_high_h") == 0)
	{
		spot_high_h = atoi(value);
		return 0;
	}

	SYS_ASSERT(game_object);

	game_object->Property(key, value);

	return 0;
}


// LUA: add_brush(coords)
//
// coords is a list of coordinates of the form:
//   { m="solid", ... }                     -- properties
//   { x=123, y=456,     tex="foo", ... }   -- side of brush
//   { b=200, s={ ... }, tex="bar", ... }   -- top of brush
//   { t=240, s={ ... }, tex="gaz", ... }   -- bottom of brush
//
// 'm' is the brush mode, default "solid", can also be
//     "sky", "liquid", "detail", "clip", etc..
//
// tops and bottoms are optional, when absent then it means the
// brush extends to infinity in that direction.
//
// 's' are slope specifications, which are optional.
// They contain these fields: { x1, y1, x2, y2, dz }
// When used, the slope must be "shrinky", i.e. the z1..z2 range needs
// to cover the entirety of the full (sloped) brush.
//
// the rest of the fields are for the FACE, and can be:
//
//    tex  :  texture name
//    
//    x_offset  BLAH  FIXME
//    y_offset
//
//    delta_z   : a post-CSG height adjustment (top & bottom only)
//    mark      : separating number (top & bottom only)
//
//    kind   : DOOM sector or linedef type
//    flags  : DOOM linedef flags
//    tag    : DOOM sector or linedef tag
//    args   : DOOM sector or linedef args (a table)
//
int CSG_add_brush(lua_State *L)
{
	csg_brush_c *B = new csg_brush_c();

	Grab_CoordList(L, 1, B);

	if (B->props.getStr("flavor"))
		Main_FatalError("Flavored brush used.\n");

	all_brushes.push_back(B);

	brush_quad_tree->Add(B);

	return 0;
}


// LUA: add_entity(props)
//
//   id      -- number or name of thing
//   x y z   -- coordinates
//   angle
//   flags
//   light   -- amount of light emitted
//
//   etc...
//
int CSG_add_entity(lua_State *L)
{
	csg_entity_c *E = new csg_entity_c();

	Grab_Properties(L, 1, &E->props);

	E->id = E->props.getStr("id", "");

	E->x = E->props.getDouble("x");
	E->y = E->props.getDouble("y");
	E->z = E->props.getDouble("z");

	// save a bit of space
	E->props.Remove("id"); E->props.Remove("x");
	E->props.Remove("y");  E->props.Remove("z");

	all_entities.push_back(E);

	return 0;
}


// LUA: trace_ray(x1,y1,z1, x2,y2,z2, mode)
//
//   x1 y1 z1  -- start coordinate
//   x2 y2 z2  -- end coordinate
//
//   mode -- a string with one or more letters:
//
//      v : visibility [only visible brushes]
//      p : physics    [only solid brushes]
//
//   result is 'true' if something hit, false otherwise
//
int CSG_trace_ray(lua_State *L)
{
	double x1 = luaL_checknumber(L, 1);
	double y1 = luaL_checknumber(L, 2);
	double z1 = luaL_checknumber(L, 3);

	double x2 = luaL_checknumber(L, 4);
	double y2 = luaL_checknumber(L, 5);
	double z2 = luaL_checknumber(L, 6);

	const char *mode = luaL_checkstring(L, 7);

	if (fabs(x2 - x1) < 1 && fabs(y2 - y1) < 1 && fabs(z2 - z1) < 1)
	{
		return luaL_error(L, "gui.trace_ray: zero-length vector");
	}

	if (! (mode[0] == 'v' || mode[0] == 'p'))
	{
		return luaL_argerror(L, 7, "gui.trace_ray: bad mode string");
	}

	SYS_ASSERT(brush_quad_tree);

	bool result = brush_quad_tree->TraceRay(x1, y1, z1, x2, y2, z2, mode);

	lua_pushboolean(L, result ? 1 : 0);
	return 1;
}


bool CSG_TraceRay(double x1, double y1, double z1,
				  double x2, double y2, double z2, const char *mode)
{
	SYS_ASSERT(brush_quad_tree);

	return brush_quad_tree->TraceRay(x1, y1, z1, x2, y2, z2, mode);
}


void CSG_spot_processing(int x1, int y1, int x2, int y2, int floor_h)
{
	brush_quad_tree->SpotStuff(x1, y1, x2, y2, floor_h);
}


//------------------------------------------------------------------------

void CSG_Main_Free()
{
	unsigned int k;

	for (k = 0 ; k < all_brushes.size() ; k++)
		delete all_brushes[k];

	for (k = 0 ; k < all_entities.size() ; k++)
		delete all_entities[k];

	all_brushes .clear();
	all_entities.clear();

	CSG_DeleteQuadTree();

	dummy_wall_tex .clear();
	dummy_plane_tex.clear();

	spot_low_h  = 72;
	spot_high_h = 128;
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
