//------------------------------------------------------------------------
//  CONTROL Panel
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

#ifndef __OBLIGE_CONTROL_H__
#define __OBLIGE_CONTROL_H__

class W_Posit;
class W_Environ;
class W_Area;


class W_Control : public Fl_Group
{
public:
	W_Control(int X, int Y, int W, int H, const char *label = 0);
	~W_Control();

private:
	W_Posit *posit;
	W_Environ *environ;
	W_Area *area;

public:
	void UpdatePos(int bx, int by, int mx, int my);

	void UpdateEnv(const location_c& loc);
};

#endif /* __OBLIGE_CONTROL_H__ */
