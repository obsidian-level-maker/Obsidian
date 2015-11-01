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

class UI_Addon : public Fl_Group
{
public:
	std::string id_name;

	Fl_Check_Button *button;

public:
	UI_Addon(int x, int y, int w, int h, const char *id, const char *label, const char *tip) :
		Fl_Group(x, y, w, h),
		id_name(id)
	{
		box(FL_THIN_UP_BOX);

		if (! alternate_look)
			color(BUILD_BG, BUILD_BG);

		button = new Fl_Check_Button(x + kf_w(6), y + kf_h(4), w - kf_w(12), kf_h(24), label);
		if (tip)
			button->tooltip(tip);

		end();

		resizable(NULL);
	}

	virtual ~UI_Addon()
	{ }

	int CalcHeight() const
	{
		return kf_h(34);
	}
};


//----------------------------------------------------------------------


class UI_AddonsWin : public Fl_Window
{
public:
	bool want_quit;

	Fl_Group *pack;

	Fl_Scrollbar *sbar;

	// area occupied by addon list
	int mx, my, mw, mh;

	// number of pixels "lost" above the top
	int offset_y;

	// total height of all shown addons
	int total_h;

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
	void PositionAll(UI_Addon *focus = NULL)
	{
		// FIXME
	}

	static void callback_Scroll(Fl_Widget *w, void *data)
	{
		// FIXME
	}

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
	callback(callback_Quit, this);

	// non-resizable
	size_range(W, H, W, H);

	box(FL_NO_BOX);

///--	if (! alternate_look)
///--		color(BUILD_BG, BUILD_BG);


	int pad = kf_w(6);

	int dh = kf_h(60);


	// area for addons list
	mx = 0;
	my = 0;
	mw = W - Fl::scrollbar_size();
	mh = H - dh;

	offset_y = 0;
	total_h  = 0;


	sbar = new Fl_Scrollbar(mx+mw, my, Fl::scrollbar_size(), mh);
	sbar->callback(callback_Scroll, this);

	if (! alternate_look)
		sbar->color(FL_DARK3+1, FL_DARK3+1);


	pack = new Fl_Group(mx, my, mw, mh, "\n\n\n\nList of Addons");
	pack->clip_children(1);
	pack->end();

	pack->align(FL_ALIGN_INSIDE);
	pack->labeltype(FL_NORMAL_LABEL);
	pack->labelsize(FL_NORMAL_SIZE * 3 / 2);

///--	if (alternate_look)
///--		pack->labelcolor(FL_DARK1);

	pack->box(FL_FLAT_BOX);
	pack->color(FL_DARK1);
	pack->resizable(NULL);


	//----------------

	Fl_Group *darkish = new Fl_Group(0, H - dh, W, dh);
	darkish->box(FL_FLAT_BOX);
	darkish->color(BUILD_BG, BUILD_BG);


	// finally add the buttons
	int bw = kf_w(60);
	int bh = kf_h(30);
	int bx = bw;
	int by = H - dh/2 - bh/2;

	Fl_Button *apply_but = new Fl_Button(W-bx-bw, by, bw, bh, "Close");
	apply_but->callback(callback_Quit, this);

///--- Fl_Button *cancel_but = new Fl_Button(bx, by, bw, bh, "Cancel");
///--- cancel_but->callback(callback_Quit, this);

	darkish->end();


	end();

	resizable(NULL);
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
