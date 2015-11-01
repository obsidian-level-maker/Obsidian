//----------------------------------------------------------------------
//  Addons Selection
//----------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2015 Andrew Apted
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
//----------------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_ui.h"

#include "lib_argv.h"
#include "lib_util.h"

#include "main.h"
#include "m_cookie.h"



//----------------------------------------------------------------------


class UI_AddonsWin : public Fl_Window
{
public:
	bool want_quit;

private:
	// TODO  stuff

public:
	UI_AddonsWin(int W, int H, const char *label = NULL);

	virtual ~UI_AddonsWin()
	{
		// nothing needed
	}

	bool WantQuit() const
	{
		return want_quit;
	}

public:
	// FLTK virtual method for handling input events.
	int handle(int event);

private:
	static void callback_Quit(Fl_Widget *w, void *data)
	{
		UI_AddonsWin *that = (UI_AddonsWin *)data;

		that->want_quit = true;
	}
};


//
// Constructor
//
UI_AddonsWin::UI_AddonsWin(int W, int H, const char *label) :
	Fl_Window(W, H, label),
	want_quit(false)
{
	// cancel Fl_Group's automatic add crap
	end();

	// non-resizable
	size_range(W, H, W, H);
	callback(callback_Quit, this);

	box(FL_THIN_UP_BOX);

	if (! alternate_look)
		color(BUILD_BG, BUILD_BG);


	int y_step = kf_h(6);
	int pad    = kf_w(6);


	//----------------

	int dh = kf_h(60);

	Fl_Group *darkish = new Fl_Group(0, H - dh, W, dh);
	darkish->end();
	darkish->box(FL_FLAT_BOX);
	if (! alternate_look)
		darkish->color(BUILD_BG, BUILD_BG);

	add(darkish);


	// finally add the buttons
	int bw = kf_w(60);
	int bh = kf_h(30);
	int bx = bw;
	int by = H - dh/2 - bh/2;

	Fl_Button *apply_but = new Fl_Button(W-bx-bw, by, bw, bh, "Apply");
	apply_but->callback(callback_Quit, this);
	darkish->add(apply_but);

	Fl_Button *cancel_but = new Fl_Button(bx, by, bw, bh, "Cancel");
	cancel_but->callback(callback_Quit, this);
	darkish->add(cancel_but);
}


int UI_AddonsWin::handle(int event)
{
	if (event == FL_KEYDOWN || event == FL_SHORTCUT)
	{
		int key = Fl::event_key();

		switch (key)
		{
			case FL_Escape:
				want_quit = true;
				return 1;

			default:
				break;
		}

		// eat all other function keys
		if (FL_F+1 <= key && key <= FL_F+12)
			return 1;
	}

	return Fl_Window::handle(event);
}


void DLG_SelectAddons(void)
{
	static UI_AddonsWin * addons_window = NULL;

	if (! addons_window)
	{
		int opt_w = kf_w(350);
		int opt_h = kf_h(380);

		addons_window = new UI_AddonsWin(opt_w, opt_h, "OBLIGE Addons");
	}

	addons_window->want_quit = false;
	addons_window->set_modal();
	addons_window->show();

	// run the GUI until the user closes
	while (! addons_window->WantQuit())
		Fl::wait();

	addons_window->set_non_modal();
	addons_window->hide();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
