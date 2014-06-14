//------------------------------------------------------------------------
//  About Window
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


#define TITLE_COLOR  fl_color_cube(0,3,1)

#define INFO_COLOR   fl_color_cube(2,7,0)
#define INFO_COLOR2  fl_rgb_color(127, 255, 144)


class UI_About : public Fl_Window
{
public:
	bool want_quit;

public:
	UI_About(int W, int H, const char *label = NULL);

	virtual ~UI_About()
	{
		// nothing needed
	}

	bool WantQuit() const
	{
		return want_quit;
	}

public:
	// FLTK virtual method for handling input events.
	int handle(int event)
	{
		if (event == FL_KEYDOWN || event == FL_SHORTCUT)
		{
			int key = Fl::event_key();

			if (key == FL_Escape)
			{
				want_quit = true;
				return 1;
			}

			// eat all other function keys
			if (FL_F+1 <= key && key <= FL_F+12)
				return 1;
		}

		return Fl_Window::handle(event);
	}

private:
	static void callback_Quit(Fl_Widget *w, void *data)
	{
		UI_About *that = (UI_About *)data;

		that->want_quit = true;
	}

	static const char *Text;
	static const char *URL;
};


const char *UI_About::Text =
	"OBLIGE is a random level generator\n"
	"for classic FPS games like DOOM\n"
	"\n"
	"Copyright (C) 2006-2014 Andrew Apted, et al\n"
	"\n"
	"This program is free software, and may be\n"
	"distributed and modified under the terms of\n"
	"the GNU General Public License\n"
	"\n"
	"There is ABSOLUTELY NO WARRANTY\n"
	"Use at your OWN RISK";


const char *UI_About::URL = "http://oblige.sourceforge.net";


//
// Constructor
//
UI_About::UI_About(int W, int H, const char *label) :
	Fl_Window(W, H, label),
	want_quit(false)
{
	// cancel Fl_Group's automatic add crap
	end();

	// non-resizable
	size_range(W, H, W, H);

	if (alternate_look)
		color(FL_LIGHT3, FL_LIGHT3);

	callback(callback_Quit, this);


	int cy = kf_h(6);

	// nice big logo text
	const char *logo_text = OBLIGE_TITLE " " OBLIGE_VERSION;

	Fl_Box *box = new Fl_Box(0, cy, W, kf_h(50), logo_text);
	box->align(FL_ALIGN_INSIDE | FL_ALIGN_CENTER);
	box->labelcolor(TITLE_COLOR);
	box->labelsize(FL_NORMAL_SIZE * 5 / 3);
	add(box);

	cy += box->h() + kf_h(6);


	// the very informative text
	int pad = kf_w(22);

	int text_h = H * 0.55;

	box = new Fl_Box(pad, cy, W-pad-pad, text_h, Text);
	box->align(FL_ALIGN_INSIDE | FL_ALIGN_CENTER);
	box->box(FL_UP_BOX);
	box->color(alternate_look ? INFO_COLOR2 : INFO_COLOR);
	add(box);

	cy += box->h() + kf_h(10);


	// website address
	pad = kf_w(8);

	UI_HyperLink *link = new UI_HyperLink(pad, cy, W-pad*2, kf_h(30), URL, URL);
	link->align(FL_ALIGN_CENTER);
	link->labelsize(FL_NORMAL_SIZE * 3 / 2);
	if (alternate_look)
		link->color(FL_LIGHT3, FL_LIGHT3);

	add(link);

	cy += link->h() + kf_h(16);

	SYS_ASSERT(cy < H);


	// finally add an "OK" button
	Fl_Group *darkish = new Fl_Group(0, cy, W, H - cy);
	darkish->end();
	darkish->box(FL_FLAT_BOX);
	if (! alternate_look)
		darkish->color(BUILD_BG, BUILD_BG);

	add(darkish);


	int bw = kf_w(60);
	int bh = kf_h(30);
	int by = H - kf_h(10) - bh;

	Fl_Button *button = new Fl_Button(W/2 - bw/2, by, bw, bh, "OK");
	button->callback(callback_Quit, this);
	darkish->add(button);
}


void DLG_AboutText(void)
{
	static UI_About * about_window = NULL;

	if (! about_window)
	{
		int about_w = kf_w(400);
		int about_h = kf_h(400) + KF * 20;

		about_window = new UI_About(about_w, about_h, "About OBLIGE");
	}

	about_window->want_quit = false;
	about_window->set_modal();
	about_window->show();

	// run the GUI until the user closes
	while (! about_window->WantQuit())
		Fl::wait();

	about_window->set_non_modal();
	about_window->hide();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
