//------------------------------------------------------------------------
//  Mini Map
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2012 Andrew Apted
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
#include "hdr_fltk.h"
#include "hdr_ui.h"

#include "lib_util.h"
#include "main.h"


UI_MiniMap::UI_MiniMap(int x, int y, int w, int h, const char *label) :
	Fl_Box(x, y, w, h, label),
	pixels(NULL), cur_image(NULL)
{
	box(FL_NO_BOX);
}


UI_MiniMap::~UI_MiniMap()
{
	if (cur_image)
	{
		image(NULL);
		delete cur_image;
	}

	if (pixels)
		delete[] pixels;
}


void UI_MiniMap::EmptyMap()
{
	MapBegin();
	MapFinish();
}


void UI_MiniMap::MapBegin()
{
	map_W = w();
	map_H = h();

	if (pixels)
		delete[] pixels;

	pixels = new u8_t[map_W * map_H * 3];

	MapClear();
}


void UI_MiniMap::MapClear()
{
	memset(pixels, 0, map_W * map_H * 3);

	// draw the grid

	for (int py = 0 ; py < map_H ; py++)
	for (int px = 0 ; px < map_W ; px++)
	{
		u8_t *pix = pixels + (py*map_W + px) * 3;

		if ((px % 10) == 5 || (py % 10) == 5)
		{
			pix[2] = 176;
		}
	}
}


void UI_MiniMap::MapFinish()
{
	SYS_ASSERT(pixels);

	if (! alternate_look)
	{
		MapCorner(0, 0, 1, 1);
		MapCorner(0, map_H-1, 1, -1);
		MapCorner(map_W-1, 0, -1, 1);
		MapCorner(map_W-1, map_H-1, -1, -1);
	}

	if (cur_image)
	{
		image(NULL);
		delete cur_image;
	}

	cur_image = new Fl_RGB_Image(pixels, map_W, map_H);

	image(cur_image);
	redraw();
}


void UI_MiniMap::MapCorner(int x, int y, int dx, int dy)
{
	// we want to match the nearby background, but the "plastic" scheme
	// changes the color in a way we cannot easily duplicate.  This is an
	// approximation and may not work on different OSes.
	Fl_Color nearby_bg = fl_color_average(BUILD_BG, FL_WHITE, 0.5);

	u8_t r, g, b;

	Fl::get_color(nearby_bg, r, g, b);

	RawPixel(x+dx*0, y+dy*0, r, g, b);
	RawPixel(x+dx*1, y+dy*1, r, g, b);

	RawPixel(x+dx*1, y+dy*0, r, g, b);
	RawPixel(x+dx*2, y+dy*0, r, g, b);
	RawPixel(x+dx*3, y+dy*0, r, g, b);

	RawPixel(x+dx*0, y+dy*1, r, g, b);
	RawPixel(x+dx*0, y+dy*2, r, g, b);
	RawPixel(x+dx*0, y+dy*3, r, g, b);
}


void UI_MiniMap::DrawPixel(int x, int y, byte r, byte g, byte b)
{
	if (x < 0 || x >= map_W || y < 0 || y >= map_H)
		return;

	RawPixel(x, y, r, g, b);
}


void UI_MiniMap::DrawBox(int x1, int y1, int x2, int y2,
                         byte r, byte g, byte b)
{
	if (x1 < 0) x1 = 0;
	if (y1 < 0) y1 = 0;

	if (x2 >= map_W) x2 = map_W - 1;
	if (y2 >= map_H) y2 = map_H - 1;

	// fully clipped?
	if (x1 > x2 || y1 > y2)
		return;

	for (int y = y1; y <= y2; y++)
		for (int x = x1; x <= x2; x++)
			RawPixel(x, y, r, g, b);
}


void UI_MiniMap::DrawLine(int x1, int y1, int x2, int y2,
		byte r, byte g, byte b)
{
	int out1 = Calc_Outcode(x1, y1);
	int out2 = Calc_Outcode(x2, y2);

	if (out1 & out2)
		return;

	// handle simple (but common) cases of horiz/vert lines

	if (y1 == y2)
	{
		if (x1 > x2)
		{
			int tmp = x1; x1 = x2; x2 = tmp;
		}

		x1 = MAX(0, x1);
		x2 = MIN(map_W-1, x2);

		for (; x1 <= x2; x1++)
			RawPixel(x1, y1, r, g, b);

		return;
	}

	if (x1 == x2)
	{
		if (y1 > y2)
		{
			int tmp = y1; y1 = y2; y2 = tmp;
		}

		y1 = MAX(0, y1);
		y2 = MIN(map_H-1, y2);

		for (; y1 <= y2; y1++)
			RawPixel(x1, y1, r, g, b);

		return;
	}


	// clip diagonal line to the map
	// (this is the Cohen-Sutherland clipping algorithm)

	while (out1 | out2)
	{
		// may be partially inside box, find an outside point
		int outside = (out1 ? out1 : out2);

		int dx = x2 - x1;
		int dy = y2 - y1;

		// this almost certainly cannot happen, but for the sake of
		// robustness we check anyway (just in case)
		if (dx == 0 && dy == 0)
			return;

		int new_x, new_y;

		// clip to each side
		if (outside & O_BOTTOM)
		{
			new_y = 0;
			new_x = x1 + dx * (new_y - y1) / dy;
		}
		else if (outside & O_TOP)
		{
			new_y = map_H-1;
			new_x = x1 + dx * (new_y - y1) / dy;
		}
		else if (outside & O_LEFT)
		{
			new_x = 0;
			new_y = y1 + dy * (new_x - x1) / dx;
		}
		else
		{
			SYS_ASSERT(outside & O_RIGHT);

			new_x = map_W-1;
			new_y = y1 + dy * (new_x - x1) / dx;
		}

		if (out1)
		{
			x1 = new_x;
			y1 = new_y;

			out1 = Calc_Outcode(x1, y1);
		}
		else
		{
			SYS_ASSERT(out2);

			x2 = new_x;
			y2 = new_y;

			out2 = Calc_Outcode(x2, y2);
		}

		if (out1 & out2)
			return;
	}


	// this is the Bresenham line drawing algorithm
	// (based on code from am_map.c in the GPL DOOM source)

	int dx = x2 - x1;
	int dy = y2 - y1;

	int ax = 2 * (dx < 0 ? -dx : dx);
	int ay = 2 * (dy < 0 ? -dy : dy);

	int sx = dx < 0 ? -1 : 1;
	int sy = dy < 0 ? -1 : 1;

	int x = x1;
	int y = y1;

	if (ax > ay)  // horizontal stepping
	{
		int d = ay - ax/2;

		RawPixel(x, y, r, g, b);

		while (x != x2)
		{
			if (d>=0)
			{
				y += sy;
				d -= ax;
			}

			x += sx;
			d += ay;

			RawPixel(x, y, r, g, b);
		}
	}
	else   // vertical stepping
	{
		int d = ax - ay/2;

		RawPixel(x, y, r, g, b);

		while (y != y2)
		{
			if (d >= 0)
			{
				x += sx;
				d -= ay;
			}

			y += sy;
			d += ax;

			RawPixel(x, y, r, g, b);
		}
	}
}


void UI_MiniMap::DrawEntity(int x, int y, byte r, byte g, byte b)
{
	if (x < 1 || x > map_W-2 || y < 1 || y > map_H-2)
		return;

	RawPixel(x, y, r, g, b);

	r = (r / 4) * 3;
	g = (g / 4) * 3;
	b = (b / 4) * 3;

	RawPixel(x-1, y, r, g, b);
	RawPixel(x+1, y, r, g, b);
	RawPixel(x, y-1, r, g, b);
	RawPixel(x, y+1, r, g, b);
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
