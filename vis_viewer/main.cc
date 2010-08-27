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
#include <assert.h>

#if 1
#include <sys/time.h>
#include <time.h>
#endif

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
#include "../gui/vis_buffer.h"


class UI_Window;

UI_Window *main_win;

const char *input_file = "DATA1";

bool quick_mode = false;
bool time_it = false;


#define MAX_SQUARES  32

#define SQUARE_SIZE  16


class UI_Canvas : public Fl_Widget
{
private:
	// the current square to view, -1 when out of range
	int loc_x, loc_y;

public:
	Vis_Buffer vbuf;

public:
	UI_Canvas(int X, int Y, int W, int H, const char *label = NULL) :
		Fl_Widget(X, Y, W, H, label),
		loc_x(-1), loc_y(-1),
		vbuf(MAX_SQUARES, MAX_SQUARES)
	{ }

	virtual ~UI_Canvas()
	{ }

public:
	void ReadMap()
	{
		vbuf.ReadMap(input_file);
	}

	void DrawSolidWall(int sx, int sy, int side)
	{
		int x1 = x() + sx * SQUARE_SIZE;
		int y1 = y() + (MAX_SQUARES-1-sy) * SQUARE_SIZE;

		int x2 = x1 + SQUARE_SIZE - 1;
		int y2 = y1 + SQUARE_SIZE - 1;

		switch (side)
		{
			case 2: fl_rectf(x1, y2, SQUARE_SIZE, 1); break;
			case 8: fl_rectf(x1, y1, SQUARE_SIZE, 1); break;
			case 4: fl_rectf(x1, y1, 1, SQUARE_SIZE); break;
			case 6: fl_rectf(x2, y1, 1, SQUARE_SIZE); break;

			default: break;
		}
	}

	void DrawDiagonal(int sx, int sy, int kind)
	{
		if (! (vbuf.at(sx, sy) & kind))
			return;

		int x1 = x() + sx * SQUARE_SIZE;
		int y1 = y() + (MAX_SQUARES-1-sy) * SQUARE_SIZE;

		int x2 = x1 + SQUARE_SIZE - 2;
		int y2 = y1 + SQUARE_SIZE - 1;

		if (kind == V_DIAG_NE)
			std::swap(x1, x2);
		
		fl_line(x1,y1, x2,y2);
		fl_line(x1+1,y1, x2+1,y2);
	}

	int GetVis(int x, int y)
	{
	  short d = vbuf.at(x, y);

	  if (d & V_FILL)   return 4;
	  if (d & V_LSHAPE) return 3;
	  if (d & V_BASIC)  return 1;
	  if (d & V_SPAN)   return 2;

	  return 0;
	}

	void DrawSquare(int sx, int sy)
	{
		int x1 = x() + sx * SQUARE_SIZE;
		int y1 = y() + (MAX_SQUARES-1-sy) * SQUARE_SIZE;

		// int x2 = x1 + SQUARE_SIZE - 1;
		// int y2 = y1 + SQUARE_SIZE - 1;

		fl_color(fl_rgb_color(192, 192, 192));

		fl_rectf(x1, y1, SQUARE_SIZE, 1);
		fl_rectf(x1, y1, 1, SQUARE_SIZE);

		int vis = GetVis(sx, sy);

		if (sx == loc_x && sy == loc_y)
		{
			fl_color(FL_YELLOW);
			fl_rectf(x1, y1, SQUARE_SIZE, SQUARE_SIZE);
		}
		else if (vis != 0)
		{
			switch (vis)
			{
				case 1:  fl_color(FL_BLUE); break;
				case 2:  fl_color(fl_rgb_color(255,176,32)); break;
				case 3:  fl_color(fl_rgb_color(0,160,0)); break;
				default: fl_color(FL_MAGENTA); break;
			}

			fl_rectf(x1, y1, SQUARE_SIZE, SQUARE_SIZE);
		}

		// draw solid borders
		fl_color(FL_RED);

		for (int side = 2; side <= 8; side += 2)
		{
			if (vbuf.TestWall(sx, sy, side))
			{
				DrawSolidWall(sx, sy, side);
			}
		}

		DrawDiagonal(sx, sy, V_DIAG_NE);
		DrawDiagonal(sx, sy, V_DIAG_SE);

		if (loc_x < 0 || loc_y < 0)
			return;

	}

	void DrawEverything()
	{
		for (int sx = 0; sx < MAX_SQUARES; sx++)
		for (int sy = 0; sy < MAX_SQUARES; sy++)
		{
			DrawSquare(sx, sy);
		}
	}

	void ChangeLocation(int nx, int ny)
	{
		// fprintf(stderr, "New loc: %d %d\n", nx, ny);

		loc_x = nx;
		loc_y = ny;

		vbuf.ClearVis();

		if (loc_x >= 0 && loc_y >= 0)
		    vbuf.ProcessVis(loc_x, loc_y);

	  	// vbuf.FloodFill(4);
		// vbuf.Truncate(8);

		redraw();
	}

	void MouseMotion(int mx, int my)
	{
		int new_loc_x = (mx - x()) / SQUARE_SIZE;
		int new_loc_y = (my - y()) / SQUARE_SIZE;

		// bottom-up ordering on Y coords
		new_loc_y = MAX_SQUARES-1 - new_loc_y;

		if (new_loc_x < 0 || new_loc_x >= MAX_SQUARES)
			new_loc_x = -1;

		if (new_loc_y < 0 || new_loc_y >= MAX_SQUARES)
			new_loc_y = -1;

		if (loc_x != new_loc_x || loc_y != new_loc_y)
			ChangeLocation(new_loc_x, new_loc_y);
	}

	void HandleKey(int key)
	{
		if (key == ' ' || key == FL_BackSpace || key == FL_Delete)
		{
			loc_x = loc_y = -1;
			vbuf.ClearVis();
			redraw();
			return;
		}
	}

private:
	// FLTK virtual method for drawing.
	void draw()
	{
		fl_push_clip(x(), y(), w(), h());

		fl_color(FL_LIGHT2);
		fl_rectf(x(), y(), w(), h());

		DrawEverything();

		fl_pop_clip();
	}

public:
	// FLTK virtual method for resizing.
	void resize(int X, int Y, int W, int H)
	{
		Fl_Widget::resize(X, Y, W, H);
	}

	// FLTK virtual method for handling input events.
	int handle(int event)
	{
		int key;

		switch (event)
		{
			case FL_FOCUS:
				return 1;

			case FL_ENTER:
				// we greedily grab the focus
				if (Fl::focus() != this)
					take_focus(); 
				return 1;

			case FL_LEAVE:
				redraw();
				return 1;

			case FL_KEYDOWN:
			case FL_SHORTCUT:
				key = Fl::event_key();
				HandleKey(key);
				return (32 <= key && key <= 126) ? 1 : 0;

			case FL_MOVE:
			case FL_DRAG:
				MouseMotion(Fl::event_x(), Fl::event_y());
				return 1;

			case FL_PUSH:
			case FL_RELEASE:
				return 1;

			default:
				break;
		}

		return 0;  // unused
	}
};


//--------------------------------------------------------------------


#define MAIN_WINDOW_W  (MAX_SQUARES * SQUARE_SIZE)
#define MAIN_WINDOW_H  (MAX_SQUARES * SQUARE_SIZE)


class UI_Window : public Fl_Double_Window
{
public:
	bool want_quit;

	UI_Canvas *canvas;

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

void Main_FatalError(const char *msg, ...)
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


void TimeTest()
{
#if 1
	fprintf(stderr, "BEGUN... %dx%d\n", MAX_SQUARES, MAX_SQUARES);

	struct timeval tv1;
	struct timeval tv2;

	gettimeofday(&tv1, NULL);

	for (int x = 0; x < MAX_SQUARES; x++)
	for (int y = 0; y < MAX_SQUARES; y++)
	{
		main_win->canvas->vbuf.ClearVis();
		main_win->canvas->vbuf.ProcessVis(x, y);
	}

	gettimeofday(&tv2, NULL);

	int sec  = tv2.tv_sec  - tv1.tv_sec;
	int usec = tv2.tv_usec - tv1.tv_usec;

	double total = sec + usec / 1e6;

	fprintf(stderr, "FINISHED... %1.4f sec\n", total);

	exit(1);
#endif
}


int main(int argc, char **argv)
{
	argv++, argc--;

	if (argc >= 1 && strcmp(*argv, "-q") == 0)
	{
		quick_mode = true;
		argv++, argc--;
	}

	if (argc >= 1 && strcmp(*argv, "-t") == 0)
	{
		time_it = true;
		argv++, argc--;
	}

	if (argc >= 1)
		input_file = *argv++;

	Fl::scheme("plastic");

	fl_message_font(FL_HELVETICA /* _BOLD */, 18);

	try
	{
		main_win = new UI_Window("Vis Viewer");

		main_win->canvas->ReadMap();

		main_win->canvas->vbuf.SetQuickMode(quick_mode);

		if (time_it)
			TimeTest();

		// show window (pass some dummy arguments)
		{
			char *name = strdup("VisViewer.exe");

			int argc = 1;
			char *argv[] = { name, NULL };

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
		Main_FatalError("An unknown error occurred (exception was thrown)");
	}

	if (main_win)
		delete main_win;

	return 0;
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
