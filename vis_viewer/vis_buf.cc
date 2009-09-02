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
#define V_SPAN    0x0020   // long spans
#define V_LSHAPE  0x0040   // L shape testing
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

	void FillHorizSpan(int x, int y, int sp_x1, int sp_x2, int sp_y)
	{
#if 0
if (sp_y <= y) return;  // TODO
if (sp_x2 < x+1) return;
if (sp_x1 < x) sp_x1 = x;

if (sp_y == y+1 && sp_x1 > x) return;

if (sp_x1 != x) return; // FIXME

		for (int nx = sp_x1; nx < W; nx++)
		for (int ny = y+1;   ny < H; ny++)
		{
		}
#endif
	}

	void HorizSpansAtY(int x, int y, int sp_y)
	{
		if (sp_y < 1 || sp_y >= H)
			return;

		int sp_x = 0;

		while (sp_x < W-1)
		{
			if (! TestWall(sp_x, sp_y, 2))
			{
				sp_x++; continue;
			}

			int len = 1;

			while (sp_x+len < W && TestWall(sp_x+len, sp_y, 2))
				len++;

			if (len > 1)
			{
				FillHorizSpan(x, y, sp_x, sp_x+len-1, sp_y);
			}

			sp_x += (len + 1);
		}
	}

	void HorizSpans(int x, int y)
	{
		for (int dy = 0; dy < H; dy++)
		{
			HorizSpansAtY(x, y, y-dy);
			HorizSpansAtY(x, y, y+dy+1);
		}
	}

	void FillVertSpan(int x, int y, int sp_x, int sp_y1, int sp_y2)
	{
		if (sp_y1 < y) sp_y1 = y;

		if (sp_y2 <= sp_y1) return;

		if (sp_y1 > y && sp_x == x+1) return;

		double tx = sp_x - x;
		double ty = sp_y2 - y;

		double bx = sp_x - x - 1;
		double by = sp_y1 - y;

		for (int nx = sp_x; nx < W; nx++)
		{
			int y_low = y;

			double dx = nx - x;

			double y_c = dx * ty / tx;

			int y_high = y + (int)floor(y_c);

			if (by > 0)
			{
				double y_d = dx * by / bx;

				y_low = y + (int)floor(y_d);
			}

			if (y_low  >= H) y_low  = H-1;
			if (y_high >= H) y_high = H-1;

			for (int ny = y_low; ny <= y_high; ny++)
			{
				at(nx, ny) |= V_SPAN;
			}
		}
	}

	void VertSpansAtX(int x, int y, int sp_x)
	{
		if (sp_x < 1 || sp_x >= W)
			return;

if (sp_x <= x) return;  // FIXME

		int sp_y = 0;

		while (sp_y < H-1)
		{
			if (! TestWall(sp_x, sp_y, 4))
			{
				sp_y++; continue;
			}

			int len = 1;

			while (sp_y+len < H && TestWall(sp_x, sp_y+len, 4))
				len++;

			FillVertSpan(x, y, sp_x, sp_y, sp_y+len-1);

			sp_y += (len + 1);
		}
	}

	void VertSpans(int x, int y)
	{
		for (int dx = 0; dx < W; dx++)
		{
			VertSpansAtX(x, y, x-dx);
			VertSpansAtX(x, y, x+dx+1);
		}
	}

	void FollowStair(int x, int y, int sx, int sy, int side)
	{
		at(sx, sy) |= V_SPAN;

		for (;;)
		{
			if (side == 2)
			{
				sx++;
				if (sx >= W) return;

				if (TestWall(sx, sy, 2))
				{
					// OK
				}
				else if (sy-1 >= y && TestWall(sx, sy-1, 4))
				{
					sy--;  // OK
					side = 4;
				}
				else
					return;
			}
			else
			{
				assert(side == 4);

				if (sy == y) return;

				if (sy-1 >= y && TestWall(sx, sy-1, 4))
				{
					sy--;  // OK
				}
				else if (TestWall(sx, sy, 2))
				{
					// OK
					side = 2;
				}
				else
					return;
			}

			at(sx, sy) |= V_BASIC;
		}
	}

	void DoSteps(int x, int y)
	{
		for (int dy = 0; dy < H-y; dy++)
		for (int dx = 0; dx < W-x; dx++)
		{
			int sx = x + dx;
			int sy = y + dy;

			assert(isValid(sx, sy));

			if (  (dy > 0 && TestWall(sx, sy, 2)) &&
			    ! (dx > 0 && TestWall(sx-1, sy, 2)) &&
				! (dx > 0 && TestWall(sx, sy, 4)) )
			{
				FollowStair(x, y, sx, sy, 2);
			}

			if (  (dx > 0 && TestWall(sx, sy, 4)) &&
			    ! (          TestWall(sx-1, sy, 8)) &&
				! (sy+1 < H && TestWall(sx, sy+1, 4)) )
			{
				FollowStair(x, y, sx, sy, 4);
			}
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
//		DoBasic(x, y, -1, 0, 4); DoBasic(x, y, 0, -1, 2);
//		DoBasic(x, y, +1, 0, 6); DoBasic(x, y, 0, +1, 8);

		// HorizSpans(x, y); VertSpans(x, y);

		DoSteps(x, y);
	}

	int GetVis(int x, int y)
	{
		short d = at(x, y);

		if (d & V_SPAN)   return 2;
  		if (d & V_BASIC)  return 1;
		if (d & V_LSHAPE) return 3;
		if (d & V_WONKA)  return 4;

		return 0;
	}
};


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
