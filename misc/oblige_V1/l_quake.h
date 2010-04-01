//------------------------------------------------------------------------
//  LEVEL building - Quake style
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

#ifndef __OBLIGE_LQUAKE_H__
#define __OBLIGE_LQUAKE_H__


namespace level_quake
{

class brush_c
{
public:
	brush_c(short _x, short _y, short _low, short _high, const char *_tex);
	virtual ~brush_c();

	short x, y;
	short low, high;

	char tex_name[20];
};


class entity_c
{
public:
	entity_c(short _x, short _y, short _z, short _type);
	virtual ~entity_c();

	short x, y, z;
	short angle;  // degress
	short type;
	short options;
	short light_ity;

public:
	const char *ClassName() const
	{
		if (type == 1) return "info_player_start"; //!!!!
		if (type == 2) return "light_flame_small_white";
		return "monster_dog";
	}
};


//------------------------------------------------------------------------

void AddThing(short x, short y, short type);

void WriteText(const char *filename);

}  // namespace level_quake

#endif /* __OBLIGE_LQUAKE_H__ */
