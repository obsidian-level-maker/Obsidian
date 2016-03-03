//------------------------------------------------------------------------
//  GRID : Draws the map (lines, nodes, etc)
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

#ifndef __OBLIGE_GRID_H__
#define __OBLIGE_GRID_H__

class W_Grid : public Fl_Widget
{
public:
	W_Grid(int X, int Y, int W, int H, const char *label = 0);
	~W_Grid();

	void SetZoom(int new_zoom);
	// changes the current zoom factor.

	void SetPos(double new_x, double new_y);
	// changes the current position.

	void FitBBox(double lx, double ly, double hx, double hy);
	// create block array from level (using given bounds).
	// set zoom and position so that the bounding area fits.

	void MapToWin(double mx, double my, int *X, int *Y) const;
	// convert a map coordinate into a window coordinate, using
	// current grid position and zoom factor.

	void WinToMap(int X, int Y, double *mx, double *my) const;
	// convert a map coordinate into a window coordinate, using
	// current grid position and zoom factor.

public:
	int handle(int event);
	// FLTK virtual method for handling input events.

	void resize(int X, int Y, int W, int H);
	// FLTK virtual method for resizing.

private:
	void draw();
	// FLTK virtual method for drawing.

	void draw_grid(int spacing);
	void draw_one_block(int bx, int by);
	void highlight_one_block(int bx, int by);

	void draw_line(double x1, double y1, double x2, double y2);
	void draw_block(double x1, double y1, double ww, double hh);

	void scroll(int dx, int dy);

public:
	int handle_key(int key);
	void handle_mouse(int mx, int my);

private:
	int zoom;
	// zoom factor: (2 ^ (zoom/2)) pixels per 64 units on the map

	double zoom_mul;
	// derived from 'zoom'.

	static const int MIN_GRID_ZOOM =  0;
	static const int OTO_GRID_ZOOM = 12;  // 1:1 ratio
	static const int MAX_GRID_ZOOM = 14;

	inline void UpdateZoomMul()
	{
		zoom_mul = pow(2.0, (zoom - OTO_GRID_ZOOM) / 2.0);
	}

	double mid_x;
	double mid_y;

	int grid_MODE;
	int partition_MODE;
	int miniseg_MODE;
	int shade_MODE;

	int block_x, block_y;

	int mouse_bx, mouse_by;
	int ht_area;

	static inline int GRID_FIND(double x, double y)
	{
		return int(x - fmod(x,y) + (x < 0) ? y : 0);
	}

	static const int O_TOP    = 1;
	static const int O_BOTTOM = 2;
	static const int O_LEFT   = 4;
	static const int O_RIGHT  = 8;

	static int MAP_OUTCODE(double x, double y,
		double lx, double ly, double hx, double hy)
	{
		return
			((y < ly) ? O_BOTTOM : 0) |
			((y > hy) ? O_TOP    : 0) |
			((x < lx) ? O_LEFT   : 0) |
			((x > hx) ? O_RIGHT  : 0);
    }

	static bool AreaBoundary(int x1, int y1, int x2, int y2, int a_idx);
};

#endif /* __OBLIGE_GRID_H__ */
