//------------------------------------------------------------------------
//  WORLD
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

#ifndef __OBLIGE_WENUMS_H__
#define __OBLIGE_WENUMS_H__


typedef enum
{
	ENV_EMPTY = 0,
	ENV_VOID,

	ENV_Land, ENV_Water,
	ENV_Building, ENV_Cave
}
world_environment_e;


typedef enum
{
	MAT_INVALID = 0,

	// Land
	MAT_Grass, MAT_Sand, MAT_Rock,  MAT_Stone,

	// Water
	MAT_Water,  MAT_Lava, MAT_Nukage, MAT_Slime, MAT_Blood,

	// Building
	MAT_Lead, MAT_Alum,  MAT_Tech, MAT_Light,
	MAT_Wood, MAT_Brick, MAT_Marble,

	// Cave
	MAT_Ash 
}
world_material_e;


typedef enum
{
	STRU_INVALID = 0,

	// simple floor/ceiling stuff
	STRU_CoopStart,
	STRU_DM_Start,

	STRU_Item,
	STRU_Monster,

	STRU_Teleporter,
	STRU_LandingPad,

	STRU_Tunnel,

	// more complex 3D stuff
	STRU_Wall,
	STRU_Window,
	STRU_Railing,
	STRU_Railing2,  //TEMP

	STRU_Door,
	STRU_Bars,
	STRU_Lift,
	STRU_Stairs,

	STRU_Switch,

	//...
}
world_structure_e;


#endif /* __OBLIGE_WENUMS_H__ */
