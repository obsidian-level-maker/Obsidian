//------------------------------------------------------------------------
//  Main Window
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006,2007 Andrew Apted
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

#include "ui_menu.h"
#include "ui_window.h"

#ifndef WIN32
#include <unistd.h>
#endif

#if (FL_MAJOR_VERSION != 1 ||  \
	 FL_MINOR_VERSION != 1 ||  \
	 FL_PATCH_VERSION < 7)
#error "FLTK headers are not from FLTK 1.1.7 or later"
#endif


UI_MainWin *main_win;

#define MAIN_WINDOW_W  470
#define MAIN_WINDOW_H  406


static void main_win_close_CB(Fl_Widget *w, void *data)
{
	if (main_win)
		main_win->action = UI_MainWin::QUIT;
}


//
// MainWin Constructor
//
UI_MainWin::UI_MainWin(const char *title) :
    Fl_Double_Window(MAIN_WINDOW_W, MAIN_WINDOW_H, title),
	action(UI_MainWin::NONE)
{
	end(); // cancel begin() in Fl_Group constructor

  // no need for window to be resizable
	size_range(MAIN_WINDOW_W, MAIN_WINDOW_H,
             MAIN_WINDOW_W, MAIN_WINDOW_H);

	callback((Fl_Callback *) main_win_close_CB);

	color(MAIN_BG_COLOR, MAIN_BG_COLOR);
	image(NULL);


	int cy = 0;

	/* ---- Menu bar ---- */
	{
		menu_bar = MenuCreate(0, 0, w(), 28);
		add(menu_bar);

#ifndef MACOSX
		cy += menu_bar->h();
///		cy += 8;
#endif
	}

	setup_box = new UI_Setup(0, cy, w(), 154);
	add(setup_box);

	cy += setup_box->h();

	adjust_box = new UI_Adjust(0, cy, w(), 106);
	add(adjust_box);

	cy += adjust_box->h();

	build_box = new UI_Build(0, cy, w(), h() - cy);
	add(build_box);

	cy += build_box->h();

  DebugPrintf("Final main_win.cy = %d\n", cy);

	resizable(build_box);

	// show window (pass some dummy arguments)
	int argc = 1;
	char *argv[] = { "ObligeNG", NULL };

	show(argc, argv);
}

//
// MainWin Destructor
//
UI_MainWin::~UI_MainWin()
{ }


void UI_MainWin::Locked(bool value)
{
	setup_box->Locked(value);
	adjust_box->Locked(value);
	build_box->Locked(value);
}
