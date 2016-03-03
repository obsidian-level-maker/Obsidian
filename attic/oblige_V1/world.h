//------------------------------------------------------------------------
//  WORLD storage
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

#ifndef __OBLIGE_WORLD_H__
#define __OBLIGE_WORLD_H__


class area_c;
class stage_c;



#define MIN_DIM    16
#define MAX_DIM   160

#define MAX_STAGES  8


#define LOCDIR_E  0x01
#define LOCDIR_N  0x02
#define LOCDIR_W  0x04
#define LOCDIR_S  0x08

#define LOCACT_KEY   0x03  // mask
#define LOCACT_ONCE  0x04
#define LOCACT_EXIT  0x08

// we use high area values while growing the environment.
// Later we assign the proper index values (low ones).
#define TEMP_AREA  10000


class location_c
{
public:
	location_c() : env(0), mat(0), speed(0x11), stru(0), s_dir(0), s_act(0),
				   area(0), floor_h(0), ceil_h(0), sec_idx(-1) { }
	virtual ~location_c() { }

	char env;
	char mat;
	char speed;  

	char stru;
	char s_dir;   // bitmask of LOCDIR_* values
	char s_act;   // bitmask of LOCACT_* values

	short area;

	char floor_h;  // in blocks of 64
	char ceil_h;   // (e.g. 4 means 256)

	short sec_idx;

public:
	inline bool Void() const { return env <= ENV_VOID; }

	// these two methods assume !Void()
	inline bool Indoor() const { return env >= ENV_Building; }
	inline bool Outdoor()  const { return env <= ENV_Water; }

	area_c *Area() const;

	bool IsDamage() const
	{
		switch (mat)
		{
			case MAT_Lava: case MAT_Nukage: case MAT_Slime:
				return true;

			default:
				return false;
		}
	}

	void DebugDump();

	int MatchEnv(const location_c& other) const;
};

//------------------------------------------------------------------------

class world_c
{
public:
	world_c(int _width, int _height);
	virtual ~world_c();

private:
  	int width, height;
 
 	location_c *locs;

	std::vector<area_c *> areas;
	std::vector<stage_c *> stages;

public:
	inline int w() const { return width; }
	inline int h() const { return height; }
	inline int dim() const { return (width + height) / 2; }

	inline int RandomX() const { return RandomRange(0, width-1);  }
	inline int RandomY() const { return RandomRange(0, height-1); }

	/* ----- ENVIRONMENT HANDLING ----- */

	inline bool Inside(int x, int y)
	{
		return (x >= 0 && x < width && y >= 0 && y < height);
	}
	inline bool Outside(int x, int y) { return ! Inside(x, y); }

	inline location_c& Loc(int x, int y)
	{
		SYS_ASSERT(Inside(x, y));

		return locs[y * w() + x];
	}

	Fl_Color EnvColorAt(int x, int y);

	void SetEnv(int x, int y, char env, char mat, short area, char speed)
	{
		Loc(x, y).env = env;
		Loc(x, y).mat = mat;
		Loc(x, y).speed = speed;
		Loc(x, y).area = area;
	}

	void CopyEnv(int x, int y, int src_x, int src_y)
	{
		Loc(x, y).env = Loc(src_x, src_y).env;
		Loc(x, y).mat = Loc(src_x, src_y).mat;
		Loc(x, y).speed = Loc(src_x, src_y).speed;
		Loc(x, y).area = Loc(src_x, src_y).area;
//		Loc(x, y).floor_h = Loc(src_x, src_y).floor_h;
//		Loc(x, y).ceil_h = Loc(src_x, src_y).ceil_h;
	}

	/* ----- AREA HANDLING ----- */

	inline int NumAreas() const { return areas.size(); }

	inline area_c *Area(int index) const
	{
		SYS_ASSERT(index < NumAreas());

		return areas[index];
	}

	area_c *NewArea(int index, int focal_x, int focal_y);
	area_c *RandomArea();

	void PurgeDeadAreas();
	int RealAreas();

	/* ----- STAGE HANDLING ----- */

	inline int NumStages() const { return stages.size(); }

	inline stage_c *Stage(int index) const
	{
		SYS_ASSERT(index < NumStages());

		return stages[index];
	}

	stage_c *NewStage();

	void RenumberStages(int *mapping);
	// renumber the stage values using the given mapping.
	// This must be done before ComputeMiddle().

private:
	//...
};


extern world_c *the_world;


//------------------------------------------------------------------------
// UTILITY MACROS
//------------------------------------------------------------------------

#define FOR_LOC(x_var, y_var, loc_var)  \
	for (int y_var = 0; y_var < the_world->h(); y_var++)  \
	for (int x_var = 0; x_var < the_world->w(); x_var++)  \
	{  \
		location_c& loc_var = the_world->Loc(x_var, y_var);
 
#define FOR_LOC_IN_AREA(x_var, y_var, loc_var, AREA)  \
	for (int y_var = AREA->lo_y; y_var <= AREA->hi_y; y_var++)  \
	for (int x_var = AREA->lo_x; x_var <= AREA->hi_x; x_var++)  \
	{  \
		location_c& loc_var = the_world->Loc(x_var, y_var);  \
		if (! loc_var.Void() && loc_var.area == AREA->index)

#define FOR_AREA(ptr_var, idx_var)  \
	for (int idx_var = 0; idx_var < the_world->NumAreas(); idx_var++)  \
	{  \
		area_c *ptr_var = the_world->Area(idx_var);  \
		if (ptr_var)

#define FOR_NEIGHBOUR_IN_AREA(ar_ptr, nb_ptr, idx_var, AREA)  \
		for (int idx_var = 0; idx_var < (AREA)->NumNeighbours(); idx_var++)  \
		{  \
			neighbour_info_c *nb_ptr = & (AREA)->neighbours[idx_var];  \
			area_c *ar_ptr = nb_ptr->ptr;  \
			SYS_ASSERT(ar_ptr);

#define FOR_AREA_IN_STAGE(ptr_var, idx_var, ST_IDX)  \
	for (int idx_var = 0; idx_var < the_world->NumAreas(); idx_var++)  \
	{  \
		area_c *ptr_var = the_world->Area(idx_var);  \
		if (ptr_var && ptr_var->stage == (ST_IDX))

#define FOR_STAGE(ptr_var, idx_var)  \
	for (int idx_var = 0; idx_var < the_world->NumStages(); idx_var++)  \
	{  \
		stage_c *ptr_var = the_world->Stage(idx_var);


#endif /* __OBLIGE_WORLD_H__ */
