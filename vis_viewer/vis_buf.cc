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


#define V_BOTTOM  0x0001
#define V_LEFT    0x0002 


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

		Clear();
	}

	~Vis_Buffer()
	{
		delete[] data;
	}

public:
	inline bool isValid(int x, int y)
	{
		return (0 <= x && x < W) && (0 <= y && y < H);
	}

	inline short& at(int x, int y)
	{
		return data[y * W + x];
	}

	void Clear()
	{
		memset(data, 0, sizeof(short) * W * H);
	}

	void AddWall(int x, int y, int side)
	{
		if (side == 6)
		{
			x++; side = 4;
		}

		if (side == 8)
		{
			y++; side = 2;
		}

		if (! isValid(x, y))
			return;

		if (side == 2)
			at(x, y) |= V_BOTTOM;
		else
			at(x, y) |= V_LEFT;
	}

	bool TestWall(int x, int y, int side)
	{
		if (side == 6)
		{
			x++; side = 4;
		}

		if (side == 8)
		{
			y++; side = 2;
		}

		if (! isValid(x, y))
			return true;

		if (side == 2)
			return (at(x, y) & V_BOTTOM) ? true : false;
		else
			return (at(x, y) & V_LEFT) ? true : false;
	}

	void ReadMap(const char *filename)
	{
		FILE *fp = fopen(filename, "r");
		if (! fp)
			FatalError("No such file: %s\n", filename);

		int x, y, side;

		while (fscanf(fp, " %d %d %d ", &x, &y, &side) == 3)
		{
			AddWall(x, y, side);
		}

		fclose(fp);
	}
};


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
