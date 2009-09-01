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


// map data
#define V_BOTTOM  0x0001
#define V_LEFT    0x0002 


// vis results
#define V_BASIC   0x0010   // ultra basic
#define V_LSHAPE  0x0020   // L shape testing
#define V_SPAN    0x0040   // long spans
#define V_WONKA   0x0080   // Wonka's (et al) method


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

private:
	void DoBasic(int x, int y, int dx, int dy, int side)
	{
		for (;;)
		{
			if (! isValid(x, y))
				return;

			if (TestWall(x, y, side))
				break;

			x += dx; y += dy;
		}

		for (;;)
		{
			x += dx; y += dy;

			if (! isValid(x, y))
				return;

			at(x, y) |= V_BASIC;
		}
	}

public:
	void ClearVis()
	{
		int len = W * H;

		for (int i = 0; i < len; i++)
			data[i] &= 7;
	}

	void ProcessVis(int x, int y)
	{
		DoBasic(x, y, -1, 0, 4); DoBasic(x, y, 0, -1, 2);
		DoBasic(x, y, +1, 0, 6); DoBasic(x, y, 0, +1, 8);
	}

	int GetVis(int x, int y)
	{
		short d = at(x, y);

		if (d & V_BASIC)  return 1;
		if (d & V_LSHAPE) return 2;
		if (d & V_SPAN)   return 3;
		if (d & V_WONKA)  return 4;

		return 0;
	}
};


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
