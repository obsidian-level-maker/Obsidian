//------------------------------------------------------------------------
//  2.5D Constructive Solid Geometry
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2017 Andrew Apted
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

#ifndef __OBLIGE_CSG_MAIN_H__
#define __OBLIGE_CSG_MAIN_H__

class csg_brush_c;
class csg_entity_c;
class quake_plane_c;


// very high (low) value for uncapped brushes
#define EXTREME_H  32000

// epsilon for height comparisons
#define Z_EPSILON  0.01


#define CHUNK_SIZE  512.0


// unset values (handy sometimes)
#define IVAL_NONE  -27777
#define FVAL_NONE  -27777.75f


/******* CLASSES ***************/

class csg_property_set_c
{
private:
	std::map<std::string, std::string> dict;

public:
	csg_property_set_c() : dict()
	{ }

	~csg_property_set_c()
	{ }

	// copy constructor
	csg_property_set_c(const csg_property_set_c& other) : dict(other.dict)
	{ }

	void Add(const char *key, const char *value);
	void Remove(const char *key);

	const char * getStr(const char *key, const char *def_val = NULL) const;

	double getDouble(const char *key, double def_val = 0) const;
	int    getInt   (const char *key, int def_val = 0) const;

	void getHexenArgs(u8_t *arg5) const;

	void DebugDump();

public:
	typedef std::map<std::string, std::string>::iterator iterator;

	iterator begin() { return dict.begin(); }
	iterator   end() { return dict.  end(); }
};


class brush_vert_c
{
public:
	csg_brush_c *parent;

	double x, y;

	csg_property_set_c face;

public:
	brush_vert_c(csg_brush_c *_parent, double _x = 0, double _y = 0);
	~brush_vert_c();
};


class brush_plane_c
{
public:
	// without slope, this is just the height of the top or bottom
	// of the brush.  When sloped, it still represents a bounding
	// height of the brush.
	double z;

	quake_plane_c *slope;  // NULL if not sloped

	csg_property_set_c face;

public:
	brush_plane_c(double _z = 0) : z(_z), slope(NULL), face()
	{ }

	brush_plane_c(const brush_plane_c& other);

	~brush_plane_c();

	double CalcZ(double ax, double ay) const;
};


typedef enum
{
	BKIND_Solid = 0,
	BKIND_Liquid,

	BKIND_Trigger,  // supply a trigger special (DOOM/Nukem only)
	BKIND_Light,    // supply extra lighting or shadow
}
brush_kind_e;

typedef enum
{
	BFLAG_Detail   = (1 << 0),   // not structural (ignored for node/leaf creation)
	BFLAG_Sky      = (1 << 1),   // special handling for lighting
	BFLAG_NoClip   = (1 << 2),   // inhibit clipping for this brush
	BFLAG_NoDraw   = (1 << 3),   // inhibit faces for this brush

	// internal flags
	BRU_IF_Quad    = (1 << 16),  // brush is a four-sided box
	BRU_IF_Seen    = (1 << 17),  // already seen (Quake II)
}
brush_flags_e;


class csg_brush_c
{
	// This represents a "brush" in Quake terms, a solid area
	// on the map with out-facing sides and top/bottom.  Like
	// quake brushes, these must be convex, but co-linear sides
	// are allowed.

public:
	int bkind;
	int bflags;

	csg_property_set_c props;

	std::vector<brush_vert_c *> verts;

	brush_plane_c b;  // bottom
	brush_plane_c t;  // top

	double min_x, min_y;
	double max_x, max_y;

	// only set when brush is part of a map-model (bmodel)
	csg_entity_c * link_ent;

public:
	 csg_brush_c();
	~csg_brush_c();

	// copy constructor
	// NOTE: verts and slopes are not cloned
	csg_brush_c(const csg_brush_c *other);

	void ComputeBBox();
	void ComputePlanes();

	// makes sure there are enough vertices and they are in
	// anti-clockwise order.  Returns NULL if OK, otherwise an
	// error message string.
	const char * Validate();

	bool IntersectRay(float x1, float y1, float z1,
			float x2, float y2, float z2) const;
};


class csg_entity_c
{
public:
	std::string id;

	double x, y, z;

	csg_property_set_c props;

	// this only used by DOOM Extrafloor code, -1 until known
	int ex_floor;

public:
	csg_entity_c();
	~csg_entity_c();

	bool Match(const char *want_name) const;
};



/***** VARIABLES ****************/

extern std::vector<csg_brush_c *> all_brushes;

extern std::vector<csg_entity_c *> all_entities;

extern std::string dummy_wall_tex;
extern std::string dummy_plane_tex;


/***** FUNCTIONS ****************/

void CSG_Main_Free();

bool CSG_TraceRay(double x1, double y1, double z1,
				  double x2, double y2, double z2, const char *mode);

void CSG_LinkBrushToEntity(csg_brush_c *B, const char *link_key);


#endif /* __OBLIGE_CSG_MAIN_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
