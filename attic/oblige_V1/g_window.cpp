//------------------------------------------------------------------------
//  WINDOW : Main application window
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

#ifndef WIN32
#include <unistd.h>
#endif


Guix_MainWin *guix_win;


static void main_win_close_CB(Fl_Widget *w, void *data)
{
	if (guix_win)
		guix_win->want_quit = true;
}


//
// WindowSmallDelay
//
// This routine is meant to delay a short time (e.g. 1/5th of a
// second) to allow the window manager to move our windows around.
//
// Hopefully such nonsense doesn't happen under Win32.
//
void WindowSmallDelay()
{
#ifndef WIN32
	Fl::wait(0);  usleep(100 * 1000);
	Fl::wait(0);  usleep(100 * 1000);
#endif

	Fl::wait(0);
}


//
// MainWin Constructor
//
	Guix_MainWin::Guix_MainWin(const char *title) :
Fl_Double_Window(620, 520, title)
{
	// turn off auto-add-widget mode
	end();

	size_range(MAIN_WINDOW_MIN_W, MAIN_WINDOW_MIN_H);

	// Set initial position.
	//
	// Note: this may not work properly.  It seems that when my window
	// manager adds the titlebar/border, it moves the actual window
	// down and slightly to the right, causing subsequent invokations
	// to keep going lower and lower.

	///  position(guix_prefs.win_x, guix_prefs.win_y);

	callback((Fl_Callback *) main_win_close_CB);

	// set a nice darkish gray for the space between main boxes
	color(MAIN_BG_COLOR, MAIN_BG_COLOR);

	want_quit = false;


	// create contents
	int mh = 28;

#ifdef MACOSX
	mh = 1;
#endif

	menu_bar = MenuCreate(0, 0, w(), 28);
	add(menu_bar);

	grid = new W_Grid(0, mh, w() - 220, h()-mh);
	add(grid);
	resizable(grid);

	ctrl = new W_Control(w()-220, mh, 220, h()-mh);
	add(ctrl);

#if 0
	build_mode = new Guix_BuildMode(8, 4+mh, hw, 176);
	add(build_mode);

	misc_opts  = new Guix_MiscOptions(8+hw+4, 4+mh, hw, 136);
	add(misc_opts);

	factor = new Guix_FactorBox(8+hw+4, 140+mh, hw, 40);
	add(factor);

	files = new Guix_FileBox(8, 184+mh, w()-8*2, 86);
	add(files);

	builder = new Guix_BuildButton(8, 274+10+mh, hw, 60);
	add(builder);

	progress = new Guix_ProgressBox(8+hw+4, 274+mh, hw, 74);
	add(progress);

	text_box = new Guix_TextBox(0, 352+mh, w(), h() - 352 - mh);
	add(text_box);
	resizable(text_box);
#endif

	// show window (pass some dummy arguments)
	int argc = 1;
	char *argv[] = { "oblige", NULL };

	show(argc, argv);

	// read initial pos, giving 1/5th of a second for the WM to adjust
	// our window's position (naughty WM...)
	WindowSmallDelay();

	init_x = x(); init_y = y();
	init_w = w(); init_h = h();
}

//
// MainWin Destructor
//
Guix_MainWin::~Guix_MainWin()
{
	WritePrefs();
}


void Guix_MainWin::WritePrefs()
{
	// check if moved or resized
	if (x() != init_x || y() != init_y)
	{
		//    guix_prefs.win_x = x();
		//    guix_prefs.win_y = y();
	}

	if (w() != init_w || h() != init_h)
	{
		//    guix_prefs.win_w = w();
		//    guix_prefs.win_h = h();
	}
}

