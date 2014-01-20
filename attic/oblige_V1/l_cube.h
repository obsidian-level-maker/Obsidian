//------------------------------------------------------------------------
//  LEVEL building - Cube exporter
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

#ifndef __OBLIGE_LCUBE_H__
#define __OBLIGE_LCUBE_H__


namespace level_cube
{

class entity_c
{
public:
	entity_c(short _x, short _y, short _z, short _type);
	virtual ~entity_c();

	short x, y, z;
	short type;
	short attrs[4];
};


//------------------------------------------------------------------------

void AddThing(short x, short y, short type);

void WriteCube(const char *filename);

}  // namespace level_cube


#endif /* __OBLIGE_LCUBE_H__ */
