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
	UI_Canvas(int X, int Y, int W, int H, const char *label = NULL) :
		Fl_Widget(X, Y, W, H, label),
		loc_x(-1), loc_y(-1)
	{ }

	virtual ~UI_Canvas()
	{ }

private:
	// FLTK virtual method for drawing.
	void draw()
	{
		fl_push_clip(x(), y(), w(), h());

		fl_color(FL_BLACK);
		fl_rectf(x(), y(), w(), h());

		// ....

		fl_pop_clip();
	}

	void DrawEverything();

public:
	// FLTK virtual method for resizing.
	void resize(int X, int Y, int W, int H)
	{
		Fl_Widget::resize(X, Y, W, H);
	}

	// FLTK virtual method for handling input events.
	int handle(int event)
	{
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
				// FIXME
				// HandleKey(Fl::event_key());
				return 1;

			case FL_MOVE:
			case FL_DRAG:
				// FIXME : change current square
				// EditorMouseMotion(Fl::event_x(), Fl::event_y(),
				//		MAPX(Fl::event_x()), MAPY(Fl::event_y()), event == FL_DRAG);
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
