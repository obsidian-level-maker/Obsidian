//------------------------------------------------------------------------
//  LEVEL building - Wolf3d format
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

#ifndef __OBLIGE_LWOLF_H__
#define __OBLIGE_LWOLF_H__


namespace level_wolf
{

class thing_c
{
public:
	thing_c(short _x, short _y, short _type);
	virtual ~thing_c();

	short x, y;
	short type;
};


//------------------------------------------------------------------------

void AddThing(short x, short y, short type);

void Construct();

void WriteWolf();

void Cleanup();

} // namespace level_wolf

#endif /* __OBLIGE_LWOLF_H__ */
