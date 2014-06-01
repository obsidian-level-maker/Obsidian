//------------------------------------------------------------------------
//  Options Editor
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2014 Andrew Apted
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

#include "main.h"


class UI_OptionsWin : public Fl_Window
{
private:
	bool want_quit;

	Fl_Check_Button *opt_alt_look;
	Fl_Check_Button *opt_backups;
	Fl_Check_Button *opt_debug;
	Fl_Check_Button *opt_lighting;

public:
	UI_OptionsWin(int W, int H, const char *label = NULL);

	virtual ~UI_OptionsWin()
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
		UI_OptionsWin *that = (UI_OptionsWin *)data;

		that->want_quit = true;
	}

	static void callback_AltLook(Fl_Widget *w, void *data)
	{
		UI_OptionsWin *that = (UI_OptionsWin *)data;

		alternate_look = that->opt_alt_look->value() ? true : false;
	}

	static void callback_Backups(Fl_Widget *w, void *data)
	{
		UI_OptionsWin *that = (UI_OptionsWin *)data;

		create_backups = that->opt_backups->value() ? true : false;
	}

	static void callback_Debug(Fl_Widget *w, void *data)
	{
		UI_OptionsWin *that = (UI_OptionsWin *)data;

		debug_messages = that->opt_debug->value() ? true : false;
		LogEnableDebug(debug_messages);
	}

	static void callback_Lighting(Fl_Widget *w, void *data)
	{
		UI_OptionsWin *that = (UI_OptionsWin *)data;

		fast_lighting = that->opt_lighting->value() ? true : false;
	}

};


//
// Constructor
//
UI_OptionsWin::UI_OptionsWin(int W, int H, const char *label) :
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


	int y_step = 6 + KF;

	int cx = x() + 24 + KF*3;
	int cy = y() + y_step;

	Fl_Box *heading;


	heading = new Fl_Box(FL_NO_BOX, x()+6, cy, W-12, 24, "Appearance");
	heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	heading->labeltype(FL_NORMAL_LABEL);
	heading->labelfont(FL_HELVETICA_BOLD);
	heading->labelsize(FL_NORMAL_SIZE + 2);

	add(heading);

	cy += heading->h() + y_step;


	opt_alt_look = new Fl_Check_Button(cx, cy, 24, 24, "Alternate Look (requires a restart)");
	opt_alt_look->align(FL_ALIGN_RIGHT);
	opt_alt_look->value(alternate_look ? 1 : 0);
	opt_alt_look->callback(callback_AltLook, this);

	add(opt_alt_look);

	cy += opt_alt_look->h() + y_step;


	//----------------

	cy += 8;

	heading = new Fl_Box(FL_NO_BOX, x()+6, cy, W-12, 24, "File Options");
	heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	heading->labeltype(FL_NORMAL_LABEL);
	heading->labelfont(FL_HELVETICA_BOLD);
	heading->labelsize(FL_NORMAL_SIZE + 2);

	add(heading);

	cy += heading->h() + y_step;


	opt_backups = new Fl_Check_Button(cx, cy, 24, 24, "Create Backups");
	opt_backups->align(FL_ALIGN_RIGHT);
	opt_backups->value(create_backups ? 1 : 0);
	opt_backups->callback(callback_Backups, this);

	add(opt_backups);

	cy += opt_backups->h() + y_step;


	opt_debug = new Fl_Check_Button(cx, cy, 24, 24, "Debugging Messages (in LOGS.txt)");
	opt_debug->align(FL_ALIGN_RIGHT);
	opt_debug->value(debug_messages ? 1 : 0);
	opt_debug->callback(callback_Debug, this);

	add(opt_debug);

	cy += opt_debug->h() + y_step;


	//----------------

	cy += 8;

	heading = new Fl_Box(FL_NO_BOX, x()+6, cy, W-12, 24, "Doom / Heretic / Hexen");
	heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	heading->labeltype(FL_NORMAL_LABEL);
	heading->labelfont(FL_HELVETICA_BOLD);
	heading->labelsize(FL_NORMAL_SIZE + 2);

	add(heading);

	cy += heading->h() + y_step;


	opt_lighting = new Fl_Check_Button(cx, cy, 24, 24, "Bland Lighting Mode");
	opt_lighting->align(FL_ALIGN_RIGHT);
	opt_lighting->value(fast_lighting ? 1 : 0);
	opt_lighting->callback(callback_Lighting, this);

	add(opt_lighting);

	cy += opt_lighting->h() + y_step;



	//----------------

	int dh = 50 + KF * 4;

	Fl_Group *darkish = new Fl_Group(0, H-dh, W, dh);
	darkish->end();
	darkish->box(FL_FLAT_BOX);
	if (! alternate_look)
		darkish->color(BUILD_BG, BUILD_BG);

	add(darkish);


	// finally add an "Close" button
	int bw = 60 + KF * 10;
	int bh = 30 + KF * 3;

	Fl_Button *button = new Fl_Button(W-30-bw, H-10-bh, bw, bh, "Close");
	button->callback(callback_Quit, this);
	darkish->add(button);
}


int UI_OptionsWin::handle(int event)
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


void DLG_OptionsEditor(void)
{
	static UI_OptionsWin * option_window = NULL;

	if (option_window)  // already in use?
		return;

	int opt_w = 350 + KF * 30;
	int opt_h = 370 + KF * 40;

	option_window = new UI_OptionsWin(opt_w, opt_h, "OBLIGE Options");

	option_window->set_modal();
	option_window->show();

	// run the GUI until the user closes
	while (! option_window->WantQuit())
		Fl::wait();

	// this deletes all the child widgets too...
	delete option_window;

	option_window = NULL;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
