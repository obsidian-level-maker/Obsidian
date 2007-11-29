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

// this includes everything we need
#include "defs.h"


#if 0
static void foo_win_close_CB(Fl_Widget *w, void *data)
{
}
#endif


//
// W_Grid Constructor
//
W_Grid::W_Grid(int X, int Y, int W, int H, const char *label) : 
        Fl_Widget(X, Y, W, H, label),
        zoom(OTO_GRID_ZOOM), zoom_mul(1.0),
        mid_x(0), mid_y(0),
		grid_MODE(1), partition_MODE(1), miniseg_MODE(2), shade_MODE(1),
		mouse_bx(-1), mouse_by(-1), ht_area(-1)
{
	block_x = the_world->w() * -32;
	block_y = the_world->h() * -32;

	FitBBox(block_x, block_y,
			block_x + the_world->w() * 64, block_y + the_world->h() * 64);
}

//
// W_Grid Destructor
//
W_Grid::~W_Grid()
{ }


void W_Grid::SetZoom(int new_zoom)
{
	if (new_zoom < MIN_GRID_ZOOM)
		new_zoom = MIN_GRID_ZOOM;

	if (new_zoom > MAX_GRID_ZOOM)
		new_zoom = MAX_GRID_ZOOM;

	if (zoom == new_zoom)
		return;

	zoom = new_zoom;

	UpdateZoomMul();

	//  fprintf(stderr, "Zoom %d  Mul %1.5f\n", zoom, zoom_mul);

	redraw();
}


void W_Grid::SetPos(double new_x, double new_y)
{
	mid_x = new_x;
	mid_y = new_y;

	redraw();
}

void W_Grid::FitBBox(double lx, double ly, double hx, double hy)
{
	double dx = hx - lx;
	double dy = hy - ly;

	zoom = MAX_GRID_ZOOM;

	for (; zoom > MIN_GRID_ZOOM; zoom--)
	{
		UpdateZoomMul();

		if (dx * zoom_mul < w() && dy * zoom_mul < h())
			break;
	}

	UpdateZoomMul();

	SetPos(lx + dx / 2.0, ly + dy / 2.0);
}



void W_Grid::MapToWin(double mx, double my, int *X, int *Y) const
{
	double hx = x() + w() / 2.0;
	double hy = y() + h() / 2.0;

	(*X) = I_ROUND(hx + (mx - mid_x) * zoom_mul);
	(*Y) = I_ROUND(hy - (my - mid_y) * zoom_mul);
}

void W_Grid::WinToMap(int X, int Y, double *mx, double *my) const
{
	double hx = x() + w() / 2.0;
	double hy = y() + h() / 2.0;

	(*mx) = mid_x + (X - hx) / zoom_mul;
	(*my) = mid_y - (Y - hy) / zoom_mul;
}

//------------------------------------------------------------------------

void W_Grid::resize(int X, int Y, int W, int H)
{
	Fl_Widget::resize(X, Y, W, H);
}

void W_Grid::draw()
{
	fl_push_clip(x(), y(), w(), h());

	fl_color(FL_BLACK);
	fl_rectf(x(), y(), w(), h());

	if (zoom >= OTO_GRID_ZOOM-9)
	{
		fl_color(fl_color_cube(0, 0, 1));
		draw_grid(64);
	}

	fl_color(fl_color_cube(0, 0, 3));
	draw_grid(512);

	fl_color(fl_color_cube(0, 3, 4));
	draw_grid(16384);

	for (int bx = 0; bx < the_world->w(); bx++)
	for (int by = 0; by < the_world->h(); by++)
	{
		draw_one_block(bx, by);
	}

	for (int bx = 0; bx < the_world->w(); bx++)
	for (int by = 0; by < the_world->h(); by++)
	{
		highlight_one_block(bx, by);
	}

	fl_pop_clip();
}

void W_Grid::draw_grid(int spacing)
{
	if (grid_MODE == 0)
		return;

	double mlx = mid_x - w() * 0.5 / zoom_mul;
	double mly = mid_y - h() * 0.5 / zoom_mul;
	double mhx = mid_x + w() * 0.5 / zoom_mul;
	double mhy = mid_y + h() * 0.5 / zoom_mul;

	int gx = GRID_FIND(mid_x, spacing);
	int gy = GRID_FIND(mid_y, spacing);

	int x1 = x();
	int y1 = y();
	int x2 = x() + w();
	int y2 = y() + h();

	int dx, dy;
	int wx, wy;

	for (dx = 0; true; dx++)
	{
		if (gx + dx * spacing < mlx) continue;
		if (gx + dx * spacing > mhx) break;

		MapToWin(gx + dx * spacing, gy, &wx, &wy);
		fl_yxline(wx, y1, y2);
	}

	for (dx = -1; true; dx--)
	{
		if (gx + dx * spacing > mhx) continue;
		if (gx + dx * spacing < mlx) break;

		MapToWin(gx + dx * spacing, gy, &wx, &wy);
		fl_yxline(wx, y1, y2);
	}

	for (dy = 0; true; dy++)
	{
		if (gy + dy * spacing < mly) continue;
		if (gy + dy * spacing > mhy) break;

		MapToWin(gx, gy + dy * spacing, &wy, &wy);
		fl_xyline(x1, wy, x2);
	}

	for (dy = -1; true; dy--)
	{
		if (gy + dy * spacing > mhy) continue;
		if (gy + dy * spacing < mly) break;

		MapToWin(gx, gy + dy * spacing, &wy, &wy);
		fl_xyline(x1, wy, x2);
	}
}

#if 0
void W_Grid::draw_partition(const node_c *nd, int ity)
{
	double mlx = mid_x - w() * 0.5 / zoom_mul;
	double mly = mid_y - h() * 0.5 / zoom_mul;
	double mhx = mid_x + w() * 0.5 / zoom_mul;
	double mhy = mid_y + h() * 0.5 / zoom_mul;

	double tlx, tly;
	double thx, thy;

	// intersect the partition line (which extends to infinity) with
	// the sides of the screen (in map coords).  Whether we use the
	// left/right sides to top/bottom depends on the angle of the
	// partition line.

	if (ABS(nd->dx) > ABS(nd->dy))
	{
		tlx = mlx;
		thx = mhx;
		tly = nd->y + nd->dy * (mlx - nd->x) / double(nd->dx);
		thy = nd->y + nd->dy * (mhx - nd->x) / double(nd->dx);

		if (MAX(tly, thy) < mly || MIN(tly, thy) > mhy)
			return;
	}
	else
	{
		tlx = nd->x + nd->dx * (mly - nd->y) / double(nd->dy);
		thx = nd->x + nd->dx * (mhy - nd->y) / double(nd->dy);
		tly = mly;
		thy = mhy;

		if (MAX(tlx, thx) < mlx || MIN(tlx, thx) > mhx)
			return;
	}

	int sx, sy;
	int ex, ey;

	MapToWin(tlx, tly, &sx, &sy);
	MapToWin(thx, thy, &ex, &ey);

	fl_color(fl_color_cube(ity, 0, ity));
	fl_line(sx, sy, ex, ey);
}

void W_Grid::draw_all_partitions()
{
	node_c * nodes[4];

	nodes[0] = nodes[1] = nodes[2] = NULL;
	nodes[3] = lev_nodes.Get(lev_nodes.num - 1);

	for (int rt_idx = 0; rt_idx < route_len; rt_idx++)
	{
		node_c *cur = nodes[3];

		node_c *next = (visit_route[rt_idx] == RT_LEFT) ? cur->l.node : cur->r.node;

		nodes[0] = nodes[1];
		nodes[1] = nodes[2];
		nodes[2] = nodes[3];
		nodes[3] = next;

		// quit if we reach a subsector
		if (! next)
			break;
	}

	// (Note: only displaying three of them)
	for (int n_idx = 1; n_idx < 4; n_idx++)
	{
		if (nodes[n_idx])
			draw_partition(nodes[n_idx], (n_idx == 3) ? 4 : n_idx);
	}
}

void W_Grid::draw_node(const node_c *nd, int pos, bool on_route)
{
	if (! on_route)
	{
		draw_child(&nd->l, pos, false);
		draw_child(&nd->r, pos, false);
	}
	else if (pos >= route_len)
	{
		draw_child(&nd->l, pos, true);
		draw_child(&nd->r, pos, true);
	}
	else if (visit_route[pos] == RT_LEFT)
	{
		// get drawing order correct, draw shaded side FIRST.
		draw_child(&nd->r, pos, false);
		draw_child(&nd->l, pos, true);
	}
	else  // RT_RIGHT
	{
		draw_child(&nd->l, pos, false);
		draw_child(&nd->r, pos, true);
	}
}
#endif

bool W_Grid::AreaBoundary(int x1, int y1, int x2, int y2, int a_idx)
{
	location_c& C = the_world->Loc(x1, y1);
	bool CC = (! C.Void() && C.area == a_idx);

	if (the_world->Outside(x2, y2))
	{
		return CC;
	}

	location_c& D = the_world->Loc(x2, y2);
	bool DD = (! D.Void() && D.area == a_idx);

	return (CC != DD);
}

void W_Grid::draw_one_block(int bx, int by)
{
//	if (the_world->Loc(bx, by).env == ENV_EMPTY)
//		return;

	fl_color(the_world->EnvColorAt(bx, by));

	draw_block(block_x + bx*64, block_y + by*64, 64, 64);
}

void W_Grid::highlight_one_block(int bx, int by)
{
	location_c& C = the_world->Loc(bx, by);

	if (C.Void() || C.area != ht_area)
		return;

	fl_color(FL_WHITE);

	for (int d = 0; d < 4; d++)
	{
		static const int dxs[4] = { +1, -1, 0, 0 };
		static const int dys[4] = { 0, 0, +1, -1 };

		if (! AreaBoundary(bx, by, bx+dxs[d], by+dys[d], ht_area))
			continue;

		int cx1 = (dxs[d] > 0) ? 1 : 0;
		int cy1 = (dys[d] > 0) ? 1 : 0;

		int cx2 = (dxs[d] < 0) ? 0 : 1;
		int cy2 = (dys[d] < 0) ? 0 : 1;

		int sx, sy;
		int ex, ey;

		MapToWin(block_x + (bx+cx1)*64, block_y + (by+cy1)*64, &sx, &sy);
		MapToWin(block_x + (bx+cx2)*64, block_y + (by+cy2)*64, &ex, &ey);

		int border = (zoom <= OTO_GRID_ZOOM-8) ? 1 : 2;

		fl_rectf(sx-1, ey-1, ex - sx + border, sy - ey + border);
	}
}

void W_Grid::draw_line(double x1, double y1, double x2, double y2)
{
	double mlx = mid_x - w() * 0.5 / zoom_mul;
	double mly = mid_y - h() * 0.5 / zoom_mul;
	double mhx = mid_x + w() * 0.5 / zoom_mul;
	double mhy = mid_y + h() * 0.5 / zoom_mul;

	// Based on Cohen-Sutherland clipping algorithm

	int out1 = MAP_OUTCODE(x1, y1, mlx, mly, mhx, mhy);
	int out2 = MAP_OUTCODE(x2, y2, mlx, mly, mhx, mhy);

	while ((out1 & out2) == 0 && (out1 | out2) != 0)
	{
		// may be partially inside box, find an outside point
		int outside = (out1 ? out1 : out2);

		SYS_ZERO_CHECK(outside);

		double dx = x2 - x1;
		double dy = y2 - y1;

		if (fabs(dx) < 0.1 && fabs(dy) < 0.1)
			break;

		double tmp_x, tmp_y;

		// clip to each side
		if (outside & O_BOTTOM)
		{
			tmp_x = x1 + dx * (mly - y1) / dy;
			tmp_y = mly;
		}
		else if (outside & O_TOP)
		{
			tmp_x = x1 + dx * (mhy - y1) / dy;
			tmp_y = mhy;
		}
		else if (outside & O_LEFT)
		{
			tmp_y = y1 + dy * (mlx - x1) / dx;
			tmp_x = mlx;
		}
		else  /* outside & O_RIGHT */
		{
			SYS_ASSERT(outside & O_RIGHT);

			tmp_y = y1 + dy * (mhx - x1) / dx;
			tmp_x = mhx;
		}

		SYS_ASSERT(out1 != out2);

		if (outside == out1)
		{
			x1 = tmp_x;
			y1 = tmp_y;

			out1 = MAP_OUTCODE(x1, y1, mlx, mly, mhx, mhy);
		}
		else
		{
			SYS_ASSERT(outside == out2);

			x2 = tmp_x;
			y2 = tmp_y;

			out2 = MAP_OUTCODE(x1, y1, mlx, mly, mhx, mhy);
		}
	}

	if (out1 & out2)
		return;

	int sx, sy;
	int ex, ey;

	MapToWin(x1, y1, &sx, &sy);
	MapToWin(x2, y2, &ex, &ey);

	fl_line(sx, sy, ex, ey);
}

void W_Grid::draw_block(double x1, double y1, double ww, double hh)
{
	double x2 = x1 + ww;
	double y2 = y1 + hh;

	// perform clipping
	double mlx = mid_x - w() * 0.5 / zoom_mul;
	double mly = mid_y - h() * 0.5 / zoom_mul;
	double mhx = mid_x + w() * 0.5 / zoom_mul;
	double mhy = mid_y + h() * 0.5 / zoom_mul;

	if (x1 < mlx) x1 = mlx;
	if (y1 < mly) y1 = mly;

	if (x2 > mhx) x2 = mhx;
	if (y2 > mhy) y2 = mhy;

	if (x1 > x2 || y1 > y2)
		return;

	int sx, sy;
	int ex, ey;

	MapToWin(x1, y1, &sx, &sy);
	MapToWin(x2, y2, &ex, &ey);

	int border = (zoom <= OTO_GRID_ZOOM-8) ? 0 : 1;

	fl_rectf(sx, ey, ex - sx - border, sy - ey - border);
}


#if 0
void W_Grid::draw_path()
{
	int p;

	// first, render the lines
	fl_color(fl_color_cube(0,7,4));

	for (p = 0; p < path->point_num - 1; p++)
	{
		int x1, y1, x2, y2;

		path->GetPoint(p,   &x1, &y1);
		path->GetPoint(p+1, &x2, &y2);

		draw_line(x1, y1, x2, y2);
	}

	// second, render the points themselves
	fl_color(FL_YELLOW);

	for (p = 0; p < path->point_num; p++)
	{
		int mx, my;
		int wx, wy;

		path->GetPoint(p, &mx, &my);

		MapToWin(mx, my, &wx, &wy);

		fl_rect(wx-1, wy-1, 3, 3);
	}
}
#endif

void W_Grid::scroll(int dx, int dy)
{
	dx = dx * w() / 10;
	dy = dy * h() / 10;

	double mdx = dx / zoom_mul;
	double mdy = dy / zoom_mul;

	mid_x += mdx;
	mid_y += mdy;

// fprintf(stderr, "Scroll pix (%d,%d) map (%1.1f, %1.1f) mid (%1.1f, %1.1f)\n", dx, dy, mdx, mdy, mid_x, mid_y);

	redraw();
}

//------------------------------------------------------------------------

int W_Grid::handle(int event)
{
	if (! guix_win)
		return 0;

	switch (event)
	{
		case FL_FOCUS:
			return 1;

		case FL_KEYDOWN:
		case FL_SHORTCUT:
		{
			int result = handle_key(Fl::event_key());
			handle_mouse(Fl::event_x(), Fl::event_y());
			return result;
		}

		case FL_ENTER:
		case FL_LEAVE:
			return 1;

		case FL_MOVE:
			handle_mouse(Fl::event_x(), Fl::event_y());
			return 1;

		case FL_PUSH:
			if (Fl::event_state() & FL_CTRL)
			{ }
			else
			{ }
			redraw();
			return 1;

		case FL_DRAG:
		case FL_RELEASE:
			// these are currently ignored.
			return 1;

		default:
			break;
	}

	return 0;  // unused
}

int W_Grid::handle_key(int key)
{
	if (key == 0)
		return 0;

	switch (key)
	{
		case '+': case '=':
			SetZoom(zoom + 1);
			return 1;

		case '-': case '_':
			SetZoom(zoom - 1);
			return 1;

		case FL_Left:
			scroll(-1, 0);
			return 1;

		case FL_Right:
			scroll(+1, 0);
			return 1;

		case FL_Up:
			scroll(0, +1);
			return 1;

		case FL_Down:
			scroll(0, -1);
			return 1;

		case 'g': case 'G':
			grid_MODE = (grid_MODE + 1) % 2;
			redraw();
			return 1;

		case 'p': case 'P':
			partition_MODE = (partition_MODE + 1) % 3;
			redraw();
			return 1;

		case 'm': case 'M':
			miniseg_MODE = (miniseg_MODE + 2) % 3;
			redraw();
			return 1;

		case 's': case 'S':
			shade_MODE = (shade_MODE + 1) % 3;
			redraw();
			return 1;

		case 'x':
			DialogShowAndGetChoice(ALERT_TXT, 0, "Please foo the joo.");
			return 1;

		default:
			break;
	}

	return 0;  // unused
}

void W_Grid::handle_mouse(int wx, int wy)
{
	double mx, my;

	WinToMap(wx, wy, &mx, &my);

	int bx = (int)floor((mx - block_x) / 64);
	int by = (int)floor((my - block_y) / 64);

	if (bx < 0 || bx >= the_world->w() || by < 0 || by >= the_world->h())
	{
		if (mouse_bx >= 0)
			redraw();

		mouse_bx = mouse_by = -1;
		ht_area = -1;

		guix_win->ctrl->UpdatePos(-1, -1, I_ROUND(mx), I_ROUND(my));
		return;
	}

	if (bx == mouse_bx && by == mouse_by)
		return;

	mouse_bx = bx;
	mouse_by = by;

	location_c& loc = the_world->Loc(bx, by);

	ht_area = loc.Void() ? -1 : loc.area;

	guix_win->ctrl->UpdatePos(bx, by, I_ROUND(mx), I_ROUND(my));
	guix_win->ctrl->UpdateEnv(loc);

	redraw();
}

