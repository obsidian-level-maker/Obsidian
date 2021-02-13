//------------------------------------------------------------------------
//
//  Visibility Buffer
//
//  Copyright (C) 2009-2010 Andrew Apted
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

#include "headers.h"
#include "main.h"

#include "vis_buffer.h"


#define MAX_RECURSION  4


Vis_Buffer::Vis_Buffer(int width, int height) :
      W(width), H(height), quick_mode(false),
      flip_x(0), flip_y(0), saved_cells()
{
	data = new short[W * H];

	Clear();
}

Vis_Buffer::~Vis_Buffer()
{
	delete[] data;
}


void Vis_Buffer::Clear()
{
	memset(data, 0, sizeof(short) * W * H);
}


void Vis_Buffer::SetQuickMode(bool enable)
{
	quick_mode = enable;
}


void Vis_Buffer::AddWall(int x, int y, int side)
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


bool Vis_Buffer::TestWall(int x, int y, int side)
{
	side = Trans_Side(side);

	if (side == 6)
	{
		if (flip_x) x--; else x++;
		side = 4;
	}

	if (side == 8)
	{
		if (flip_y) y--; else y++;
		side = 2;
	}

	if (! isValid(x, y))
		return true;

	if (side == 2)
		return (at(x, y) & V_BOTTOM) ? true : false;
	else
		return (at(x, y) & V_LEFT) ? true : false;
}


void Vis_Buffer::AddDiagonal(int x, int y, int dir)
{
	if (! isValid(x, y))
		return;

	if (dir == 1 || dir == 9)
		at(x, y) |= V_DIAG_NE;
	else
		at(x, y) |= V_DIAG_SE;
}


void Vis_Buffer::ReadMap(const char *filename)
{
	FILE *fp = fopen(filename, "r");
	if (! fp)
		Main_FatalError("No such file: %s\n", filename);

	int x, y, side;

	while (fscanf(fp, " %d %d %d ", &x, &y, &side) == 3)
	{
		if (side & 1)
			AddDiagonal(x, y, side);
		else
			AddWall(x, y, side);
	}

	fclose(fp);
}


void Vis_Buffer::WriteMap(const char *filename)
{
	FILE *fp = fopen(filename, "w");
	if (! fp)
		Main_FatalError("Cannot create file: %s\n", filename);

	for (int y = 0 ; y < H ; y++)
	for (int x = 0 ; x < W ; x++)
	{
		if (at(x, y) & V_BOTTOM) fprintf(fp, "%d %d %d\n", x, y, 2);
		if (at(x, y) & V_LEFT)   fprintf(fp, "%d %d %d\n", x, y, 4);
	}

	fclose(fp);
}


//------------------------------------------------------------------------

void Vis_Buffer::DoBasic(int dx, int dy, int side)
{
	int x = loc_x;
	int y = loc_y;

	int L = 0, R = 0;

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
		while (isValid( x+dy*(L+1), y+dx*(L+1)) &&
				TestWall(x+dy*(L+1), y+dx*(L+1), side))
			L++;

		while (isValid( x-dy*(R+1), y-dx*(R+1)) &&
				TestWall(x-dy*(R+1), y-dx*(R+1), side))
			R++;

		x += dx; y += dy;

		if (! isValid(x, y))
			return;

		for (int j = -R ; j <= L ; j++)
			at(x+dy*j, y+dx*j) |= V_BASIC;
	}
}


void Vis_Buffer::DoFill()
{
	// NOTE: assumes transform is already set (by DoSteps)

	for (int dy = 0 ; dy < H ; dy++)
	for (int dx = 0 ; dx < W ; dx++)
	{
		// if (dx == 0 && dy == 0)
		//    continue;

		int sx = loc_x + dx;
		int sy = loc_y + dy;

		if (! isValid(loc_x, sy+1))
			return;
		if (! isValid(sx+1, loc_y))
			break;

		if (! (at(sx+1, sy+1) & V_ANY) &&
				((at(sx+1, sy)   & V_ANY) || TestWall(sx+1, sy, 8)) &&
				((at(sx,   sy+1) & V_ANY) || TestWall(sx, sy+1, 6))
		   )
		{
			at(sx+1, sy+1) |= V_FILL;
		}
	}
}


void Vis_Buffer::AddStep(Stair_Steps& dest, int x, int y, int side)
{
	Stair_Pos pos;

	pos.x = x;
	pos.y = y;
	pos.side = side;

	dest.push_back(pos);
}


void Vis_Buffer::CopySteps(Stair_Steps& dest, const Stair_Steps& src)
{
	for (unsigned int i = 0 ; i < src.size() ; i++)
		dest.push_back(src[i]);
}


void Vis_Buffer::MarkSteps(const Stair_Steps& steps)
{
	if (steps.size() < 2)
		return;

	// determine bounding box
	int lx = steps.front().x;
	int ly = steps.back().y;

	int ww = steps.back().x  - lx;
	int hh = steps.front().y - ly;

	if (steps.back().side == 2)
		ww++;

	if (steps.front().side == 4)
		hh++;

	// skip if too small
	if (lx > loc_x && ww <= 1 && ly > loc_y && hh <= 1)
		return;

	// fill in the "gaps" inside the bbox (behind the stair-step)
	for (unsigned int i = 0 ; i < steps.size() ; i++)
	{
		if (steps[i].side == 4)
		{
			for (int sx = steps[i].x ; sx < lx+ww ; sx++)
				at(sx, steps[i].y) |= V_LSHAPE;
		}
	}

	// if stair-step covers whole quadrant, then we don't need
	// to look for other stair-steps behind the current one.
	if (lx == loc_x && ly == loc_y)
	{
		limit_x = lx + ww;
		limit_y = ly + hh;
	}

	if (quick_mode)
		return;

	// normal case : mark all squares in the quadrant which lie
	// in the shadow area cast by the stair-step's bounding box.

	double tx = lx - loc_x;
	double ty = ly - loc_y + hh - 1;

	double bx = lx - loc_x + ww - 1;
	double by = ly - loc_y;

	if (bx == 0 && ly > loc_y)
		return;

	for (int nx = loc_x ; nx < loc_x+W ; nx++)
	{
		if (! isValid(nx, loc_y))
			return;

		int y1 = loc_y;
		int y2 = loc_y+H;

		if (lx > loc_x)
		{
			double z = loc_y + 1 + (nx - loc_x) * ty / tx;
			y2 = (int)floor(z) - 1;
		}

		if (ly > loc_y)
		{
			double z = loc_y + (nx - loc_x) * by / bx;
			y1 = (int)ceil(z);
		}

		if (nx < lx + ww)
			y1 = MAX(y1, ly + hh);

		for (int ny = y1 ; ny <= y2 && isValid(nx, ny) ; ny++)
		{
			at(nx, ny) |= V_SPAN;
		}
	}
}


void Vis_Buffer::FollowStair(Stair_Steps& steps, int sx, int sy, int side, int recursion)
{
	AddStep(steps, sx, sy, side);

	for (;;)
	{
		if (side == 2)
		{
			sx++;
			if (! isValid(sx, sy)) break;

			bool go_right = TestWall(sx, sy, 2);
			bool go_down  = (sy-1 >= loc_y) && TestWall(sx, sy-1, 4);

			// handle branches with recursion
			if (go_right && go_down && recursion < MAX_RECURSION)
			{
				Stair_Steps other;
				CopySteps(other, steps);

				FollowStair(other, sx, sy, 2, recursion+1);
				go_right = false;
			}

			if (go_right)
			{
				// OK
			}
			else if (go_down)
			{
				sy--;  // OK
				side = 4;
			}
			else
				break;
		}
		else
		{
			/// assert(side == 4);

			if (sy <= loc_y) break;

			bool go_right = TestWall(sx, sy, 2);
			bool go_down  = (sy-1 >= loc_y) && TestWall(sx, sy-1, 4);

			// handle branches with recursion
			if (go_right && go_down && recursion < MAX_RECURSION)
			{
				// recursive bit
				Stair_Steps other;
				CopySteps(other, steps);

				FollowStair(other, sx, sy, 2, recursion+1);
				go_right = false;
			}

			if (go_right)
			{
				side = 2;
			}
			else if (go_down)
			{
				sy--;  // OK
			}
			else
				break;
		}

		AddStep(steps, sx, sy, side);
	}

	MarkSteps(steps);
}


void Vis_Buffer::DoSteps(int quadrant)
{
	flip_x = (quadrant & 1);
	flip_y = (quadrant & 2);

	limit_x = W;
	limit_y = H;

	for (int dy = 0 ; dy < limit_y ; dy++)
	for (int dx = 0 ; dx < limit_x ; dx++)
	{
		int sx = loc_x + dx;
		int sy = loc_y + dy;

		if (! isValid(loc_x, sy))
			return;
		if (! isValid(sx, sy))
			break;

		if (  (dy > 0 && TestWall(sx, sy, 2)) &&
				! (dx > 0 && TestWall(sx-1, sy, 2)) &&
				! (dx > 0 && TestWall(sx, sy, 4)) )
		{
			Stair_Steps base;
			FollowStair(base, sx, sy, 2, 0);
		}

		if (  (dx > 0 && TestWall(sx, sy, 4)) &&
				! (          TestWall(sx-1, sy, 8)) &&
				! (isValid(sx, sy+1) && TestWall(sx, sy+1, 4)) )
		{
			Stair_Steps base;
			FollowStair(base, sx, sy, 4, 0);
		}
	}
}


//------------------------------------------------------------------------

#define V_UNLOCK  0x2000

void Vis_Buffer::FloodEmpties()
{
	// a blocked cell which neighbors an unblocked cell (with no wall in
	// the way) will become unblocked.  The trick is to prevent flow-on
	// effects, and that is what V_UNLOCK is for.

	for (int y = 0 ; y < H ; y++)
	for (int x = 0 ; x < W ; x++)
	{
		if (at(x, y) & V_ANY)
			continue;

		for (int side = 2 ; side <= 8 ; side += 2)
		{
			int nx = x + ((side == 4) ? -1 : (side == 6) ? +1 : 0);
			int ny = y + ((side == 2) ? -1 : (side == 8) ? +1 : 0);

			if (isValid(nx, ny) && (at(nx, ny) & V_ANY) && ! TestWall(x, y, side))
			{
				at(nx, ny) |= V_UNLOCK;
			}
		}
	}

	for (int y = 0 ; y < H ; y++)
	for (int x = 0 ; x < W ; x++)
	{
		if (at(x, y) & V_UNLOCK)
		{
			at(x, y) &= ~V_ANY;  // clears V_UNLOCK too
		}
	}
}


void Vis_Buffer::FloodFill(int passes)
{
	for (; passes > 0 ; passes--)
	{
		FloodEmpties();
	}
}


void Vis_Buffer::Truncate(int dist)
{
	for (int y = 0 ; y < H ; y++)
	for (int x = 0 ; x < W ; x++)
	{
		int dx = abs(x - loc_x);
		int dy = abs(y - loc_y);

		if (dx*dx + dy*dy >= dist*dist)
		{
			at(x, y) |= V_FILL;
		}
	}
}


//------------------------------------------------------------------------

void Vis_Buffer::AddWallSave(int x, int y, int side)
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

	// save original contents (mask out vis results)
	Stair_Pos pos;

	pos.x = x;
	pos.y = y;
	pos.side = at(x, y) & ~V_ANY;

	saved_cells.push_back(pos);

	if (side == 2)
		at(x, y) |= V_BOTTOM;
	else
		at(x, y) |= V_LEFT;
}


void Vis_Buffer::ConvertDiagonals()
{
	// the algorithms above do not handle diagonals directly.
	// instead we convert them to normal walls based on the source loc.
	// we need to restore those changes afterwards.

	for (int y = 0 ; y < H ; y++)
	for (int x = 0 ; x < W ; x++)
	{
		if (x == loc_x && y == loc_y)
			continue;

		short se = (at(x, y) & V_DIAG_SE);
		short ne = (at(x, y) & V_DIAG_NE);

		if (se && loc_x <= x && loc_y <= y)
		{
			AddWallSave(x, y, 6);
			AddWallSave(x, y, 8);
		}
		if (se && loc_x >= x && loc_y >= y)
		{
			AddWallSave(x, y, 2);
			AddWallSave(x, y, 4);
		}

		if (ne && loc_x >= x && loc_y <= y)
		{
			AddWallSave(x, y, 4);
			AddWallSave(x, y, 8);
		}
		if (ne && loc_x <= x && loc_y >= y)
		{
			AddWallSave(x, y, 2);
			AddWallSave(x, y, 6);
		}
	}
}


void Vis_Buffer::RestoreDiagonals()
{
	// need to go backwards (opposite to the add order)

	int total = (int)saved_cells.size();

	for (int i = total-1 ; i >= 0 ; i--)
	{
		const Stair_Pos & pos = saved_cells[i];

		at(pos.x, pos.y) &= V_ANY;
		at(pos.x, pos.y) |= pos.side;
	}

	saved_cells.clear();
}


void Vis_Buffer::SimplifySolid()
{
	// this removes walls which lie between two solid cells, in order
	// to prevent the need for excessive recursion in FollowStair().

	for (int y = 0 ; y < H ; y++)
	for (int x = 0 ; x < W ; x++)
	{
		at(x, y) &= ~V_BASIC;

		if (TestWall(x, y, 2) && TestWall(x, y, 4) &&
				TestWall(x, y, 6) && TestWall(x, y, 8))
		{
			at(x, y) |= V_BASIC;
		}
	}

	for (int y = 0 ; y < H ; y++)
	for (int x = 0 ; x < W ; x++)
	{
		if (! (at(x, y) & V_BASIC))
			continue;

		if (x < (W-1) && (at(x+1, y) & V_LEFT) &&
						 (at(x+1, y) & V_BASIC))
		{
			at(x+1, y) &= ~V_LEFT;
		}

		if (y < (H-1) && (at(x, y+1) & V_BOTTOM) &&
						 (at(x, y+1) & V_BASIC))
		{
			at(x, y+1) &= ~V_BOTTOM;
		}
	}
}


void Vis_Buffer::ClearVis()
{
	int len = W * H;

	for (int i = 0 ; i < len ; i++)
		data[i] &= ~V_ANY;
}


void Vis_Buffer::ProcessVis(int x, int y)
{
	loc_x = x;
	loc_y = y;

	ConvertDiagonals();

	DoBasic(-1, 0, 4);  DoBasic(0, -1, 2);
	DoBasic(+1, 0, 6);  DoBasic(0, +1, 8);

	DoSteps(0);  DoFill();
	DoSteps(1);  DoFill();
	DoSteps(2);  DoFill();
	DoSteps(3);  DoFill();

	flip_x = flip_y = 0;

	RestoreDiagonals();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
