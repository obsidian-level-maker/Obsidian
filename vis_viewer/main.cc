//------------------------------------------------------------------------
//
//  Visibility Viewer / Tester
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

/*
 *  Standard C headers
 */
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <ctype.h>
#include <limits.h>
#include <errno.h>
#include <math.h>

/*
 *  Standard C++ headers
 */
#include <vector>

/*
 *  Fast Light Tool Kit
 */
#include <FL/Fl.H>
#include <FL/Fl_Box.H>
#include <FL/Fl_Button.H>
#include <FL/Fl_Check_Button.H>
#include <FL/Fl_Choice.H>
#include <FL/Fl_Double_Window.H>
#include <FL/Fl_Group.H>
#include <FL/Fl_Output.H>
#include <FL/Fl_Menu_Bar.H>
#include <FL/Fl_Menu_Item.H>
#include <FL/Fl_Pack.H>
#include <FL/Fl_Widget.H>
#include <FL/Fl_Window.H>

#include <FL/fl_ask.H>
#include <FL/fl_draw.H>

/*
 *  Local Stuff
 */
#include "../gui/sys_type.h"
#include "../gui/sys_macro.h"

void FatalError(const char *msg, ...);

#include "vis_buf.cc"


class UI_Window;

UI_Window *main_win;


#define MAX_SQUARES  32

#define SQUARE_SIZE  12


class UI_Canvas : public Fl_Widget
{
private:
	// the current square to view, -1 when out of range
	int loc_x, loc_y;

public:
	UI_Canvas(int X, int Y, int W, int H, const char *label = NULL);
	virtual ~UI_Canvas();

public:
	// FLTK virtual method for handling input events.
	int handle(int event);

	// FLTK virtual method for resizing.
	void resize(int X, int Y, int W, int H);

	void DrawEverything();

private:
	// FLTK virtual method for drawing.
	void draw();

};


UI_Canvas::UI_Canvas(int X, int Y, int W, int H, const char *label) : 
    Fl_Widget(X, Y, W, H, label),
    e(NULL), render3d(false),
	highlight(), selbox_active(false)
{ }

UI_Canvas::~UI_Canvas()
{ }


void UI_Canvas::resize(int X, int Y, int W, int H)
{
	Fl_Widget::resize(X, Y, W, H);
}


void UI_Canvas::draw()
{
	fl_push_clip(x(), y(), w(), h());

	fl_color(FL_WHITE);
	fl_font(FL_COURIER, 14);

	if (render3d)
		Render3D_Draw(x(), y());
	else if (e)
		DrawEverything();

	fl_pop_clip();
}


int UI_Canvas::handle(int event)
{
	//// fprintf(stderr, "HANDLE EVENT %d\n", event);

	switch (event)
	{
		case FL_FOCUS:
			return 1;

		case FL_KEYDOWN:
		case FL_SHORTCUT:
		{
			//      int result = handle_key();
			//      handle_mouse();

			int key   = Fl::event_key();
			int state = Fl::event_state();

			switch (key)
			{
				case FL_Num_Lock:
				case FL_Caps_Lock:

				case FL_Shift_L: case FL_Control_L:
				case FL_Shift_R: case FL_Control_R:
				case FL_Meta_L:  case FL_Alt_L:
				case FL_Meta_R:  case FL_Alt_R:

					/* IGNORE */
					return 1;

				default:
					/* OK */
					break;
			}

			if (key == FL_Tab || key == '\t')
			{
				render3d = !render3d;
				redraw();
				return 1;
			}

			if (key != 0)
			{
				if (key < 127 && isalpha(key) && (state & FL_SHIFT))
					key = toupper(key);

				if (render3d)
				{
					if (Render3D_Key(key))
						redraw();
				}
				else
					EditorKey(key, (state & FL_SHIFT) ? true : false);
			}

			return 1; // result;
		}

		case FL_ENTER:
			// we greedily grab the focus
			if (Fl::focus() != this)
				take_focus(); 

			return 1;

		case FL_LEAVE:
			//      hilite_rad = NULL;
			//      hilite_thing = NULL;
			//      dragging = false;
			//      determine_cursor();
			//      update_active_obj();
			redraw();
			return 1;

		case FL_MOVE:
		case FL_DRAG:
			EditorMouseMotion(Fl::event_x(), Fl::event_y(),
					MAPX(Fl::event_x()), MAPY(Fl::event_y()), event == FL_DRAG);
			return 1;

		case FL_PUSH:
			{
				int state = Fl::event_state();
				EditorMousePress((state & FL_CTRL) ? true : false);
			}
			return 1;

		case FL_RELEASE:
			EditorMouseRelease();
			return 1;

		case FL_MOUSEWHEEL:
			EditorWheel(0 - Fl::event_dy());
			return 1;

		default:
			break;
	}

	return 0;  // unused
}


void UI_Canvas::DrawEverything()
{
	map_lx = MAPX(x());
	map_ly = MAPY(y()+h());
	map_hx = MAPX(x()+w());
	map_hy = MAPY(y());

	DrawMap(); 

	HighlightSelection(edit.Selected); // FIXME should be widgetized

	if (highlight())
		HighlightObject(highlight.type, highlight.num, YELLOW);

	if (selbox_active)
		SelboxDraw();
}


/*
  draw the actual game map
*/
void UI_Canvas::DrawMap()
{
	fl_color(FL_BLACK);
	fl_rectf(x(), y(), w(), h());

	// draw the grid first since it's in the background
	if (grid.shown)
		DrawGrid();

	if (e->obj_type != OBJ_THINGS)
		DrawThings();

	DrawLinedefs();

	if (e->obj_type == OBJ_VERTICES)
		DrawVertices();

	if (e->obj_type == OBJ_THINGS)
		DrawThings();

	if (e->obj_type == OBJ_RADTRIGS)
		DrawRTS();


	int n;

	// Draw the things numbers
	if (e->obj_type == OBJ_THINGS && e->show_object_numbers)
	{
		for (n = 0; n < NumThings; n++)
		{
			int x = Things[n]->x;
			int y = Things[n]->y;

			if (Vis(x, y, MAX_RADIUS))
				DrawObjNum(SCREENX(x) + FONTW, SCREENY(y) + 2, n, THING_NO);
		}
	}

	// Draw the sector numbers
	if (e->obj_type == OBJ_SECTORS && e->show_object_numbers)
	{
		int xoffset = - FONTW / 2;

		for (n = 0; n < NumSectors; n++)
		{
			int x;
			int y;

			centre_of_sector(n, &x, &y);

			if (Vis(x, y, MAX_RADIUS))
				DrawObjNum(SCREENX(x) + xoffset, SCREENY(y) - FONTH / 2, n, SECTOR_NO);

			if (n == 10 || n == 100 || n == 1000 || n == 10000)
				xoffset -= FONTW / 2;
		}
	}
}



/*
 *  draw_grid - draw the grid in the background of the edit window
 */
void UI_Canvas::DrawGrid()
{
	int grid_step_1 = 1 * grid.step;    // Map units between dots
	int grid_step_2 = 8 * grid_step_1;  // Map units between dim lines
	int grid_step_3 = 8 * grid_step_2;  // Map units between bright lines

	float pixels_1 = grid.step * grid.Scale;


	if (pixels_1 < 1.99)
	{
		fl_color(GRID_DARK);
		fl_rectf(x(), y(), w(), h());
		return;
	}


	fl_color (GRID_BRIGHT);
	{
		int gx = (map_lx / grid_step_3) * grid_step_3;

		for (; gx <= map_hx; gx += grid_step_3)
			DrawMapLine(gx, map_ly-2, gx, map_hy+2);

		int gy = (map_ly / grid_step_3) * grid_step_3;

		for (; gy <=  map_hy; gy += grid_step_3)
			DrawMapLine(map_lx, gy, map_hx, gy);
	}


	fl_color (GRID_MEDIUM);
	{
		int gx = (map_lx / grid_step_2) * grid_step_2;

		for (; gx <= map_hx; gx += grid_step_2)
			if (gx % grid_step_3 != 0)
				DrawMapLine(gx, map_ly, gx, map_hy);

		int gy = (map_ly / grid_step_2) * grid_step_2;

		for (; gy <= map_hy; gy += grid_step_2)
			if (gy % grid_step_3 != 0)
				DrawMapLine(map_lx, gy, map_hx, gy);
	}


	// POINTS

	if (pixels_1 < 3.99)
		fl_color(GRID_MEDIUM);
	//??  else if (pixels_1 > 30.88)
	//??    fl_color(GRID_BRIGHT);
	else
		fl_color(GRID_POINT);

	{
		int gx = (map_lx / grid_step_1) * grid_step_1;
		int gy = (map_ly / grid_step_1) * grid_step_1;

		for (int ny = gy; ny <= map_hy; ny += grid_step_1)
		for (int nx = gx; nx <= map_hx; nx += grid_step_1)
		{
			int sx = SCREENX(nx);
			int sy = SCREENY(ny);

			if (pixels_1 < 30.99)
				fl_point(sx, sy);
			else
			{
				fl_line(sx-0, sy, sx+1, sy);
				fl_line(sx, sy-0, sx, sy+1);
			}
		}
	}
}


//--------------------------------------------------------------------


#define MAIN_WINDOW_W  (MAX_SQUARES * SQUARE_SIZE)
#define MAIN_WINDOW_H  (MAX_SQUARES * SQUARE_SIZE)


class UI_Window : public Fl_Double_Window
{
public:
	bool want_quit;

	// main child widgets

	UI_Canvas *canvas;

private:

public:
	UI_Window(const char *title);
	virtual ~UI_Window();

public:
};


static void main_win_close_CB(Fl_Widget *w, void *data)
{
	if (main_win)
		main_win->want_quit = true;
}


UI_Window::UI_Window(const char *title) :
    Fl_Double_Window(MAIN_WINDOW_W, MAIN_WINDOW_H, title),
	want_quit(false), canvas(NULL)
{
	end(); // cancel begin() in Fl_Group constructor

	size_range(MAIN_WINDOW_W, MAIN_WINDOW_H, MAIN_WINDOW_W, MAIN_WINDOW_H);

	callback((Fl_Callback *) main_win_close_CB);


	canvas = new UI_Canvas(0, 0, MAIN_WINDOW_W, MAIN_WINDOW_H);
	add(canvas);
}


UI_Window::~UI_Window()
{ }


//--------------------------------------------------------------------


#define MSG_BUF_LEN  2000

void FatalError(const char *msg, ...)
{
	static char buffer[MSG_BUF_LEN];

	va_list arg_pt;

	va_start(arg_pt, msg);
	vsnprintf(buffer, MSG_BUF_LEN-1, msg, arg_pt);
	va_end(arg_pt);

	buffer[MSG_BUF_LEN-2] = 0;

	fl_alert("%s", buffer);

	if (main_win)
		delete main_win;

	exit(9);
}


int main(int argc, char **argv)
{
	if (1)
		Fl::scheme("plastic");

	fl_message_font(FL_HELVETICA /* _BOLD */, 18);

	// load icons for file chooser
#ifndef WIN32
	Fl_File_Icon::load_system_icons();
#endif

	try
	{
		//// FIXME FIXME  LoadVisMap()

		main_win = new UI_Window("Vis Viewer");

		// show window (pass some dummy arguments)
		{
			int argc = 1;
			char *argv[] = { "VisViewer.exe", NULL };

			main_win->show(argc, argv);
		}

		// run the GUI until the user quits
		while (! main_win->want_quit)
		{
			Fl::wait(0.2f);
		}
	}
	catch (...)
	{
		FatalError("An unknown error occurred (exception was thrown)");
	}

	if (main_win)
		delete main_win;

	return 0;
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
