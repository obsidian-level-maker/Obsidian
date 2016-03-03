//------------------------------------------------------------------------
//  AREAS
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2005 Andrew Apted
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

#ifndef __OBLIGE_AREA_H__
#define __OBLIGE_AREA_H__

class area_c;


class neighbour_info_c
{
public:
	neighbour_info_c() : ptr(NULL), contacts(0), cull_perc(-1),
		hard_link(0), soft_link(0), hard_act(0), soft_act(0)
	{ }

	~neighbour_info_c() { }

public:
	area_c *ptr;

	// number of squares which touch this neighbour (no diagonals)
	int contacts;

	int cull_perc;  // 100 = always cull the link, 0 = always keep

	int hard_link;  // either 0 or an STRU_XXX value (Wall etc)
	int soft_link;  // either 0 or an STRU_XXX value (Door, Lift etc)

	char hard_act, soft_act;  /// REMOVE THESE

public:
	void Set(area_c *A, int _contacts)
	{
		ptr = A; contacts = _contacts; cull_perc = -1;
	}
};

//------------------------------------------------------------------------

class area_c
{
public:
	area_c(int _index, int fx, int fy);
	virtual ~area_c();

public:
	int index;

	int island;
	char stage;

	char floor_h, ceil_h;
	int focal_x, focal_y;

	// BBox (inclusive)
	int lo_x, lo_y;
	int hi_x, hi_y;

	int total;  // total number of squares

	std::vector<neighbour_info_c> neighbours;

	area_c * teleport;  // target area (or NULL)

	int graph_idx;

	astar_info_c star;

public:
	void AddPoint(int x, int y);
	void DetermineNeighbours();

	inline int NumNeighbours() const { return neighbours.size(); }

	int NewNeighbour(int _area, int _contacts);

	inline location_c& Focal() const { return the_world->Loc(focal_x, focal_y); }

	bool IsDamage() const;
	bool IsTunnel() const;

	int dim() const;

	inline int MidX() const { return (lo_x + hi_x) / 2; }
	inline int MidY() const { return (lo_y + hi_y) / 2; }

	int RoughDist(const area_c *other) const;

	int WalkableNeighbours() const;
	bool TouchesWorldEdge() const;

	void RandomLoc(int *X, int *Y) const;

	void MakeVoid();
	void DebugDump();
};

//------------------------------------------------------------------------

namespace area_build
{
	const char *NameForEnv(char env);

	void CreateAreas();
}

#endif /* __OBLIGE_AREA_H__ */
