//------------------------------------------------------------------------
//  LEVEL building - DOOM format
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

#ifndef __OBLIGE_LDOOM_H__
#define __OBLIGE_LDOOM_H__


namespace level_doom
{

class vertex_c
{
public:
	vertex_c(short _x, short _y);
	virtual ~vertex_c();

public:
	short x, y;

	int wad_index;

	inline bool Match(short _x, short _y) const
	{
		return (x == _x) && (y == _y);
	}
};


class sector_c
{
public:
	sector_c(const char *_ftex, const char *_ctex, short _fh, short _ch);
	virtual ~sector_c();
	
public:
	char floor_tex[10];
	char ceil_tex[10];

	short floor_h;
	short ceil_h;

	short light;
	short type;
	short tag;

	int wad_index;
};


class sidedef_c
{
public:
	sidedef_c();
	~sidedef_c();

public:
	sector_c *sec;  // NULL means no side (void space)

	char upper_tex[10];
	char lower_tex[10];
	char mid_tex[10];

	short x_offset;
	short y_offset;

public:
	void SetTex(const char *_upper, const char *_lower, const char *_mid);
};


class linedef_c
{
public:
	linedef_c(vertex_c *_s, vertex_c *_e);
	virtual ~linedef_c();

public:
	vertex_c *start;
	vertex_c *end;

	sidedef_c front;
	sidedef_c back;

	short flags;
	short type;
	short tag;

public:
	void Flip();
};


class thing_c
{
public:
	thing_c(short _x, short _y, short _type);
	virtual ~thing_c();

	short x;
	short y;
	short angle;  // degress
	short type;
	short options;
};


//------------------------------------------------------------------------

void AddThing(short x, short y, short type);

void WriteText(const char *filename);
void WriteWAD(const char *filename);

} // namespace level_doom

#endif /* __OBLIGE_LDOOM_H__ */
