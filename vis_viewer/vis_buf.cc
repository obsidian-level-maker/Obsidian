//------------------------------------------------------------------------
//
//  Visibility Buffer
//
//  Copyright (C) 2009 Andrew Apted
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


class Vis_Buffer
{
private:
	int W, H;  // size

	short * data;

public:
	Vis_Buffer(int width, int height) :
    	W(width), H(height)
	{
		data = new short[W * H];

		memset(data, 0, sizeof(short) * W * H);
	}

	~Vis_Buffer()
	{
		delete[] data;
	}

public:
	
};


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
